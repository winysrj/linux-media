Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34783 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbbETN5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 09:57:36 -0400
Received: by pdbnk13 with SMTP id nk13so69960005pdb.1
        for <linux-media@vger.kernel.org>; Wed, 20 May 2015 06:57:35 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 May 2015 15:57:34 +0200
Message-ID: <CAG_g8w4Q2bQFLV757rz5zU0OXNd3UMn-hxsdH0q-n6n+WSiGqQ@mail.gmail.com>
Subject: ir-keytable: coredump
From: crow <crow@linux.org.ba>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am facing oft the ir-keytable crash with an coredump and mostly I
need to reboot whole device to have remote working again.
Note that here it creates coredump on an device which i actually not
use. On the Tevii USB S650 IR (IR-receiver inside an USB DVB re) which
is recognised as the rc1.

Here is the coredump and also on an paste page [1] for better reading.
Someone have any suggestion to solve this issue?

$ sudo ir-keytable -v
Found device /sys/class/rc/rc0/
Found device /sys/class/rc/rc1/
Input sysfs node is /sys/class/rc/rc0/input7/
Event sysfs node is /sys/class/rc/rc0/input7/event4/
Parsing uevent /sys/class/rc/rc0/input7/event4/uevent
/sys/class/rc/rc0/input7/event4/uevent uevent MAJOR=13
/sys/class/rc/rc0/input7/event4/uevent uevent MINOR=68
/sys/class/rc/rc0/input7/event4/uevent uevent DEVNAME=input/event4
Parsing uevent /sys/class/rc/rc0/uevent
/sys/class/rc/rc0/uevent uevent NAME=rc-medion-x10
/sys/class/rc/rc0/uevent uevent DRV_NAME=ati_remote
input device is /dev/input/event4
/sys/class/rc/rc0/protocols protocol other (disabled)
Found /sys/class/rc/rc0/ (/dev/input/event4) with:
        Driver ati_remote, table rc-medion-x10
        Supported protocols: other
        Enabled protocols:
        Name: X10 Wireless Technology Inc USB
        bus: 3, vendor/product: 0bc7:0006, version: 0x0100
        Repeat delay = 500 ms, repeat period = 125 ms
Input sysfs node is /sys/class/rc/rc1/input9/
Event sysfs node is /sys/class/rc/rc1/input9/event6/
Parsing uevent /sys/class/rc/rc1/input9/event6/uevent
/sys/class/rc/rc1/input9/event6/uevent uevent MAJOR=13
/sys/class/rc/rc1/input9/event6/uevent uevent MINOR=70
/sys/class/rc/rc1/input9/event6/uevent uevent DEVNAME=input/event6
Parsing uevent /sys/class/rc/rc1/uevent
/sys/class/rc/rc1/uevent uevent NAME=rc-tevii-nec
/sys/class/rc/rc1/uevent uevent DRV_NAME=dw2102
input device is /dev/input/event6
/sys/class/rc/rc1/protocols protocol nec (disabled)
Found /sys/class/rc/rc1/ (/dev/input/event6) with:
        Driver dw2102, table rc-tevii-nec
        Supported protocols: NEC
        Enabled protocols:
        Name: IR-receiver inside an USB DVB re
        bus: 3, vendor/product: 9022:d650, version: 0x0000
        Repeat delay = 500 ms, repeat period = 125 ms
$

$ sudo coredumpctl
TIME                            PID   UID   GID SIG PRESENT EXE
Mon 2015-05-18 11:55:13 CEST    233     0     0  11 * /usr/bin/ir-keytable
Mon 2015-05-18 21:13:02 CEST    271     0     0  11 * /usr/bin/ir-keytable
Tue 2015-05-19 15:07:00 CEST    289     0     0  11 * /usr/bin/ir-keytable

$ sudo coredumpctl dump 289 -o core
           PID: 289 (ir-keytable)
           UID: 0 (root)
           GID: 0 (root)
        Signal: 11 (SEGV)
     Timestamp: Tue 2015-05-19 15:07:00 CEST (17h ago)
  Command Line: /usr/bin/ir-keytable -a /etc/rc_maps.cfg -s rc1
    Executable: /usr/bin/ir-keytable
 Control Group: /system.slice/systemd-udevd.service
          Unit: systemd-udevd.service
         Slice: system.slice
       Boot ID: fde764562af24d44ac635df240384c8e
    Machine ID: df40478810164b36a96f528b0ec05287
      Hostname: vdrvdpau
      Coredump:
/var/lib/systemd/coredump/core.ir-keytable.0.fde764562af24d44ac635df240384c8e.289.1432040820000000.lz4
       Message: Process 289 (ir-keytable) of user 0 dumped core.
More than one entry matches, ignoring rest.

$ sudo coredumpctl gdb 289
           PID: 289 (ir-keytable)
           UID: 0 (root)
           GID: 0 (root)
        Signal: 11 (SEGV)
     Timestamp: Tue 2015-05-19 15:07:00 CEST (17h ago)
  Command Line: /usr/bin/ir-keytable -a /etc/rc_maps.cfg -s rc1
    Executable: /usr/bin/ir-keytable
 Control Group: /system.slice/systemd-udevd.service
          Unit: systemd-udevd.service
         Slice: system.slice
       Boot ID: fde764562af24d44ac635df240384c8e
    Machine ID: df40478810164b36a96f528b0ec05287
      Hostname: vdrvdpau
      Coredump:
