Return-path: <linux-media-owner@vger.kernel.org>
Received: from pv33p04im-asmtp002.me.com ([17.143.181.11]:56177 "EHLO
        pv33p04im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752123AbcICJYY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2016 05:24:24 -0400
Received: from process-dkim-sign-daemon.pv33p04im-asmtp002.me.com by
 pv33p04im-asmtp002.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 id <0OCX003008QLQY00@pv33p04im-asmtp002.me.com> for
 linux-media@vger.kernel.org; Sat, 03 Sep 2016 09:24:20 +0000 (GMT)
Received: from ovs-laptop.ov
 (78.183.181.54.dynamic.ttnet.com.tr [78.183.181.54])
 by pv33p04im-asmtp002.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 with ESMTPSA id <0OCX007OH8SF3I30@pv33p04im-asmtp002.me.com> for
 linux-media@vger.kernel.org; Sat, 03 Sep 2016 09:24:20 +0000 (GMT)
From: Oliver Collyer <ovcollyer@mac.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: quoted-printable
Subject: uvcvideo error on second capture from USB device,
 leading to V4L2_BUF_FLAG_ERROR
Message-id: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
Date: Sat, 03 Sep 2016 12:24:14 +0300
To: linux-media@vger.kernel.org
MIME-version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

I=E2=80=99ve been trying to workaround some issues in FFmpeg relating to =
the V4L2_BUF_FLAG_ERROR flag being passed from V4L2.

In particular this bug here:

https://trac.ffmpeg.org/ticket/4988

The long and short of it is that this error comes through several times =
at the start of a capture and FFmpeg struggles to handle it properly, =
despite previous attempts at fixing (such as this one =
https://trac.ffmpeg.org/ticket/4030)

I=E2=80=99ve also reproduced this outside of FFmpeg using the capture =
example that is part of the V4L2 API:

https://www.linuxtv.org/downloads/v4l-dvb-apis/capture-example.html

Further, I have the following two devices in my possession and both =
produce the error, so it doesn=E2=80=99t seem to be related to the =
specific hardware, unless they are somehow making the same mistake:

Magewell XI100DUSBHDMI
Inogeni DVI2USB3

Significantly, the error does not occur the first time after the USB =
device is connected (or the machine rebooted or the uvcvideo kernel =
module reloaded), however it appears 100% of the time thereafter.

I downloaded and built the latest media_build and re-loaded the newly =
built uvcvideo module but I still get the same behaviour.

The issue can be worked around by using modprobe to unload and reload =
uvcvideo before each capture.

Here is some dmesg output:

These lines appear when the uvcvideo modules is removed and then added =
again:

[43909.871585] usbcore: deregistering interface driver uvcvideo
[43910.117724] media: Linux media interface: v0.10
[43910.120736] Linux video capture interface: v2.00
[43910.120738] WARNING: You are using an experimental version of the =
media stack.
               	As the driver is backported to an older kernel, it =
doesn't offer
               	enough quality for its usage in production.
               	Use it with care.
               Latest git patches (needed if you report a bug to =
linux-media@vger.kernel.org):
               	23ea23617ba96f7969aa5c175ebaad9557612171 Merge branch =
'docs-next' of /git/mchehab/experimental into docs-next
               	fb6609280db902bd5d34445fba1c926e95e63914 [media] =
dvb_frontend: Use memdup_user() rather than duplicating its =
implementation
               	8eb14e8084b0f39dbf23dcd0c263fc2fac862048 [media] vb2: =
Fix vb2_core_dqbuf() kernel-doc
[43910.122896] uvcvideo: Found UVC 1.00 device XI100DUSB-HDMI =
(2935:0001)
[43910.123874] uvcvideo 2-4:1.0: Entity type for entity Processing 2 was =
not initialized!
[43910.123877] uvcvideo 2-4:1.0: Entity type for entity Camera 1 was not =
initialized!
[43910.123952] input: XI100DUSB-HDMI as =
/devices/pci0000:00/0000:00:14.0/usb2/2-4/2-4:1.0/input/input27
[43910.124016] usbcore: registered new interface driver uvcvideo
[43910.124018] USB Video Class driver (1.1.1)

I then run a capture using FFmpeg or the capture example in the V4L2 API =
and it works fine, so there is no more trace.

However if I run the same capture/test subsequently I always get these =
two lines:

[43950.910465] uvcvideo: Non-zero status (-71) in video completion =
handler.
[43950.910483] videobuf2-v4l2.c: setting V4L2_BUF_FLAG_ERROR

The second line is trace I added myself to show when it sets the buffer =
error flag. As you can see, first of all there is an error (-71) in the =
video completion handler, and then shortly afterwards the buffer error =
flag gets set.

It would appear that when the first capture ends something isn=E2=80=99t =
being cleaned-up properly, leading to the error state for subsequent =
captures and the knock-on effects to FFmpeg or anything using V4L2.

These are two of the most popular USB3 capture devices out there so it =
would be great to get to the bottom of this. I know apps are expected to =
workaround V4L2_BUF_FLAG_ERROR but in the case of FFmpeg it=E2=80=99s a =
little problematic because even if we just discard the buffer it still =
ends up throwing the timestamps of the input out of whack with the =
output leading to tons of FFmpeg warnings.

Since this happens 100% of the time from the second capture onwards for =
these devices, and is clearly resolved by a module reload it seems that =
the best approach would be to fix the underlying cause if possible.

If I can provide any more info please let me know. I am happy to =
test/make any suggested fixes or even provide ssh access to the machine =
if necessary.

Regards

Oliver

oliver@NUC-1:~$ uname -a
Linux NUC-1 4.4.0-36-generic #55-Ubuntu SMP Thu Aug 11 18:01:55 UTC 2016 =
x86_64 x86_64 x86_64 GNU/Linux

oliver@NUC-1:~/media_build/linux$ lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0-7
Thread(s) per core:    2
Core(s) per socket:    4
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 94
Model name:            Intel(R) Core(TM) i7-6770HQ CPU @ 2.60GHz
Stepping:              3
CPU MHz:               1501.500
CPU max MHz:           3500,0000
CPU min MHz:           800,0000
BogoMIPS:              5183.87
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              6144K
NUMA node0 CPU(s):     0-7
Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr =
pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe =
syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts =
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq =
dtes64 monitor ds_cpl vmx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid =
sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c =
rdrand lahf_lm abm 3dnowprefetch epb intel_pt tpr_shadow vnmi =
flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms =
invpcid rtm mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 =
dtherm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp

oliver@NUC-1:~/media_build/linux$ lsusb
Bus 002 Device 002: ID 2935:0001 =20
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 003: ID 8087:0a2b Intel Corp.=20
Bus 001 Device 005: ID 1c4f:0002 SiGma Micro Keyboard TRACER Gamma Ivory
Bus 001 Device 004: ID 05ac:921c Apple, Inc. A1082 [Cinema HD Display =
23"]
Bus 001 Device 006: ID 09da:000a A4Tech Co., Ltd. Optical Mouse Opto =
510D / OP-620D
Bus 001 Device 002: ID 05ac:911c Apple, Inc. Hub in A1082 [Cinema HD =
Display 23"]
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub=
