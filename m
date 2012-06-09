Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35749 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab2FIRGt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 13:06:49 -0400
Received: by wibhn6 with SMTP id hn6so1526838wib.1
        for <linux-media@vger.kernel.org>; Sat, 09 Jun 2012 10:06:48 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 9 Jun 2012 17:06:48 +0000
Message-ID: <CAFxvmmfFqCQg3QxirmPazdqNuBq6SxbezUR9T1bo+SRRL9-hBA@mail.gmail.com>
Subject: PWC ioctl inappropriate for device (Regression)
From: Bernard GODARD <bernard.godard@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

I am using a Philips Toucam Pro 2 webcam with the program qastrocam-g2
(astronomy program that use some specific functions of the PWC
driver).
I have been using this program with this camera for a long time on
different Linux distributions without a problem.

With Ubuntu 12.04, I now get a kernel oops. See bug report:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1010028

I have installed mainline kernel 3.4rc6 on my Ubuntu box to check if
the oops was fixed upstream. Now I am not getting the oops anymore but
the IOCTL used to get/set the camera parameters are failing:


astro@saturn:~$ qastrocam-g2
<init> : Avifile RELEASE-0.7.48-120122-05:53-../src/configure
<init> : Available CPU flags: fpu vme de pse tsc msr pae mce cx8 apic
sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall
nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good nopl extd_apicid
pni cx16 la
<init> : 2200.00 MHz AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ detected
Getting Standard: Inappropriate ioctl for device
setWhiteBalance: Inappropriate ioctl for device
getWhiteBalance: Inappropriate ioctl for device
getWhiteBalance: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
ioctl (VIDIOCGWIN): Inappropriate ioctl for device
mmap: Invalid argument
VIDIOCPWCGDYNNOISE: Inappropriate ioctl for device
VIDIOCPWCGCONTOUR: Inappropriate ioctl for device
VIDIOCPWCSCONTOUR: Inappropriate ioctl for device
VIDIOCPWCGDYNNOISE: Inappropriate ioctl for device
VIDIOCPWCGCONTOUR: Inappropriate ioctl for device
VIDIOCPWCGDYNNOISE: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCSAGC: Inappropriate ioctl for device
getWhiteBalance: Inappropriate ioctl for device
VIDIOCPWCSAGC: Inappropriate ioctl for device
VIDIOCPWCSSHUTTER: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
getWhiteBalance: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device
VIDIOCPWCGAGC: Inappropriate ioctl for device

...

Thank you,

Kind regards,

       Bernard
