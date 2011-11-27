Return-path: <linux-media-owner@vger.kernel.org>
Received: from h1954367.stratoserver.net ([85.214.253.27]:36086 "EHLO
	h1954367.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab1K0NMg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 08:12:36 -0500
From: Hendrik Sattler <post@hendrik-sattler.de>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Problem with linux-3.1.3
Date: Sun, 27 Nov 2011 14:04:02 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111271404.02435.post@hendrik-sattler.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I just updated by self-built kernel-from v3.1 to v3.1.3.
With the new version, my built-in webcam[1] does not work anymore but it did 
with v3.1.
$ luvcview 
luvcview 0.2.6

SDL information:
  Video driver: x11
  A window manager is available
Device information:
  Device path:  /dev/video0
Stream settings:
  Frame format: MJPG
  Frame size:   640x480
  Frame rate:   30 fps
libv4l2: error turning on stream: No space left on device
Unable to start capture: No space left on device
Error grabbing
Cleanup done. Exiting ...

The following kernel message pop up with those tries:
uvcvideo: UVC non compliance - GET_MIN/MAX(PROBE) incorrectly supported. 
Enabling workaround.
uvcvideo: Failed to submit URB 0 (-28).


Same for using e.g. Google+ Hangouts which worked fine using v3.1.

Any ideas what might be wrong?

Thanks,

HS

[1]: Bus 001 Device 002: ID 5986:0102 Acer, Inc Crystal Eye Webcam
