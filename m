Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39650 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1B0Mlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 07:41:40 -0500
Received: by bwz15 with SMTP id 15so3039299bwz.19
        for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 04:41:39 -0800 (PST)
Subject: Re: Genuis Emessenger 310 webcam slow work with pac7302 in
 2.6.37.1 kernel
From: housegregory299 <housegregory299@gmail.com>
To: linux-media@vger.kernel.org
In-Reply-To: <1298762810.2022.54.camel@debian>
References: <1298718695.2178.30.camel@debian> <4D693EB3.6080302@freemail.hu>
	 <1298762810.2022.54.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Feb 2011 18:41:21 +0600
Message-ID: <1298810481.4788.0.camel@debian>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В Вск, 27/02/2011 в 05:26 +0600, housegregory299 пишет:
> Hello! Thanks for answer to me.
> Outputs from these commands: 
> 
> root@debian:/home/t800# cat /proc/version
> Linux version 2.6.37-1-amd64 (Debian 2.6.37-1) (ben@decadent.org.uk)
> (gcc version 4.4.5 (Debian 4.4.5-10) ) #1 SMP Tue Feb 15 17:43:38 UTC
> 2011
> 
> dpkg -l libv4l-0 :
> ii  libv4l-0       0.8.0-1        Collection of video4linux support
> libraries
> 
> root@debian:/home/t800# dpkg -l |grep linux-image
> ii  linux-image-2.6-amd64                 2.6.32+29
> Linux 2.6 for 64-bit PCs (meta-package)
> ii  linux-image-2.6.32-5-amd64            2.6.32-30
> Linux 2.6.32 for 64-bit PCs
> ii  linux-image-2.6.37-1-amd64            2.6.37-1
> Linux 2.6.37 for 64-bit PCs
> 
> dmesg output: No Errors 
> [    5.497771] gspca: v2.10.0 registered
> [    5.575635] gspca: probing 093a:2624
> [    5.579935] input: pac7302
> as /devices/pci0000:00/0000:00:1d.3/usb5/5-2/input/input6
> [    5.580056] gspca: video0 created
> [    5.580084] usbcore: registered new interface driver pac7302
> [    5.658209] usbcore: registered new interface driver snd-usb-audio
> 
> Frame rate not depend on the content of image, but in 2.6.32 kernel is
> depend on Exposure, i set up the webcam through the program  guvcview,
> (in 2.6.32) and lowered Exposure value to 0% and freezes disappeared,
> and will be OK. But the colors were a bit distorted and blurred.
> In the 2.6.37.1 (Installed from Sid Repository) colors are better on
> image, but I can not lower the value Exposure to reduce freezes, but
> increase this value is impossible without freezes or slow frame rate. 
> 
> Therefore, I usually lower them parameter to configure. Earlier this
> helps. But not with the new kernel. I also tried ubuntu 10.10 with
> 2.6.35.xx stock kernel and freezes there be similar.
> Webcam's image normally visible in Cheese, skype and Kopete.
> Thank you for tips, 
> I'll definitely try them.  It is a pity that it happened, in the new
> kernel has many improvements to my PC
> 
> My PC's quick specs:
> Gigabyte G31M-ES2L Motherboard
> CPU: Intel Dualcore 2.93 GHz 
> 4 GB Ram 
> Realtek HD alc883 audio integrated
> GPU: ATI Radeon HD 4650 (1024 mb) GDDR2 PC-e x16 by Gigabyte
> 
> In Debian/Ubuntu distros all devices work fine - without any problem
> except webcam. 
> 
> Translating partially done by Google Translator and 
> 
> I'll understand a little English =) 
> 
>  


