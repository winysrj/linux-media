Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48322
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934567AbdC3UNp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 16:13:45 -0400
Date: Thu, 30 Mar 2017 17:13:34 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Tino Mettler <tino.mettler+debbugs@tikei.de>,
        859008@bugs.debian.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dvb-tools: dvbv5-scan segfaults with DVB-T2 HD service that
 just started in Germany
Message-ID: <20170330171334.06c6135d@vento.lan>
In-Reply-To: <6bc7b007-cc0e-767d-5e2e-30e8d5bdff05@googlemail.com>
References: <149079515540.3615.11876491556658692986.reportbug@mac>
        <06f151f3-0037-dcd0-fc5a-522533f70a3e@googlemail.com>
        <20170329144227.zwrdtnnl4iuhgbkw@mac.home>
        <6bc7b007-cc0e-767d-5e2e-30e8d5bdff05@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

Em Wed, 29 Mar 2017 20:45:06 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello Mauro & list,
> 
> could you please have a look at the dvbv5-scan crash report below?
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=859008
> 
> Is there anything else you need to debug this?

I'm able to reproduce it on a Debian machine here too, but so far,
I was unable to discover what's causing it. I'll try to find some time
to take a better look on it.

> 
> Thanks,
> Gregor
> 
> On 3/29/17 4:42 PM, Tino Mettler wrote:
> > 
> > $ gdb --args ./utils/dvb/dvbv5-scan ~/tmp/dvb-t2/init2 
> > GNU gdb (Debian 7.12-6) 7.12.0.20161007-git
> > Copyright (C) 2016 Free Software Foundation, Inc.
> > License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> > This is free software: you are free to change and redistribute it.
> > There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> > and "show warranty" for details.
> > This GDB was configured as "x86_64-linux-gnu".
> > Type "show configuration" for configuration details.
> > For bug reporting instructions, please see:
> > <http://www.gnu.org/software/gdb/bugs/>.
> > Find the GDB manual and other documentation resources online at:
> > <http://www.gnu.org/software/gdb/documentation/>.
> > For help, type "help".
> > Type "apropos word" to search for commands related to "word"...
> > Reading symbols from ./utils/dvb/dvbv5-scan...done.
> > (gdb) run
> > Starting program: /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan /home/scorpion/tmp/dvb-t2/init2
> > [Thread debugging using libthread_db enabled]
> > Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
> > Scanning frequency #1 554000000
> > Lock   (0x1f) C/N= 23.75dB
> > Service Das Erste HD, provider BR: reserved
> > Service arte HD, provider BR: reserved
> > Service PHOENIX HD, provider BR: reserved
> > Service tagesschau24 HD, provider BR: reserved
> > Service ONE HD, provider BR: reserved
> > New transponder/channel found: #11: -1776415946
> > New transponder/channel found: #12: 504706590
> > New transponder/channel found: #13: 523640360
> > New transponder/channel found: #14: 907948854
> > New transponder/channel found: #15: -397832490
> > New transponder/channel found: #16: 0
> > New transponder/channel found: #17: 0
> > New transponder/channel found: #18: 0
> > New transponder/channel found: #19: 0
> > New transponder/channel found: #20: 0
> > New transponder/channel found: #21: 0
> > New transponder/channel found: #22: 0
> > New transponder/channel found: #23: 0
> > New transponder/channel found: #24: 0
> > New transponder/channel found: #25: 0
> > New transponder/channel found: #26: 0
> > New transponder/channel found: #27: 0
> > New transponder/channel found: #28: 0
> > New transponder/channel found: #29: 0
> > New transponder/channel found: #30: 0
> > New transponder/channel found: #31: 0
> > New transponder/channel found: #32: 0
> > New transponder/channel found: #33: 0
> > New transponder/channel found: #34: 0
> > New transponder/channel found: #35: 0
> > New transponder/channel found: #36: 0
> > New transponder/channel found: #37: 0
> > New transponder/channel found: #38: 0
> > New transponder/channel found: #39: 0
> > New transponder/channel found: #40: 0
> > New transponder/channel found: #41: 0
> > New transponder/channel found: #42: 0
> > New transponder/channel found: #43: 0
> > New transponder/channel found: #44: 0
> > New transponder/channel found: #45: 0
> > New transponder/channel found: #46: 0
> > New transponder/channel found: #47: 0
> > New transponder/channel found: #48: 0
> > New transponder/channel found: #49: 0
> > New transponder/channel found: #50: 0
> > New transponder/channel found: #51: 0
> > New transponder/channel found: #52: 0
> > New transponder/channel found: #53: 0
> > New transponder/channel found: #54: 0
> > New transponder/channel found: #55: 0
> > New transponder/channel found: #56: 0
> > New transponder/channel found: #57: 0
> > New transponder/channel found: #58: 0
> > New transponder/channel found: #59: 0
> > New transponder/channel found: #60: 0
> > New transponder/channel found: #61: 0
> > New transponder/channel found: #62: 0
> > New transponder/channel found: #63: 0
> > New transponder/channel found: #64: 0
> > New transponder/channel found: #65: 0
> > New transponder/channel found: #66: 0
> > New transponder/channel found: #67: 0
> > New transponder/channel found: #68: 0
> > New transponder/channel found: #69: 0
> > New transponder/channel found: #70: 0
> > New transponder/channel found: #71: 0
> > New transponder/channel found: #72: 0
> > New transponder/channel found: #73: 0
> > New transponder/channel found: #74: 0
> > New transponder/channel found: #75: 0
> > Scanning frequency #2 650000000
> >        (0x00) Signal= -69.00dBm
> > Scanning frequency #3 738000000
> >        (0x00) Signal= -76.00dBm
> > Scanning frequency #4 578000000
> > Lock   (0x1f) Signal= -76.00dBm C/N= 27.25dB
> > *** Error in `/home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan': malloc(): memory corruption: 0x00005555557a6b70 ***
> > ======= Backtrace: =========
> > /lib/x86_64-linux-gnu/libc.so.6(+0x70bcb)[0x7ffff759fbcb]
> > /lib/x86_64-linux-gnu/libc.so.6(+0x76f96)[0x7ffff75a5f96]
> > /lib/x86_64-linux-gnu/libc.so.6(+0x78f69)[0x7ffff75a7f69]
> > /lib/x86_64-linux-gnu/libc.so.6(__libc_calloc+0x27b)[0x7ffff75aa99b]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x29e81)[0x55555557de81]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x2b39b)[0x55555557f39b]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x24513)[0x555555578513]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x25dff)[0x555555579dff]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x21ba4)[0x555555575ba4]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x22010)[0x555555576010]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x220b4)[0x5555555760b4]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x214fd)[0x5555555754fd]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x22759)[0x555555576759]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x22c7b)[0x555555576c7b]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x15348)[0x555555569348]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x132fa)[0x5555555672fa]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x11ec7)[0x555555565ec7]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x12941)[0x555555566941]
> > /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7ffff754f2b1]
> > /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan(+0x113ea)[0x5555555653ea]
> > ======= Memory map: ========
> > 555555554000-55555558f000 r-xp 00000000 00:19 6669022                    /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan
> > 55555578e000-555555798000 r--p 0003a000 00:19 6669022                    /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan
> > 555555798000-55555579c000 rw-p 00044000 00:19 6669022                    /home/scorpion/build/9643/v4l-utils/utils/dvb/dvbv5-scan
> > 55555579c000-555555832000 rw-p 00000000 00:00 0                          [heap]
> > 7ffff0000000-7ffff0021000 rw-p 00000000 00:00 0 
> > 7ffff0021000-7ffff4000000 ---p 00000000 00:00 0 
> > 7ffff698f000-7ffff69a5000 r-xp 00000000 08:01 33517                      /lib/x86_64-linux-gnu/libgcc_s.so.1
> > 7ffff69a5000-7ffff6ba4000 ---p 00016000 08:01 33517                      /lib/x86_64-linux-gnu/libgcc_s.so.1
> > 7ffff6ba4000-7ffff6ba5000 r--p 00015000 08:01 33517                      /lib/x86_64-linux-gnu/libgcc_s.so.1
> > 7ffff6ba5000-7ffff6ba6000 rw-p 00016000 08:01 33517                      /lib/x86_64-linux-gnu/libgcc_s.so.1
> > 7ffff6ba6000-7ffff6ba8000 r-xp 00000000 fe:01 6828                       /usr/lib/x86_64-linux-gnu/gconv/ISO8859-15.so
> > 7ffff6ba8000-7ffff6da7000 ---p 00002000 fe:01 6828                       /usr/lib/x86_64-linux-gnu/gconv/ISO8859-15.so
> > 7ffff6da7000-7ffff6da8000 r--p 00001000 fe:01 6828                       /usr/lib/x86_64-linux-gnu/gconv/ISO8859-15.so
> > 7ffff6da8000-7ffff6da9000 rw-p 00002000 fe:01 6828                       /usr/lib/x86_64-linux-gnu/gconv/ISO8859-15.so
> > 7ffff6da9000-7ffff6dab000 r-xp 00000000 fe:01 7652                       /usr/lib/x86_64-linux-gnu/gconv/ISO8859-9.so
> > 7ffff6dab000-7ffff6faa000 ---p 00002000 fe:01 7652                       /usr/lib/x86_64-linux-gnu/gconv/ISO8859-9.so
> > 7ffff6faa000-7ffff6fab000 r--p 00001000 fe:01 7652                       /usr/lib/x86_64-linux-gnu/gconv/ISO8859-9.so
> > 7ffff6fab000-7ffff6fac000 rw-p 00002000 fe:01 7652                       /usr/lib/x86_64-linux-gnu/gconv/ISO8859-9.so
> > 7ffff6fac000-7ffff7312000 r--p 00000000 fe:01 146067                     /usr/lib/locale/locale-archive
> > 7ffff7312000-7ffff732a000 r-xp 00000000 08:01 33682                      /lib/x86_64-linux-gnu/libpthread-2.24.so
> > 7ffff732a000-7ffff7529000 ---p 00018000 08:01 33682                      /lib/x86_64-linux-gnu/libpthread-2.24.so
> > 7ffff7529000-7ffff752a000 r--p 00017000 08:01 33682                      /lib/x86_64-linux-gnu/libpthread-2.24.so
> > 7ffff752a000-7ffff752b000 rw-p 00018000 08:01 33682                      /lib/x86_64-linux-gnu/libpthread-2.24.so
> > 7ffff752b000-7ffff752f000 rw-p 00000000 00:00 0 
> > 7ffff752f000-7ffff76c4000 r-xp 00000000 08:01 33370                      /lib/x86_64-linux-gnu/libc-2.24.so
> > 7ffff76c4000-7ffff78c3000 ---p 00195000 08:01 33370                      /lib/x86_64-linux-gnu/libc-2.24.so
> > 7ffff78c3000-7ffff78c7000 r--p 00194000 08:01 33370                      /lib/x86_64-linux-gnu/libc-2.24.so
> > 7ffff78c7000-7ffff78c9000 rw-p 00198000 08:01 33370                      /lib/x86_64-linux-gnu/libc-2.24.so
> > 7ffff78c9000-7ffff78cd000 rw-p 00000000 00:00 0 
> > 7ffff78cd000-7ffff78d4000 r-xp 00000000 08:01 33715                      /lib/x86_64-linux-gnu/librt-2.24.so
> > 7ffff78d4000-7ffff7ad3000 ---p 00007000 08:01 33715                      /lib/x86_64-linux-gnu/librt-2.24.so
> > 7ffff7ad3000-7ffff7ad4000 r--p 00006000 08:01 33715                      /lib/x86_64-linux-gnu/librt-2.24.so
> > 7ffff7ad4000-7ffff7ad5000 rw-p 00007000 08:01 33715                      /lib/x86_64-linux-gnu/librt-2.24.so
> > 7ffff7ad5000-7ffff7bd8000 r-xp 00000000 08:01 33456                      /lib/x86_64-linux-gnu/libm-2.24.so
> > 7ffff7bd8000-7ffff7dd7000 ---p 00103000 08:01 33456                      /lib/x86_64-linux-gnu/libm-2.24.so
> > 7ffff7dd7000-7ffff7dd8000 r--p 00102000 08:01 33456                      /lib/x86_64-linux-gnu/libm-2.24.so
> > 7ffff7dd8000-7ffff7dd9000 rw-p 00103000 08:01 33456                      /lib/x86_64-linux-gnu/libm-2.24.so
> > 7ffff7dd9000-7ffff7dfc000 r-xp 00000000 08:01 33225                      /lib/x86_64-linux-gnu/ld-2.24.so
> > 7ffff7fad000-7ffff7faf000 rw-p 00000000 00:00 0 
> > 7ffff7faf000-7ffff7fce000 r-xp 00000000 08:01 32792                      /lib/x86_64-linux-gnu/libudev.so.1.6.5
> > 7ffff7fce000-7ffff7fcf000 r--p 0001e000 08:01 32792                      /lib/x86_64-linux-gnu/libudev.so.1.6.5
> > 7ffff7fcf000-7ffff7fd0000 rw-p 0001f000 08:01 32792                      /lib/x86_64-linux-gnu/libudev.so.1.6.5
> > 7ffff7fed000-7ffff7fee000 rw-p 00000000 00:00 0 
> > 7ffff7fee000-7ffff7ff5000 r--s 00000000 fe:01 24377                      /usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache
> > 7ffff7ff5000-7ffff7ff8000 rw-p 00000000 00:00 0 
> > 7ffff7ff8000-7ffff7ffa000 r--p 00000000 00:00 0                          [vvar]
> > 7ffff7ffa000-7ffff7ffc000 r-xp 00000000 00:00 0                          [vdso]
> > 7ffff7ffc000-7ffff7ffd000 r--p 00023000 08:01 33225                      /lib/x86_64-linux-gnu/ld-2.24.so
> > 7ffff7ffd000-7ffff7ffe000 rw-p 00024000 08:01 33225                      /lib/x86_64-linux-gnu/ld-2.24.so
> > 7ffff7ffe000-7ffff7fff000 rw-p 00000000 00:00 0 
> > 7ffffffde000-7ffffffff000 rw-p 00000000 00:00 0                          [stack]
> > ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
> > 
> > Program received signal SIGABRT, Aborted.
> > __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:58
> > 58	../sysdeps/unix/sysv/linux/raise.c: No such file or directory.
> > (gdb) thread apply all bt full
> > 
> > Thread 1 (Thread 0x7ffff7fae480 (LWP 725)):
> > #0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:58
> >         set = {__val = {0, 3472310978873881120, 3467824696600309808, 729636054439574064, 7378645952437315127, 7378645706714656824, 
> >             3472382405132117606, 3467895052413575216, 2319406791620833328, 2319389199435444272, 2314885530818453536, 2314885530818453536, 
> >             2314885530818453536, 746878876138232608, 7378645952437315127, 7378645706714656865}}
> >         pid = <optimized out>
> >         tid = <optimized out>
> > #1  0x00007ffff756340a in __GI_abort () at abort.c:89
> >         save_stage = 2
> >         act = {__sigaction_handler = {sa_handler = 0x666666370a6f732e, sa_sigaction = 0x666666370a6f732e}, sa_mask = {__val = {3472328524770457446, 
> >               7365468305578407725, 8606977229197436518, 3472328296226648109, 3475143045726351408, 7378645556122361904, 3472386794591774310, 
> >               7378697629480725808, 8223625903107106406, 3472328295963438455, 4192904167887482928, 2314885531086893104, 2314885530818453536, 
> >               2314885530818453536, 8312272859592400928, 140737488345280}}, sa_flags = 125, sa_restorer = 0x7fffffffd8c0}
> >         sigs = {__val = {32, 0 <repeats 15 times>}}
> > #2  0x00007ffff759fbd0 in __libc_message (do_abort=do_abort@entry=2, fmt=fmt@entry=0x7ffff7694c30 "*** Error in `%s': %s: 0x%s ***\n")
> >     at ../sysdeps/posix/libc_fatal.c:175
> >         ap = {{gp_offset = 40, fp_offset = 32767, overflow_arg_area = 0x7fffffffd8d0, reg_save_area = 0x7fffffffd860}}
> >         fd = 5
> >         on_2 = <optimized out>
> >         list = <optimized out>
> >         nlist = <optimized out>
> >         cp = <optimized out>
> >         written = <optimized out>
> > #3  0x00007ffff75a5f96 in malloc_printerr (action=3, str=0x7ffff769182b "malloc(): memory corruption", ptr=<optimized out>, ar_ptr=<optimized out>)
> >     at malloc.c:5046
> >         buf = "00005555557a6b70"
> >         cp = <optimized out>
> >         ar_ptr = <optimized out>
> >         ptr = <optimized out>
> >         str = 0x7ffff769182b "malloc(): memory corruption"
> >         action = 3
> > #4  0x00007ffff75a7f69 in _int_malloc (av=av@entry=0x7ffff78c7b00 <main_arena>, bytes=bytes@entry=392) at malloc.c:3509
> >         iters = 0
> >         nb = 400
> >         idx = 25
> >         bin = <optimized out>
> >         victim = 0x5555557a6b60
> >         size = <optimized out>
> >         victim_index = <optimized out>
> >         remainder = <optimized out>
> >         remainder_size = <optimized out>
> >         block = <optimized out>
> >         bit = <optimized out>
> >         map = <optimized out>
> >         fwd = <optimized out>
> >         bck = 0x20040c065034602
> >         errstr = 0x0
> >         __func__ = "_int_malloc"
> > #5  0x00007ffff75aa99b in __libc_calloc (n=<optimized out>, elem_size=<optimized out>) at malloc.c:3271
> >         av = 0x7ffff78c7b00 <main_arena>
> >         oldtop = 0x555555811240
> >         p = <optimized out>
> >         bytes = 392
> >         sz = 392
> >         csz = <optimized out>
> >         oldtopsize = 134592
> >         mem = <optimized out>
> >         clearsize = <optimized out>
> >         nclears = <optimized out>
> >         d = <optimized out>
> >         hook = <optimized out>
> >         __func__ = "__libc_calloc"
> > #6  0x000055555557de81 in dvb_desc_t2_delivery_init (parms=0x55555579e0c0, buf=0x5555557a0dab "", ext=0x5555557a6b10, desc=0x5555557a6b50)
> >     at descriptors/desc_t2_delivery.c:65
> >         d = 0x5555557a6b50
> >         p = 0x5555557a0df0 "1\377\002\323D@\002\337y@\002\353\256@\003\064\354@\003e\300@\003~*@\003\212_@\003\226\224@\003\242\311@\003\307h@\004\004q@\003q\365@l\264\002AC1\a\225\"", <incomplete sequence \307>
> >         desc_len = 68
> >         len = 63
> >         len2 = 5
> >         i = 21845
> >         __func__ = "dvb_desc_t2_delivery_init"
> > #7  0x000055555557f39b in dvb_extension_descriptor_init (parms=0x55555579e0c0, buf=0x5555557a0daa "\004", desc=0x5555557a6b10)
> >     at descriptors/desc_extension.c:155
> >         ext = 0x5555557a6b10
> >         p = 0x5555557a0dab ""
> >         desc_type = 4
> >         size = 23
> >         desc_len = 68
> >         init = 0x55555557dcf1 <dvb_desc_t2_delivery_init>
> > #8  0x0000555555578513 in dvb_desc_parse (parms=0x55555579e0c0, buf=0x5555557a0da8 "\177E\004", buflen=321, head_desc=0x5555557a6b36)
> >     at descriptors.c:194
> >         desc_type = 127 '\177'
> >         desc_len = 69 'E'
> >         size = 19
> >         init = 0x55555557f1bb <dvb_extension_descriptor_init>
> >         ptr = 0x5555557a0daa "\004"
> >         endbuf = 0x5555557a0ee9 "q8\314j"
> >         current = 0x5555557a6b10
> >         last = 0x0
> >         __func__ = "dvb_desc_parse"
> > #9  0x0000555555579dff in dvb_table_nit_init (parms=0x55555579e0c0, buf=0x5555557a0d90 "@\361Z0", <incomplete sequence \351>, buflen=345, 
> >     table=0x5555557b4170) at tables/nit.c:116
> >         desc_length = 321
> >         transport = 0x5555557a6b30
> >         p = 0x5555557a0da8 "\177E\004"
> >         endbuf = 0x5555557a0ee9 "q8\314j"
> >         nit = 0x5555557a6a90
> >         head = 0x5555557a6b3e
> >         head_desc = 0x5555557a6a9a
> >         size = 6
> >         __func__ = "dvb_table_nit_init"
> > #10 0x0000555555575ba4 in dvb_parse_section (parms=0x55555579e0c0, sect=0x7fffffffdcc0, buf=0x5555557a0d90 "@\361Z0", <incomplete sequence \351>, 
> >     buf_length=349) at dvb-scan.c:275
> >         h = {table_id = 64 '@', {bitfield = 61786, {section_length = 346, one = 3 '\003', zero = 1 '\001', syntax = 1 '\001'}}, id = 12290, 
> >           current_next = 1 '\001', version = 20 '\024', one2 = 3 '\003', section_id = 0 '\000', last_section = 0 '\000'}
> >         priv = 0x5555557a89f0
> >         ext = 0x5555557b3eb0
> >         tid = 64 '@'
> >         i = 0
> >         new = 1
> >         __func__ = "dvb_parse_section"
> > #11 0x0000555555576010 in dvb_read_sections (__p=0x55555579e0c0, dmx_fd=4, sect=0x7fffffffdcc0, timeout=12) at dvb-scan.c:374
> >         available = 1
> >         crc = 0
> >         buf_length = 349
> >         parms = 0x55555579e0c0
> >         ret = 0
> >         buf = 0x5555557a0d90 "@\361Z0", <incomplete sequence \351>
> >         mask = 255 '\377'
> >         __func__ = "dvb_read_sections"
> > #12 0x00005555555760b4 in dvb_read_section_with_id (parms=0x55555579e0c0, dmx_fd=4, tid=64 '@', pid=16, ts_id=-1, table=0x5555557b4170, timeout=12)
> >     at dvb-scan.c:399
> >         tab = {tid = 64 '@', pid = 16, ts_id = -1, table = 0x5555557b4170, allow_section_gaps = 0, priv = 0x5555557a89f0}
> > #13 0x00005555555754fd in dvb_read_section (parms=0x55555579e0c0, dmx_fd=4, tid=64 '@', pid=16, table=0x5555557b4170, timeout=12) at dvb-scan.c:102
> > No locals.
> > #14 0x0000555555576759 in dvb_get_ts_tables (__p=0x55555579e0c0, dmx_fd=4, delivery_system=16, other_nit=0, timeout_multiply=1) at dvb-scan.c:572
> >         parms = 0x55555579e0c0
> >         rc = 0
> >         pat_pmt_time = 1
> >         sdt_time = 2
> >         nit_time = 12
> >         vct_time = 1434050752
> >         atsc_filter = 0
> >         num_pmt = 5
> >         dvb_scan_handler = 0x5555557b4140
> > #15 0x0000555555576c7b in dvb_scan_transponder (__p=0x55555579e0c0, entry=0x5555557a8fe0, dmx_fd=4, check_frontend=0x555555565a93 <check_frontend>, 
> >     args=0x7fffffffdff0, other_nit=0, timeout_multiply=1) at dvb-scan.c:680
> >         parms = 0x55555579e0c0
> >         dvb_scan_handler = 0x0
> >         freq = 578000000
> >         delsys = 16
> >         i = 11
> >         rc = 0
> > #16 0x0000555555569348 in dvb_local_scan (open_dev=0x5555557b3fe0, entry=0x5555557a8fe0, check_frontend=0x555555565a93 <check_frontend>, 
> >     args=0x7fffffffdff0, other_nit=0, timeout_multiply=1) at dvb-dev-local.c:734
> >         dev = 0x5555557a84e0
> >         dvb = 0x55555579df90
> >         parms = 0x55555579e0c0
> >         desc = 0x0
> >         fd = 4
> > #17 0x00005555555672fa in dvb_dev_scan (open_dev=0x5555557b3fe0, entry=0x5555557a8fe0, check_frontend=0x555555565a93 <check_frontend>, 
> >     args=0x7fffffffdff0, other_nit=0, timeout_multiply=1) at dvb-dev.c:317
> >         dvb = 0x55555579df90
> >         ops = 0x55555579dfa8
> > #18 0x0000555555565ec7 in run_scan (args=0x7fffffffdff0, dvb=0x55555579df90) at dvbv5-scan.c:298
> >         dvb_scan_handler = 0x0
> >         stream_id = 0
> >         parms = 0x55555579e0c0
> >         dvb_file = 0x55555579fc90
> >         dvb_file_new = 0x5555557b33a0
> >         entry = 0x5555557a8fe0
> >         dmx_fd = 0x5555557b3fe0
> >         count = 4
> >         shift = 1000000
> >         freq = 578000000
> >         sys = 0
> >         pol = POLARIZATION_OFF
> > #19 0x0000555555566941 in main (argc=2, argv=0x7fffffffe188) at dvbv5-scan.c:562
> >         args = {confname = 0x7fffffffe459 "/home/scorpion/tmp/dvb-t2/init2", lnb_name = 0x0, output = 0x555555582de4 "dvb_channel.conf", 
> >           demux_dev = 0x5555557b34f0 "dvb0.demux0", adapter = 4294967295, n_adapter = 0, adapter_fe = 0, adapter_dmx = 0, frontend = 0, demux = 0, 
> >           get_detected = 0, get_nit = 0, lna = -1, lnb = 0, sat_number = -1, freq_bpf = 0, diseqc_wait = 0, dont_add_new_freqs = 0, 
> >           timeout_multiply = 1, other_nit = 0, input_format = FILE_DVBV5, output_format = FILE_DVBV5, cc = 0x0, n_status_lines = 1}
> >         err = 0
> >         lnb = -1
> >         idx = 1
> >         dvb = 0x55555579df90
> >         dvb_dev = 0x5555557a8570
> >         parms = 0x55555579e0c0
> >         argp = {options = 0x55555578e7c0 <options>, parser = 0x555555565fd9 <parse_opt>, args_doc = 0x555555582d88 "<initial file>", 
> >           doc = 0x555555582d98 "scan DVB services using the channel file", children = 0x0, help_filter = 0x0, argp_domain = 0x0}
> > (gdb) 
> >   
> 


-- 
Thanks,
Mauro
