Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:48355 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab0ADDLb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jan 2010 22:11:31 -0500
Subject: cx18: Need information on SECAM-D/K problem with PVR-2100
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org,
	Sergey Bolshakov <sbolshakov@altlinux.ru>
Cc: ivtv-devel@ivtvdriver.org, hverkuil@xs4all.nl
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Jan 2010 22:10:35 -0500
Message-Id: <1262574635.5963.40.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sergey,

On IRC you mentioned a problem of improper detection of SECAM-D/K with
the Leadtek PVR2100 (XC2028 and CX23418) from an RF source.

To investigate this problem on my own, I added SECAM support to the
saa7127 driver so a PVR-350 could generate a baseband SECAM signal for
me.  The good news for me is that a PVR-350 (SAA7115 video decoder) and
HVR-1600 (CX23418 integrated video decoder) card both properly
recognized the output of the PVR-350 as SECAM.  The bad news is I could
not reproduce your problem with this setup. 

Could you please do the following and send me the output from the logs?

1. Unload the cx18 module, tuner-xc2028 module, and the other tuner
modules.

2. In /etc/modprobe.conf set the following

	options tuner-xc2028 debug=1
	options tuner debug=1

3. Then

# modprobe cx18 debug=0x33         <---- info, warn, ioctl, file
# v4l2-ctl -d /dev/video0 -i 0     <---- Tuner input
# v4l2-ctl -d /dev/video0 -s 18    <---- SECAM-D/K
# v4l2-ctl -d /dev/video0 -f <freq of good channel>
# v4l2-ctl -d /dev/video0 --log-status

And send the relevant output from dmesg and /var/log/messages,
preferably to the mailing list.  I do not need the lines that begin
"cx18-0 encoder MPEG: VIDIOC_QUERYCTRL " if that makes the output
smaller.

Thanks,
Andy

