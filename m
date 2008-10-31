Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9VHxWq6010878
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 13:59:32 -0400
Received: from QMTA05.westchester.pa.mail.comcast.net
	(qmta05.westchester.pa.mail.comcast.net [76.96.62.48])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9VHwlbr019623
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 13:58:48 -0400
Message-ID: <490B475C.10508@personnelware.com>
Date: Fri, 31 Oct 2008 12:58:52 -0500
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <4908CB31.6040707@personnelware.com>
In-Reply-To: <4908CB31.6040707@personnelware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: capture.c memory leak
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Looks like there is a memory leak in the v4l2 example code:
http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/capture-example.html
==5166== malloc/free: 5 allocs, 0 frees, 2,457,632 bytes allocated.
(see valgrind below)

Should this be reported to http://bugzilla.kernel.org?

There also seems to be a problem with the way it handles "application allocated
buffers" which is when it eats memory.

or maybe it's a problem with vivi:
http://linuxtv.org/hg/v4l-dvb/file/50e4cdc46320/linux/drivers/media/video/vivi.c

$ ./capture --userp -d /dev/video1
VIDIOC_QBUF error 22, Invalid argument

I would think this error should kick in:

init_userp                      (unsigned int           buffer_size)
        req.count               = 4;
        req.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        req.memory              = V4L2_MEMORY_USERPTR;
        if (-1 == xioctl (fd, VIDIOC_REQBUFS, &req)) {
                if (EINVAL == errno) {
                        fprintf (stderr, "%s does not support "
                                 "user pointer i/o\n", dev_name);
                        exit (EXIT_FAILURE);


but instead it errors here:

start_capturing                 (void)
        case IO_METHOD_USERPTR:
                        if (-1 == xioctl (fd, VIDIOC_QBUF, &buf))
                                errno_exit ("VIDIOC_QBUF");

wget http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/v4l2spec/capture.c
gcc capture.c -g -o capture

juser@dhcp186:~/vga2usb/v4l.org/examples$ sudo modprobe vivi
juser@dhcp186:~/vga2usb/v4l.org/examples$ dmesg | grep /dev/video1
[ 1015.491550] vivi: V4L2 device registered as /dev/video1

juser@dhcp186:~/vga2usb/v4l.org/examples$ valgrind -v --leak-check=full
--show-reachable=yes ./capture --userp -d /dev/video1

==5166== Memcheck, a memory error detector.
==5166== Copyright (C) 2002-2007, and GNU GPL'd, by Julian Seward et al.
==5166== Using LibVEX rev 1854, a library for dynamic binary translation.
==5166== Copyright (C) 2004-2007, and GNU GPL'd, by OpenWorks LLP.
==5166== Using valgrind-3.3.1-Debian, a dynamic binary instrumentation framework.
==5166== Copyright (C) 2000-2007, and GNU GPL'd, by Julian Seward et al.
==5166==
--5166-- Command line
--5166--    ./capture
--5166--    --userp
--5166--    -d
--5166--    /dev/video1
--5166-- Startup, with flags:
--5166--    --suppressions=/usr/lib/valgrind/debian-libc6-dbg.supp
--5166--    -v
--5166--    --leak-check=full
--5166--    --show-reachable=yes
--5166-- Contents of /proc/version:
--5166--   Linux version 2.6.27-7-generic (buildd@palmer) (gcc version 4.3.2
(Ubuntu 4.3.2-1ubuntu11) ) #1 SMP Thu Oct 30 04:18:38 UTC 2008
--5166-- Arch and hwcaps: X86, x86-sse1-sse2
--5166-- Page sizes: currently 4096, max supported 4096
--5166-- Valgrind library directory: /usr/lib/valgrind
--5166-- Reading syms from /lib/ld-2.8.90.so (0x4000000)
--5166-- Reading debug info from /lib/ld-2.8.90.so...
--5166-- ... CRC mismatch (computed 371b8ee6 wanted cc0a418a)
--5166-- Reading debug info from /usr/lib/debug/lib/ld-2.8.90.so...
--5166-- Reading syms from /home/juser/vga2usb/v4l.org/examples/capture (0x8048000)
--5166-- Reading syms from /usr/lib/valgrind/x86-linux/memcheck (0x38000000)
--5166--    object doesn't have a dynamic symbol table
--5166-- Reading suppressions file: /usr/lib/valgrind/debian-libc6-dbg.supp
--5166-- Reading suppressions file: /usr/lib/valgrind/default.supp
--5166-- REDIR: 0x40155d0 (index) redirected to 0x3802cf63
(vgPlain_x86_linux_REDIR_FOR_index)
--5166-- Reading syms from /usr/lib/valgrind/x86-linux/vgpreload_core.so (0x401F000)
--5166-- Reading syms from /usr/lib/valgrind/x86-linux/vgpreload_memcheck.so
(0x4022000)
==5166== WARNING: new redirection conflicts with existing -- ignoring it
--5166--     new: 0x040155d0 (index               ) R-> 0x040261a0 index
--5166-- REDIR: 0x40157c0 (strlen) redirected to 0x4026450 (strlen)
--5166-- Reading syms from /usr/lib/debug/libc-2.8.90.so (0x402A000)
--5166-- REDIR: 0x409d2f0 (rindex) redirected to 0x4026080 (rindex)
--5166-- REDIR: 0x409cf00 (strlen) redirected to 0x4026430 (strlen)
--5166-- REDIR: 0x409d110 (strncmp) redirected to 0x40266a0 (strncmp)
--5166-- REDIR: 0x409c7e0 (index) redirected to 0x4026170 (index)
--5166-- REDIR: 0x409df70 (memset) redirected to 0x4027340 (memset)
--5166-- REDIR: 0x4099c50 (calloc) redirected to 0x4023d20 (calloc)
--5166-- REDIR: 0x409a190 (memalign) redirected to 0x4023b80 (memalign)
--5166-- REDIR: 0x409e490 (memcpy) redirected to 0x40268a0 (memcpy)
--5166-- REDIR: 0x409e180 (stpcpy) redirected to 0x40270d0 (stpcpy)
--5166-- REDIR: 0x409dfd0 (mempcpy) redirected to 0x4027470 (mempcpy)
--5166-- REDIR: 0x409f010 (strchrnul) redirected to 0x4027410 (strchrnul)

VIDIOC_QBUF error 22, Invalid argument

--5166-- REDIR: 0x4097730 (free) redirected to 0x4024a90 (free)
==5166==
==5166== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 11 from 1)
--5166--
--5166-- supp:     11 dl-hack3-cond-1
==5166== malloc/free: in use at exit: 2,457,632 bytes in 5 blocks.
==5166== malloc/free: 5 allocs, 0 frees, 2,457,632 bytes allocated.
==5166==
==5166== searching for pointers to 5 not-freed blocks.
==5166== checked 51,772 bytes.
==5166==
==5166== 32 bytes in 1 blocks are still reachable in loss record 1 of 2
==5166==    at 0x4023DE2: calloc (vg_replace_malloc.c:397)
==5166==    by 0x80494AF: init_userp (in
/home/juser/vga2usb/v4l.org/examples/capture)
==5166==    by 0x80498B0: init_device (in
/home/juser/vga2usb/v4l.org/examples/capture)
==5166==    by 0x8049B63: main (in /home/juser/vga2usb/v4l.org/examples/capture)
==5166==
==5166==
==5166== 2,457,600 bytes in 4 blocks are still reachable in loss record 2 of 2
==5166==    at 0x4023C4A: memalign (vg_replace_malloc.c:460)
==5166==    by 0x8049536: init_userp (in
/home/juser/vga2usb/v4l.org/examples/capture)
==5166==    by 0x80498B0: init_device (in
/home/juser/vga2usb/v4l.org/examples/capture)
==5166==    by 0x8049B63: main (in /home/juser/vga2usb/v4l.org/examples/capture)
==5166==
==5166== LEAK SUMMARY:
==5166==    definitely lost: 0 bytes in 0 blocks.
==5166==      possibly lost: 0 bytes in 0 blocks.
==5166==    still reachable: 2,457,632 bytes in 5 blocks.
==5166==         suppressed: 0 bytes in 0 blocks.
--5166--  memcheck: sanity checks: 0 cheap, 1 expensive
--5166--  memcheck: auxmaps: 0 auxmap entries (0k, 0M) in use
--5166--  memcheck: auxmaps_L1: 0 searches, 0 cmps, ratio 0:10
--5166--  memcheck: auxmaps_L2: 0 searches, 0 nodes
--5166--  memcheck: SMs: n_issued      = 10 (160k, 0M)
--5166--  memcheck: SMs: n_deissued    = 0 (0k, 0M)
--5166--  memcheck: SMs: max_noaccess  = 65535 (1048560k, 1023M)
--5166--  memcheck: SMs: max_undefined = 34 (544k, 0M)
--5166--  memcheck: SMs: max_defined   = 20 (320k, 0M)
--5166--  memcheck: SMs: max_non_DSM   = 10 (160k, 0M)
--5166--  memcheck: max sec V bit nodes:    0 (0k, 0M)
--5166--  memcheck: set_sec_vbits8 calls: 0 (new: 0, updates: 0)
--5166--  memcheck: max shadow mem size:   464k, 0M
--5166-- translate:            fast SP updates identified: 1,933 ( 89.4%)
--5166-- translate:   generic_known SP updates identified: 128 (  5.9%)
--5166-- translate: generic_unknown SP updates identified: 100 (  4.6%)
--5166--     tt/tc: 4,312 tt lookups requiring 4,351 probes
--5166--     tt/tc: 4,312 fast-cache updates, 3 flushes
--5166--  transtab: new        2,035 (43,121 -> 617,673; ratio 143:10) [0 scs]
--5166--  transtab: dumped     0 (0 -> ??)
--5166--  transtab: discarded  8 (200 -> ??)
--5166-- scheduler: 25,512 jumps (bb entries).
--5166-- scheduler: 0/2,355 major/minor sched events.
--5166--    sanity: 1 cheap, 1 expensive checks.
--5166--    exectx: 769 lists, 8 contexts (avg 0 per list)
--5166--    exectx: 16 searches, 8 full compares (500 per 1000)
--5166--    exectx: 4 cmp2, 26 cmp4, 0 cmpAll
--5166--  errormgr: 8 supplist searches, 271 comparisons during search
--5166--  errormgr: 11 errlist searches, 26 comparisons during search

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
