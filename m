Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.wa.amnet.net.au ([203.161.124.51]:52656 "EHLO
	smtp2.wa.amnet.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbbJDFOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2015 01:14:23 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp2.wa.amnet.net.au (Postfix) with ESMTP id 28CB07D1BC
	for <linux-media@vger.kernel.org>; Sun,  4 Oct 2015 12:55:09 +0800 (WST)
Received: from smtp2.wa.amnet.net.au ([127.0.0.1])
	by localhost (smtp2.wa.amnet.net.au [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7kuHmin0xwCs for <linux-media@vger.kernel.org>;
	Sun,  4 Oct 2015 12:55:07 +0800 (WST)
Received: from richos.tresar-electronics.com.au (203.161.87.90.static.amnet.net.au [203.161.87.90])
	by smtp2.wa.amnet.net.au (Postfix) with ESMTP id E70F67D1B2
	for <linux-media@vger.kernel.org>; Sun,  4 Oct 2015 12:55:07 +0800 (WST)
To: linux-media@vger.kernel.org
From: Richard Tresidder <rtresidd@tresar-electronics.com.au>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
Message-ID: <5610B12B.8090201@tresar-electronics.com.au>
Date: Sun, 4 Oct 2015 12:55:07 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry If I've posted this to the wrong section my first attempt..

Hi
    I'm attempting to get an HVR2205 up and going.
CORE saa7164[1]: subsystem: 0070:f120, board: Hauppauge WinTV-HVR2205 
[card=13,autodetected]
Distribution is CentOS7 so I've pulled the v4l from media_build.git
Had to change a couple of things..  and another macro issue regarding 
clamp() ..
Seems the kzalloc(4 * 1048576, GFP_KERNEL) in saa7164-fw.c  was failing..
kept getting:  kernel: modprobe: page allocation failure: order:10, 
mode:0x10c0d0
Have plenty of RAM free so surprised about that one.. tried some of the 
tricks re increasing the vm.min_free_kbytes etc..

Any way I modified the routine to only allocate a single chunk buffer 
based on dstsize and tweaked the chunk handling code..
seemed to fix that one.. fw downloaded and seemed to boot ok..

Next I'm running into a problem with the saa7164_dvb_register() stage...

saa7164[1]: Hauppauge eeprom: model=151609
saa7164_dvb_register() Frontend/I2C initialization failed
saa7164_initdev() Failed to register dvb adapters on porta

I added some extra debug and identified that client_demod->dev.driver is 
null..

However I'm now stuck as to what to tackle next..

I can provide more info, just didn't want to spam the list for my first 
email..

Regards
    Richard Tresidder
