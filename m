Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:50054 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab2DKK1V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 06:27:21 -0400
To: <linux-media@vger.kernel.org>
Subject: UVC frame interval inconsistency
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 11 Apr 2012 12:27:08 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Message-ID: <c29fa93d58ec0a2289435bc92ac63e46@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   Hello guys,



I have been reworking the V4L2 input in VLC and I hit what looks like a

weird bug in the UVC driver. I am using a Logitech HD Pro C920 webcam.



By default, VLC tries to find the highest possible frame rate (actually

smallest frame interval in V4L2), then the largest possible resolution at

that frame rate.



When enumerating the frame sizes and intervals on the device, the winner

is 800x600 at 30 f/s. But when setting 30 f/s with VIDIOC_S_PARM, the

system call returns 24 f/s. Does anyone know why it is so? Is this a

firmware bug or what?



-- 

Rémi Denis-Courmont

Sent from my collocated server
