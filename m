Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:54704 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759171Ab1IJKvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Sep 2011 06:51:40 -0400
Received: from [192.168.178.41] (Rokh.fritz.box [192.168.178.41])
	by AMD-Geode-LX.localdomain (Postfix) with ESMTP id BE0A3C0064
	for <linux-media@vger.kernel.org>; Sat, 10 Sep 2011 12:51:38 +0200 (CEST)
Message-ID: <4E6B413B.8040802@gmx.de>
Date: Sat, 10 Sep 2011 12:51:39 +0200
From: Georg Gast <schorsch_76@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Some Questions from a noobie v4l driver developer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all!

Currently i try to write a driver for a "Technisat Skysat2 HD eXpress"
DVB-S2 card. My current module is able to register the pci device and
unload. And now begins the journey to v4l ;)

As there is no driver available for linux i decided to write it myself.

Subdevice IDs: 1ae4:0700

My device contains the folowing ics:
SAA7160 rev3 (PCIe Bridge)
STV0903B (decoder)
STV6110A (tuner)

For the two frontends STV0903B and the tuner STV6110A exists already
driver. I dived a little through the linux kernel code and found the
driver for the "Technisat DVB-S/S2 USB 2.0 device" (from Patrick
Boettcher) which contains the same chips except the pcie bridge.

I read in the documentation of the linux kernel (Debian Wheezy - kernel
3.0.0), that v4l(1) was droped in 2.6.37 and new drivers should use
v4l2. The documentation of video4linux2 in the linux kernel shows that
there is a important function where all "ops" are registered.
v4l2_subdev_init(). In my "reference" driver (technisat-usb2.c for the
technisat usb device) that function is not used. Patrick Boettcher
speeks of a DVB-USB framework on his
homepage(http://www.wi-bw.tfh-wildau.de/~pboettch/home/index.php).

So my questions are:
a) What framework should i use? V4L2?
b) Is it reasonable that i could refactor most of the code of Patrick
Boettchers Technisat USB Driver?
c) Is the documentation for video4linux2 uptodate in the kernel? Or
should i use an other documentation?
d) There is a driver namned saa716x from Manu Abrahams. Is this driver
in  state where i could modify it that it supports my device?

Best Regards
Georg Gast