/var/lib/systemd/coredump/core.ir-keytable.0.fde764562af24d44ac635df240384c8e.289.1432040820000000.lz4
       Message: Process 289 (ir-keytable) of user 0 dumped core.

GNU gdb (GDB) 7.9.1
Copyright (C) 2015 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-unknown-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from /usr/bin/ir-keytable...Reading symbols from
/usr/lib/debug/usr/bin/ir-keytable.debug...done.
done.
[New LWP 289]

warning: Could not load shared library symbols for linux-vdso.so.1.
Do you need "set solib-search-path" or "set sysroot"?
Core was generated by `/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s rc1'.
Program terminated with signal SIGSEGV, Segmentation fault.
#0  free_names (names=names@entry=0x0) at keytable.c:538
538                     if (old->name)
(gdb) bt
#0  free_names (names=names@entry=0x0) at keytable.c:538
#1  0x00000000004046fa in get_attribs (rc_dev=0x7ffc6632a180,
sysfs_name=<optimized out>) at keytable.c:1093
#2  0x000000000040115a in main (argc=<optimized out>, argv=<optimized
out>) at keytable.c:1577
(gdb) bt full
#0  free_names (names=names@entry=0x0) at keytable.c:538
        old = 0x0
#1  0x00000000004046fa in get_attribs (rc_dev=0x7ffc6632a180,
sysfs_name=<optimized out>) at keytable.c:1093
        input_names = 0x1c62090
        event_names = 0x0
        attribs = 0x0
        uevent = <optimized out>
        cur = 0x0
        sysfs_name = <optimized out>
        rc_dev = 0x7ffc6632a180
        input = 0x404f89 "input"
        event = 0x404e03 "event"
        DEV = <synthetic pointer>
        input_names = 0x1c62090
        event_names = 0x0
        attribs = 0x0
        cur = 0x0
#2  0x000000000040115a in main (argc=<optimized out>, argv=<optimized
out>) at keytable.c:1577
        dev_from_class = 0
        write_cnt = 0
        names = 0x1c620b0
        rc_dev = {sysfs_name = 0x1c62070 "/sys/class/rc/rc1/",
input_name = 0x0, drv_name = 0x0, keytable_name = 0x0, version =
VERSION_1, type = UNKNOWN_TYPE, supported = 0,
          current = 0}
(gdb) info threads
  Id   Target Id         Frame
* 1    LWP 289           free_names (names=names@entry=0x0) at keytable.c:538
(gdb) thread apply all bt

Thread 1 (LWP 289):
#0  free_names (names=names@entry=0x0) at keytable.c:538
#1  0x00000000004046fa in get_attribs (rc_dev=0x7ffc6632a180,
sysfs_name=<optimized out>) at keytable.c:1093
#2  0x000000000040115a in main (argc=<optimized out>, argv=<optimized
out>) at keytable.c:1577
(gdb) thread apply all bt full

Thread 1 (LWP 289):
#0  free_names (names=names@entry=0x0) at keytable.c:538
        old = 0x0
#1  0x00000000004046fa in get_attribs (rc_dev=0x7ffc6632a180,
sysfs_name=<optimized out>) at keytable.c:1093
        input_names = 0x1c62090
        event_names = 0x0
        attribs = 0x0
        uevent = <optimized out>
        cur = 0x0
        sysfs_name = <optimized out>
        rc_dev = 0x7ffc6632a180
        input = 0x404f89 "input"
        event = 0x404e03 "event"
        DEV = <synthetic pointer>
        input_names = 0x1c62090
        event_names = 0x0
        attribs = 0x0
        cur = 0x0
#2  0x000000000040115a in main (argc=<optimized out>, argv=<optimized
out>) at keytable.c:1577
        dev_from_class = 0
        write_cnt = 0
        names = 0x1c620b0
        rc_dev = {sysfs_name = 0x1c62070 "/sys/class/rc/rc1/",
input_name = 0x0, drv_name = 0x0, keytable_name = 0x0, version =
VERSION_1, type = UNKNOWN_TYPE, supported = 0,
          current = 0}
(gdb) l
533     {
534             struct sysfs_names *old;
535             do {
536                     old = names;
537                     names = names->next;
538                     if (old->name)
539                             free(old->name);
540                     free(old);
541             } while (names);
542     }
(gdb) q
$

$ sudo pacman -Qi v4l-utils
Name           : v4l-utils
Version        : 1.6.2-1
Description    : Userspace tools and conversion library for Video 4 Linux
Architecture   : x86_64
URL            : http://linuxtv.org/
Licenses       : LGPL
Groups         : None
Provides       : libv4l=1.6.2
Depends On     : glibc  gcc-libs  sysfsutils  libjpeg-turbo
Optional Deps  : qt4 [installed]
Required By    : ffmpeg  v4l-utils-debug
Optional For   : None
Conflicts With : libv4l
Replaces       : libv4l
Installed Size :   2.22 MiB
Packager       : Unknown Packager
Build Date     : Thu 07 May 2015 09:00:03 PM CEST
Install Date   : Thu 07 May 2015 09:07:18 PM CEST
Install Reason : Installed as a dependency for another package
Install Script : No
Validated By   : None


[1] http://sprunge.us/IIED
