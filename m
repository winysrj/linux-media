Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.mail.fcom.ch ([212.60.46.172]:48334 "EHLO
        smtp1.mail.fcom.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750839AbdIWPnV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 11:43:21 -0400
Received: from webmail.quickline.com (unknown [212.60.62.15])
        (Authenticated sender: ernst.lobsiger@belponline.ch)
        by smtp1.mail.fcom.ch (Postfix) with ESMTPA id 0061F200DD
        for <linux-media@vger.kernel.org>; Sat, 23 Sep 2017 17:34:41 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 23 Sep 2017 17:34:41 +0200
From: Ernst Lobsiger <ernst.lobsiger@belponline.ch>
To: linux-media@vger.kernel.org
Subject: Debian package dvb-tools 1.12.3-1 / "dvb-fe-tool" crashes
Message-ID: <8adb9177f5e087d6cddf5ba9fdcae3e9@belponline.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Debian package dvb-tools 1.12.3-1 / "dvb-fe-tool" crashes

Hi,

I have an EUMETCAST receiver using a TBS-6908 card which has
2 x (stv6120 tuner + stv0910 demod). The demodulators stv0910
are used in single mode. So I have adapters 0-3. I use a single
cable solution with entry DVB0 feeding adapter 0 + adapter 1.

The driver is the OS driver from TBS I had to fix with CrazyCat.
System monitoring has been done with femon. This gives me signal
strength in % and I can change this back in dBm. Unfortunately
the result is integer values of dBm which is too coarse for me.

I tried dvb-fe-tool but this fails once in every 5 to 10 times.
I get the output below. I have 8GB RAM with a 32Bit pae-kernel.

I use the same type of receiver PC with a TBS-6903 which has
1 x (stv6120 tuner + stv0910 demod) in exactly the same way
except for this is an amd64-kernel. There it works just fine.


Cheers,

Ernst Lobsiger



Linux kallisto 4.9.0-3-686-pae #1 SMP Debian 4.9.30-2+deb9u2 
(2017-06-26) i686

The programs included with the Debian GNU/Linux system are free 
software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Sat Sep 23 13:25:42 2017 from 192.168.1.38
root@kallisto:~# clear
root@kallisto:~# dvb-fe-tool -m -a0 -c1
Lock   (0x1f) Signal= -35.77dBm C/N= 11.90dB postBER= 0
           Layer A: Signal= 65.06% C/N= 59.56%
ERROR    FE_SET_VOLTAGE: Operation not permitted
root@kallisto:~# dvb-fe-tool -m -a0 -c1
Lock   (0x1f) Signal= -35.21dBm C/N= 12.00dB postBER= 0
           Layer A: Signal= 65.06% C/N= 60.06%
ERROR    FE_SET_VOLTAGE: Operation not permitted
root@kallisto:~# dvb-fe-tool -m -a0 -c1
Lock   (0x1f) Signal= -35.34dBm C/N= 11.90dB postBER= 0
           Layer A: Signal= 65.06% C/N= 59.56%
ERROR    FE_SET_VOLTAGE: Operation not permitted
root@kallisto:~# dvb-fe-tool -m -a0 -c1
Lock   (0x1f) Signal= -35.41dBm C/N= 11.80dB postBER= 0
           Layer A: Signal= 65.06% C/N= 59.06%
ERROR    FE_SET_VOLTAGE: Operation not permitted
*** Error in `dvb-fe-tool': double free or corruption (fasttop): 
0x81080790 ***
======= Backtrace: =========
/lib/i386-linux-gnu/libc.so.6(+0x6737a)[0xb755d37a]
/lib/i386-linux-gnu/libc.so.6(+0x6dfb7)[0xb7563fb7]
/lib/i386-linux-gnu/libc.so.6(+0x6e7f6)[0xb75647f6]
/usr/lib/i386-linux-gnu/libdvbv5.so.0(free_dvb_dev+0x24)[0xb76dc804]
/usr/lib/i386-linux-gnu/libdvbv5.so.0(dvb_dev_free_devices+0x3c)[0xb76dc8dc]
/usr/lib/i386-linux-gnu/libdvbv5.so.0(dvb_dev_free+0x58)[0xb76dcc28]
dvb-fe-tool(main+0x1de)[0x800f532e]
/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf6)[0xb750e276]
dvb-fe-tool(+0x147e)[0x800f547e]
======= Memory map: ========
800f4000-800f7000 r-xp 00000000 08:02 21762350   /usr/bin/dvb-fe-tool
800f7000-800f8000 r--p 00002000 08:02 21762350   /usr/bin/dvb-fe-tool
800f8000-800f9000 rw-p 00003000 08:02 21762350   /usr/bin/dvb-fe-tool
8106a000-810aa000 rw-p 00000000 00:00 0          [heap]
b7200000-b7221000 rw-p 00000000 00:00 0
b7221000-b7300000 ---p 00000000 00:00 0
b730e000-b7315000 r--s 00000000 08:02 21764231   
/usr/lib/i386-linux-gnu/gconv/g                                          
                                    conv-modules.cache
b7315000-b74b0000 r--p 00000000 08:02 21758709   
/usr/lib/locale/locale-archive
b74b0000-b74b2000 rw-p 00000000 00:00 0
b74b2000-b74cb000 r-xp 00000000 08:02 7867585    
/lib/i386-linux-gnu/libpthread-                                          
                                    2.24.so
b74cb000-b74cc000 r--p 00018000 08:02 7867585    
/lib/i386-linux-gnu/libpthread-                                          
                                    2.24.so
b74cc000-b74cd000 rw-p 00019000 08:02 7867585    
/lib/i386-linux-gnu/libpthread-                                          
                                    2.24.so
b74cd000-b74cf000 rw-p 00000000 00:00 0
b74cf000-b74eb000 r-xp 00000000 08:02 7864324    
/lib/i386-linux-gnu/libgcc_s.so                                          
                                    .1
b74eb000-b74ec000 r--p 0001b000 08:02 7864324    
/lib/i386-linux-gnu/libgcc_s.so                                          
                                    .1
b74ec000-b74ed000 rw-p 0001c000 08:02 7864324    
/lib/i386-linux-gnu/libgcc_s.so                                          
                                    .1
b74ed000-b74f4000 r-xp 00000000 08:02 7867587    
/lib/i386-linux-gnu/librt-2.24.                                          
                                    so
b74f4000-b74f5000 r--p 00006000 08:02 7867587    
/lib/i386-linux-gnu/librt-2.24.                                          
                                    so
b74f5000-b74f6000 rw-p 00007000 08:02 7867587    
/lib/i386-linux-gnu/librt-2.24.                                          
                                    so
b74f6000-b76a7000 r-xp 00000000 08:02 7867571    
/lib/i386-linux-gnu/libc-2.24.s                                          
                                    o
b76a7000-b76a8000 ---p 001b1000 08:02 7867571    
/lib/i386-linux-gnu/libc-2.24.s                                          
                                    o
b76a8000-b76aa000 r--p 001b1000 08:02 7867571    
/lib/i386-linux-gnu/libc-2.24.s                                          
                                    o
b76aa000-b76ab000 rw-p 001b3000 08:02 7867571    
/lib/i386-linux-gnu/libc-2.24.s                                          
                                    o
b76ab000-b76ae000 rw-p 00000000 00:00 0
b76ae000-b76ce000 r-xp 00000000 08:02 7864618    
/lib/i386-linux-gnu/libudev.so.                                          
                                    1.6.5
b76ce000-b76cf000 r--p 0001f000 08:02 7864618    
/lib/i386-linux-gnu/libudev.so.                                          
                                    1.6.5
b76cf000-b76d0000 rw-p 00020000 08:02 7864618    
/lib/i386-linux-gnu/libudev.so.                                          
                                    1.6.5
b76d0000-b7707000 r-xp 00000000 08:02 21761950   
/usr/lib/i386-linux-gnu/libdvbv                                          
                                    5.so.0.0.0
b7707000-b770d000 r--p 00036000 08:02 21761950   
/usr/lib/i386-linux-gnu/libdvbv                                          
                                    5.so.0.0.0
b770d000-b770f000 rw-p 0003c000 08:02 21761950   
/usr/lib/i386-linux-gnu/libdvbv                                          
                                    5.so.0.0.0
b770f000-b7762000 r-xp 00000000 08:02 7867575    
/lib/i386-linux-gnu/libm-2.24.s                                          
                                    o
b7762000-b7763000 r--p 00052000 08:02 7867575    
/lib/i386-linux-gnu/libm-2.24.s                                          
                                    o
b7763000-b7764000 rw-p 00053000 08:02 7867575    
/lib/i386-linux-gnu/libm-2.24.s                                          
                                    o
b7768000-b7769000 rw-p 00000000 00:00 0
b7769000-b776b000 r--p 00199000 08:02 21758709   
/usr/lib/locale/locale-archive
b776b000-b776e000 rw-p 00000000 00:00 0
b776e000-b7770000 r--p 00000000 00:00 0          [vvar]
b7770000-b7772000 r-xp 00000000 00:00 0          [vdso]
b7772000-b7795000 r-xp 00000000 08:02 7867567    
/lib/i386-linux-gnu/ld-2.24.so
b7795000-b7796000 r--p 00022000 08:02 7867567    
/lib/i386-linux-gnu/ld-2.24.so
b7796000-b7797000 rw-p 00023000 08:02 7867567    
/lib/i386-linux-gnu/ld-2.24.so
bfd80000-bfda1000 rw-p 00000000 00:00 0          [stack]
Aborted
root@kallisto:~#
