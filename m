Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.crc.dk ([130.226.184.8]:52950 "EHLO mail.crc.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab0BILuU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 06:50:20 -0500
Message-ID: <4B7149E0.80607@lemo.dk>
Date: Tue, 09 Feb 2010 12:41:20 +0100
From: Mogens Kjaer <mk@lemo.dk>
MIME-Version: 1.0
To: Linux-V4L2 <linux-media@vger.kernel.org>
Subject: Compiling saa7134 on a CentOS 5 machine
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm trying to compile v4l-dvb for my saa7134 card on my
CentOS 5 machine, and I'm having some problems.

The machine runs the 2.6.18-164.11.1.el5.centos.plus kernel.

It used to work some month ago, now I can't get it to compile.

During make, I get:

   Building modules, stage 2.
   MODPOST
WARNING: "ir_unregister_class" [/home/mk/tv/v4l-dvb/v4l/ir-core.ko] 
undefined!

and when I "make install", reboots (as the wiki suggests), and

modprobe saa7134

I get:

WARNING: Error inserting videobuf_core 
(/lib/modules/2.6.18-164.11.1.el5.centos.plus/kernel/drivers/media/video/videobuf-core.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting videobuf_dma_sg 
(/lib/modules/2.6.18-164.11.1.el5.centos.plus/kernel/drivers/media/video/videobuf-dma-sg.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting v4l1_compat 
(/lib/modules/2.6.18-164.11.1.el5.centos.plus/kernel/drivers/media/video/v4l1-compat.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting videodev 
(/lib/modules/2.6.18-164.11.1.el5.centos.plus/kernel/drivers/media/video/videodev.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting v4l2_common 
(/lib/modules/2.6.18-164.11.1.el5.centos.plus/kernel/drivers/media/video/v4l2-common.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting ir_common 
(/lib/modules/2.6.18-164.11.1.el5.centos.plus/kernel/drivers/media/IR/ir-common.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting saa7134 
(/lib/modules/2.6.18-164.11.1.el5.centos.plus/kernel/drivers/media/video/saa7134/saa7134.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)

dmesg says:

ir_core: Unknown symbol ir_unregister_class

The card is a:

# lspci
05:09.0 Multimedia controller: Philips Semiconductors 
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)

and I have a

options saa7134 card=96

in modprobe.conf.

v4l-dvb is today's:

hg clone http://linuxtv.org/hg/v4l-dvb

It used to work a couple of month ago...

Googling ir_unregister_class doesn't tell me anything.

What have I done wrong?

Mogens
-- 
Mogens Kjaer, mk@lemo.dk
http://www.lemo.dk
