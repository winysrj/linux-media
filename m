Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38974 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab2CTL1J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 07:27:09 -0400
Received: by eaaq12 with SMTP id q12so2947362eaa.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 04:27:08 -0700 (PDT)
Message-ID: <4F68698A.2070403@gmail.com>
Date: Tue, 20 Mar 2012 12:27:06 +0100
From: Marco Cavallini <koansoftware@gmail.com>
Reply-To: koansoftware@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Marco Cavallini <m.cavallini@koansoftware.com>
Subject: tvp5150: pxa27x-camera pxa27x-camera.0: Field type 9 unsupported.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I am trying to run a tvp5150 driver with a PXA270 based board
I am using kernel version: Linux 2.6.35 armv5tel GNU/Linux

I also did a test with kernel-3.2.5 without success.
I started playing with V4L2, and I've never used it, but I built v4l2-utils.
The problem is something in pxa_camera_try_fmt() related to the settings
causing the error "pxa27x-camera pxa27x-camera.0: Field type 9 unsupported."


[   30.005365] Linux video capture interface: v2.00
[   32.942234] *** PROBE tvp5151 ***
[   32.945573] tvp5150 0-003a: chip found @ 0x74 (pxa_i2c-i2c.0)
[   33.281105] pxa27x-camera pxa27x-camera.0: Limiting master clock to
26000000
[   33.288557] camera 0-0: Probing 0-0
[   33.292170] pxa27x-camera pxa27x-camera.0: PXA Camera driver attached
to camera 0
[   33.666535] *** PROBE tvp5151 ***
[   33.669865] tvp5150 0-005d: chip found @ 0xba (pxa_i2c-i2c.0)
[   33.811605] tvp5150 0-005d: tvp5150am1 detected.
[   33.999541] *** tvp5150_g_fmt
[   34.002776] pxa27x-camera pxa27x-camera.0: PXA Camera driver detached
from camera 0
[   34.447069] pxa27x-camera pxa27x-camera.0: PXA Camera driver attached
to camera 0
[   34.454755] *** tvp5150_try_fmt 2
[   34.458053] pxa27x-camera pxa27x-camera.0: Field type 9 unsupported.
[   34.464393] pxa27x-camera pxa27x-camera.0: PXA Camera driver detached
from camera 0


I am completely stuck at this, so I have some questions:
- is kernel version 2.6.35 good for using tvp5150 driver?
- do I need to have V2L to get out an image from tvp5150?
- which settings are missing in this driver?
- does anybody have seen a tvp5150 working with a PXA270 earlier?


# ./v4l2-ctl --all
[ 2195.222443] pxa27x-camera pxa27x-camera.0: PXA Camera driver attached
to camera 0
[ 2195.230247] *** tvp5150_try_fmt 2
[ 2195.234032] pxa27x-camera pxa27x-camera.0: Field type 9 unsupported.
[ 2195.240473] pxa27x-camera pxa27x-camera.0: PXA Camera driver detached
from camera 0
Failed to open /dev/video0: Invalid argument


Any hint would be greatly appreciated, if you need more details please ask.

TIA
--
Marco
