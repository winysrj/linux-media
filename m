Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63772 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab3I1JVD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Sep 2013 05:21:03 -0400
MIME-Version: 1.0
Message-ID: <trinity-f253fd4b-3f17-4207-982d-a340372ac356-1380360060873@msvc034>
From: bleun@gmx.de
To: linux-media@vger.kernel.org
Subject: Analog TV with HVR-930H
Content-Type: text/plain; charset=UTF-8
Date: Sat, 28 Sep 2013 11:21:01 +0200 (CEST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to use a Hauppauge WIN-TV HVR-900 (H) TV USB 2.0 Analogue & Digital TV Tuner, Bus ID 2040:b138, with kernel 3.6.11. 

Analog TV only with working audio/alsa support would be fine for me. I stumpled across http://www.technomancy.org/linux/hauppauge-wintv-hvr-900/ which describes the device and claims that analog TV is working.

As a first start I just added the Bus ID of the device to cx231xx-cards.c (using the EXETER board profile). After this cx231xx loads and qv4l2 is able to select channels and displays a nice video stream, but without sound.

If possible, I would like to prepare a new board profile which disables DVB-T, as recommendet in http://www.mail-archive.com/linux-media@vger.kernel.org/msg30116.html and allows me to use the device with tvtime (incl. sound) or a similar tv-viewer app.

Is there any chance that this device will ever work or do you think it is a waste of time? Any hints or pointers how to modify the EXETER profile (exact values to try) and why sound isn't working?
