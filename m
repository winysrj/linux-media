Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.unixsol.org ([193.110.159.2]:53071 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab2IPPcz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 11:32:55 -0400
Message-ID: <5055F124.8020507@unixsol.org>
Date: Sun, 16 Sep 2012 18:32:52 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: How to set pixelaspect in struct v4l2_cropcap returned by VIDIOC_CROPCAP?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guys I'm adding v4l2 output device support for VLC/ffmpeg/libav (I'm using
v4l2loopback [1] driver for testing) but I have a problem which I can't seem
to find a solution.

VLC [2] uses VIDIOC_CROPCAP [3] to detect the pixelaspect ratio of the input
it receives from v4l2 device. But I can't seem to find a way to set struct
v4l2_cropcap.pixelaspect when I'm outputting data to the device and the
result is that VLC assumes pixelaspect is 1:1.

I was hoping that VIDIOC_S_CROP [4] would allow setting pixelaspect but
according to docs that is not case. What am I missing?

How to set pixelaspect values returned by VIDIOC_CROPCAP?

[1]: https://github.com/umlaeute/v4l2loopback
[2]: http://git.videolan.org/?p=vlc.git;a=blob;f=modules/access/v4l2/demux.c;hb=HEAD#l248
[3]: http://www.linuxtv.org/downloads/v4l-dvb-apis/vidioc-cropcap.html
[4]: http://www.kernel.org/doc/htmldocs/media/vidioc-g-crop.html

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
