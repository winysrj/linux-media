Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51944 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2EVUeH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 16:34:07 -0400
Received: by gglu4 with SMTP id u4so5833555ggl.19
        for <linux-media@vger.kernel.org>; Tue, 22 May 2012 13:34:07 -0700 (PDT)
Message-ID: <4FBBF83C.8040201@gmail.com>
Date: Tue, 22 May 2012 16:34:04 -0400
From: Bob Lightfoot <boblfoot@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, atrpms-users@atrpms.net
Subject: HVR1600 and Centos 6.2 x86_64 -- Strange Behavior
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dear LinuxTv and AtRpms Communities:
     In the most recent three kernels {2.6.32-220.7.1 ;
2.6.32-220.13.1 ; 2.6.32-220.17.1} released for CentOS 6.2 I have
experienced what can only be described as a strange behavior of the
V4L kernel modules with the Hauppage HVR 1600 Card.  If I reboot the
PC in question {HP Pavillion Elite M9040n} I will lose sound on the
Analog TV Tuner.  If I Power off the PC, leave it off for 30-60
seconds and start it back up then I have sound with the Analog TV
Tuner every time.  Not sure what is causing this, but thought the
condition was worth sharing.

The uname -a response is :
> Linux mythbox.ladodomain 2.6.32-220.17.1.el6.x86_64 #1 SMP Wed May
> 16 00:01:37 BST 2012 x86_64 x86_64 x86_64 GNU/Linux

I am presently using the following modules:
> Name        : lirc-kmdl-2.6.32-220.17.1.el6  Relocations: (not
> relocatable) Version     : 0.9.0
> Vendor: ATrpms.net Release     : 89.el6
> Build Date: Thu 17 May 2012 06:08:44 PM EDT Install Date: Mon 21
> May 2012 04:26:24 PM EDT      Build Host: flocki.atrpms.net Group
> : System Environment/Kernel     Source RPM:
> lirc-0.9.0-89.el6.src.rpm Size        : 261184
> License: GPL Signature   : DSA/SHA1, Thu 17 May 2012 06:08:45 PM
> EDT, Key ID 508ce5e666534c2b Packager    : ATrpms
> <http://ATrpms.net/> Summary     : The Linux Infrared Remote
> Control (LIRC) kernel drivers Description : LIRC is the Linux
> Infrared Remote Control package.
> 
> 
> This package contains the lirc kernel modules for the Linux kernel
> package: kernel-2.6.32-220.17.1.el6.x86_64.x86_64.rpm. Name
> : nvidia-graphics295.20-kmdl-2.6.32-220.17.1.el6  Relocations: (not
> relocatable) Version     : 295.20
> Vendor: ATrpms.net Release     : 142.el6
> Build Date: Thu 17 May 2012 08:33:01 PM EDT Install Date: Mon 21
> May 2012 04:26:12 PM EDT      Build Host: flocki.atrpms.net Group
> : System Environment/Kernel     Source RPM:
> nvidia-graphics295.20-295.20-142.el6.src.rpm Size        : 17003384
> License: NVIDIA, distributable Signature   : DSA/SHA1, Thu 17 May
> 2012 08:33:05 PM EDT, Key ID 508ce5e666534c2b Packager    : ATrpms
> <http://ATrpms.net/> URL         :
> http://www.nvidia.com/object/linux_display_ia32_295.20 Summary
> : Kernel module for NVIDIA graphics architecture support 
> Description : NVIDIA Architecture support for systems with updated
> or custom kernels.
> 
> 
> This package contains the nvidia-graphics295.20 kernel modules for
> the Linux kernel package: 
> kernel-2.6.32-220.17.1.el6.x86_64.x86_64.rpm. Name        :
> video4linux-kmdl-2.6.32-220.17.1.el6  Relocations: (not
> relocatable) Version     : 20111124_223432
> Vendor: ATrpms.net Release     : 99.el6
> Build Date: Fri 18 May 2012 05:29:53 AM EDT Install Date: Mon 21
> May 2012 04:29:55 PM EDT      Build Host: flocki.atrpms.net Group
> : System Environment/Kernel     Source RPM:
> video4linux-20111124_223432-99.el6.src.rpm Size        : 13962448
> License: GPLv2 Signature   : DSA/SHA1, Fri 18 May 2012 05:29:57 AM
> EDT, Key ID 508ce5e666534c2b Packager    : ATrpms
> <http://ATrpms.net/> URL         : http://linuxtv.org/v4lwiki/ 
> Summary     : kernel modules for V4L2 drivers Description :
> 
> This package contains the video4linux kernel modules for the Linux
> kernel package: kernel-2.6.32-220.17.1.el6.x86_64.x86_64.rpm.

Sincerely,
Bob Lightfoot
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPu/g8AAoJEKqgpLIhfz3X/l0IAIUNiPa1CvD1msWC/eYVoizn
lra3mT2mHFJBUWWnBWzCZ1F/cDvzkcVaB95adHMUqDLPNLBYVOIV36XYMKhWuUWv
ydaikkcNeUFQviZBZgqz5u/R54hlQP3vgVA5oChrYIItWUFtTFDeqPCsjkmKVBlk
sIeQzF7rOMCuvutk/nD4on2kZPZcmd4mTkSpGiVv7I+6Kk+qPXYY9C48NSX599TM
GQOd1pkbVMsV/A7nnRsMTCNROYBOS+K4KP0bA6ewKKl+wmwtoJfyCCkeh5g7unIr
7rSIWy0JRTCsA6joGMXPHsf4pFlJ78sXFU/KOTpUzJ1bF4VCXy0gxwjdkCVm4pE=
=p0ZF
-----END PGP SIGNATURE-----
