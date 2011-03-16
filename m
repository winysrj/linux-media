Return-path: <mchehab@pedra>
Received: from knetgate.kensnet.org ([80.168.136.138]:57987 "EHLO
	knetgate.kensnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab1CPTDD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 15:03:03 -0400
Received: from [172.16.0.164] ([172.16.0.164])
	(authenticated bits=0)
	by knetgate.kensnet.org (8.13.8/8.13.8) with ESMTP id p2GIhpG4009630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 18:43:51 GMT
Message-ID: <4D8104E7.70607@kensnet.org>
Date: Wed, 16 Mar 2011 18:43:51 +0000
From: Ken Smith <kens@kensnet.org>
Reply-To: kens@kensnet.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Compro VideoMate S350
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


First post to this list, but not new to Linux.

I'm trying to get a Compro VideoMate S350 card to work in a 32bit Centos 
5.5 system that also has a Hauppauge WinTV-NOVA-T-500 that uses the 
dvb-usb-dib0700.ko kernel module as its driver. The Nova-T appears to be 
working.

I've used the v4l source RPM from ATRPMS to build an RPM of the v4l 
package. The RPM I compiled/built is called 
video4linux-kmdl-2.6.18-194.32.1.el5.centos.plus-20090907-93.RHL5.i386.rpm

The build runs fine without issue.

When I try to load the driver for the Compro with

modprobe -v saa7134 card=169

I get


insmod 
/lib/modules/2.6.18-194.32.1.el5.centos.plus/kernel/drivers/media/video/video-buf.ko 

WARNING: Error inserting video_buf 
(/lib/modules/2.6.18-194.32.1.el5.centos.plus/kernel/drivers/media/video/video-buf.ko): 
Invalid module format
WARNING: Error inserting videobuf_dma_sg 
(/lib/modules/2.6.18-194.32.1.el5.centos.plus/updates/drivers/media/video/videobuf-dma-sg.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting v4l1_compat 
(/lib/modules/2.6.18-194.32.1.el5.centos.plus/updates/drivers/media/video/v4l1-compat.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting videodev 
(/lib/modules/2.6.18-194.32.1.el5.centos.plus/updates/drivers/media/video/videodev.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting v4l2_common 
(/lib/modules/2.6.18-194.32.1.el5.centos.plus/updates/drivers/media/video/v4l2-common.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting ir_common 
(/lib/modules/2.6.18-194.32.1.el5.centos.plus/updates/drivers/media/common/ir-common.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting saa7134 
(/lib/modules/2.6.18-194.32.1.el5.centos.plus/updates/drivers/media/video/saa7134/saa7134.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)


The line referred to in /var/log/messages is

  kernel: video_buf: exports duplicate symbol videobuf_mmap_mapper 
(owned by videobuf_core)

I know that the centos.plus distribution includes some (if not all of) 
the v4l modules, so I tried my build of v4l with the plain Centos kernel 
build. The Nova T also runs fine, but I still get the error

insmod 
/lib/modules/2.6.18-194.32.1.el5/kernel/drivers/media/video/video-buf.ko
WARNING: Error inserting video_buf 
(/lib/modules/2.6.18-194.32.1.el5/kernel/drivers/media/video/video-buf.ko): 
Invalid module format

I'm sure I have missed something obvious, I'd appreciate any suggestions.

Thanks

Ken





-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

