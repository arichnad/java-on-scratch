
java on scratch
---------------

java in docker with busybox . . . only.

* 2mb with static busybox
* 3mb with dynamic busybox
* 190mb jre only
* 405mb with jdk

just downloads some ubuntu binaries.  the busybox binaries are just checked in.

using
-----

`docker build -t busybox . && docker run -it --rm busybox sh -c 'echo "public class HelloWorld {public static void main(String[] args) {System.out.println(\"hello world!\");}}" >HelloWorld.java && javac HelloWorld.java && java HelloWorld'`


