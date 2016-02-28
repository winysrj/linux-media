Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34752 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbcB1IaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 03:30:08 -0500
Received: by mail-qk0-f180.google.com with SMTP id x1so46764305qkc.1
        for <linux-media@vger.kernel.org>; Sun, 28 Feb 2016 00:30:08 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 28 Feb 2016 19:30:07 +1100
Message-ID: <CAOriPhL9ysCYkTZ17Av1UNp6fRz=XcO-RwSYowbrj9Hf9St_3A@mail.gmail.com>
Subject: dvbv5-scan from master branch (and earlier versions) seg faulting on
 debian jessie - armv5tel architecture
From: Paul Freeman <pfcomptech@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
First, let me apologize for what is a long post.  I am trying to
provide as much relevant information as I can think of.

Now, to the problem.

I am running the latest (at least very recent) debian jessie on a QNAP
TS-419.  Details below:

uname -a
Linux freenas-01 3.16.0-4-kirkwood #1 Debian 3.16.7-ckt20-1+deb8u3
(2016-01-17) armv5tel GNU/Linux

cat /proc/cpuinfo
processor    : 0
model name    : Feroceon 88FR131 rev 1 (v5l)
BogoMIPS    : 1587.20
Features    : swp half thumb fastmult edsp
CPU implementer    : 0x56
CPU architecture: 5TE
CPU variant    : 0x2
CPU part    : 0x131
CPU revision    : 1

Hardware    : QNAP TS-41x
Revision    : 0000
Serial        : 0000000000000000

gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/arm-linux-gnueabi/4.9/lto-wrapper
Target: arm-linux-gnueabi
Configured with: ../src/configure -v --with-pkgversion='Debian
4.9.2-10' --with-bugurl=file:///usr/share/doc/gcc-4.9/README.Bugs
--enable-languages=c,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr
--program-suffix=-4.9 --enable-shared --enable-linker-build-id
--libexecdir=/usr/lib --without-included-gettext
--enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.9
--libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu
--enable-libstdcxx-debug --enable-libstdcxx-time=yes
--enable-gnu-unique-object --disable-libitm --disable-libquadmath
--enable-plugin --with-system-zlib --disable-browser-plugin
--enable-java-awt=gtk --enable-gtk-cairo
--with-java-home=/usr/lib/jvm/java-1.5.0-gcj-4.9-armel/jre
--enable-java-home
--with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-4.9-armel
--with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-4.9-armel
--with-arch-directory=arm
--with-ecj-jar=/usr/share/java/eclipse-ecj.jar --enable-objc-gc
--enable-multiarch --disable-sjlj-exceptions --with-arch=armv4t
--with-float=soft --enable-checking=release --build=arm-linux-gnueabi
--host=arm-linux-gnueabi --target=arm-linux-gnueabi
Thread model: posix
gcc version 4.9.2 (Debian 4.9.2-10)


The system is running tvheadend using a Leadtek WinFast DTV Dongle
Dual USB DVB-T tuner.  This is working successfully.

However, during testing I needed to get a scan from one of the tuners
so I installed the debian version of v4l-utils (1.6.0) to run
dvbv5-scan.  I found dvbv5-scan kept seg faulting.  I installed v1.8.0
with the same result.  I also built the master branch on the host from
v4l-utils git (1.10.0) with the same results.

w_scan works fine as do the scanning functions in tvheadend so it
doesn't appear to be an issue with the kernel driver for this tuner,
the device firmware or underlying hardware.

I have done some investigating using gdb on a non-optimized,
non-stripped, statically linked version of dvbv5-scan and have found
the seg fault (SIGSEGV) first occurs in lib/libdvbv5/tables/pat.c on
the second iteration of while (p + size <= endbuf) { code in line 96
in the assigment *head = prog.

I am fairly confident (I am not proficient with gdb or coding but am
learning fast) the problem is occurring in the assignment *head = prog
during the first iteration of the while section.  Printing the
contents of struct pat before and after the assignment shows a
corruption of memory which means the values of pat-programs and
pat->programs are incorrect.

Excerpt from gdb session follows:
(gdb) p prog
$2 = (struct dvb_table_pat_program *) 0x58418
(gdb) p pat
$3 = (struct dvb_table_pat *) 0x55510

(gdb) p &head
$4 = (struct dvb_table_pat_program ***) 0xbefff358
(gdb) p sizeof(head)
$5 = 4
(gdb) x/4xw 0xbefff358
0xbefff358:    0x0005551a    0x0005741c    0xbefff3a4    0x00020b68

(gdb) p *pat
$11 = {header = {table_id = 0 '\000', {bitfield = 45101,
{section_length = 45, one = 3 '\003', zero = 0 '\000', syntax = 1
'\001'}},
    id = 1283, current_next = 1 '\001', version = 19 '\023', one2 = 3
'\003', section_id = 0 '\000', last_section = 0 '\000'},
  programs = 1, program = 0x0}
(gdb) x/14xh 0x55510
0x55510:    0x2d00    0x03b0    0xe705    0x0000    0x0001    0x0000
 0x0000    0x0000
0x55520:    0x0000    0x0000    0x0000    0x0000    0x0000    0x0000
(gdb) n
96            *head = prog;
(gdb) n
97            head = &(*head)->next;
(gdb) x/14xh 0x55510
0x55510:    0x2d00    0x03b0    0xe705    0x0000    0x8418    0x0005
 0x0000    0x0000
0x55520:    0x0000    0x0000    0x0000    0x0000    0x0000    0x0000
(gdb) p *pat
$9 = {header = {table_id = 0 '\000', {bitfield = 45101,
{section_length = 45, one = 3 '\003', zero = 0 '\000', syntax = 1
'\001'}},
    id = 1283, current_next = 1 '\001', version = 19 '\023', one2 = 3
'\003', section_id = 0 '\000', last_section = 0 '\000'},
  programs = 33816, program = 0x5}

>From my understanding of the code I think pat->programs should be
unchanged while pat->program should have changed from 0x0 to 0x58418.

Looking at lib/include/libdvbv5/pat.h I see that
__attribute__((packed)) is used in the definition of struct
dvb_table_pat as well as many other structs in this file and
directory.

I am wondering whether alignment errors are occurring causing the
value 0x58418 to be written 2 bytes before it should.  This could be
repeated in any places where __attribute_((packed)) is used in struct
definitions and pointer arithmetic is used.

If I remove that from the definition of dvb_table_pat and re-compile
the code it executes without error until it gets to tables/pmt.c line
113 where a similar SIGSEGV situation occurs (*head = stream).
Removing all instances of __attribute__((packed)) from the definitions
fixes this problem until another SIGSEGV occurs. etc, etc.

For interests sake, within gdb, I tried "set *head = prog" before
executing line 96 in tables/pat.c and surprisingly found this worked
as it should have.  pat->programs = 1 and pat->programs = 0x58418.  As
soon as line 96 (*head = prog) is executed by gdb the problem occurs
and pat->programs = 33816 and pat->program = 0x5.  This makes me
wonder whether the code generated by gcc 4.9.2 with the given
parameters/settings isn't doing the correct thing whereas gdb can when
the using the set command.

Does this sound feasible as an explanation for the problem and has
anyone else come across this on this architecture?  Is there a
workaround?

I look forward to hearing your comments.

If you need further information please do not hesitate to contact me.

Thanks in advance

Paul
