Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:50030 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZJQO75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Oct 2009 10:59:57 -0400
Received: from [77.23.149.137] (helo=[192.168.0.185])
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <f_p@lanrules.de>)
	id 1MzAd0-00077D-8M
	for linux-media@vger.kernel.org; Sat, 17 Oct 2009 16:51:30 +0200
Message-ID: <4AD9D9F0.9020708@lanrules.de>
Date: Sat, 17 Oct 2009 16:51:28 +0200
From: Johannes Jordan <f_p@lanrules.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Lenovo USB 2.0 webcam (gspca, vc032x, MI1310_SOC)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,


I have a Lenovo USB 2.0 webcam which currently does not work with kernel 
  2.6.31 and also some earlier releases. It is supported by vc032x in 
theory though.


The camera worked with the old gspca driver before kernel inclusion. 
After kernel inclusion, it worked even better, albeit some applications 
would need v4l1compat.so.

Since some time (kernel updates) it stopped working. It is still 
recognized; dmesg output below:

usb 1-3: new high speed USB device using ehci_hcd and address 7
usb 1-3: configuration #1 chosen from 1 choice
gspca: probing 17ef:4802
vc032x: check sensor header 20
vc032x: Sensor ID 143a (3)
vc032x: Find Sensor MI1310_SOC
gspca: probe ok
gspca: probing 17ef:4802


However, the video device seems to be unusable:
  * spcaview hangs before showing the first frame, output follows:

    > Spcaview version: 1.1.8 date: 25:12:2007 (C) mxhaard@magic.fr
    > Initializing SDL.
    > SDL initialized.
    > bpp 3 format 15
    > Using video device /dev/video0.
    > Initializing v4l.
    > **************** PROBING CAMERA *********************
    > Camera found: Lenovo USB Webcam
    > Hmm did not support Video_channel
    > *****************************************************
    >  grabbing method default MMAP asked
    > VIDIOCGMBUF size 1327104  frames 4  offets[0]=0 offsets[1]=331776
    > VIDIOCGPICT
    > brightnes=0 hue=0 color=0 contrast=0 whiteness=0
    > depth=8 palette=0
    > VIDIOCSPICT
    > brightness=0 hue=0 color=0 contrast=0 whiteness=0
    > depth=24 palette=15

    No output from the kernel in that case

  * Apps like cheese with v4l2convert or mplayer with v4l2 driver
    try hard, giving errors like
    > v4l2: select timeout ??% ??,?% 0 0
    at the same time this message is produced a lot in kernel output:
    > gspca: frame overflow 119808 > 118784
    with varying numbers.

  * As you could imagine, skype does not work as well


As I read that there are recent patches against vc032x regarding the 
MI1310_SOC capture device, I wanted to try the recent v4l-dvb tree. 
However it does not compile here, missing headers in the firewire module.


I would be very grateful if you could help me resolve this issue!
What do I need to compile/try a newer version of the driver?
Is the problem with my webcam already known?
How may I assist in any bug-fixing, do you need further information?


Best Regards,
Johannes
