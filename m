Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60240 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaLRQo2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 11:44:28 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so2149663wgg.7
        for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 08:44:27 -0800 (PST)
Message-ID: <54930468.6010007@vodalys.com>
Date: Thu, 18 Dec 2014 17:44:24 +0100
From: =?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: coda: Unable to use encoder video_bitrate
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I am trying to use the coda encoder through Gstreamer on an iMX6-based 
board.

I use the (rebased and slightly modified) gstv4l2h264enc plugin from:
https://github.com/hizukiayaka/gst-plugins-good

This pipeline works fine:
gst-launch-1.0 -vvv v4l2src device=/dev/video4 ! 
"video/x-raw,width=1280,height=720" ! videoconvert ! v4l2video0h264enc ! 
h264parse ! mp4mux ! filesink location=test.mp4

When encoder has no bitrate param set (default=0), video encoding works 
well, but bitrate reaches ~2.5Mbps

When I try to set the bitrate with whatever value like 100,000 or 
1,000,000, the encoder produces video with bitrate around 480kbps and a 
very poor quality.

Here is the gstreamer pipeline I use with bitrate set:
gst-launch-1.0 -vvv v4l2src device=/dev/video4 ! 
"video/x-raw,width=1280,height=720" ! videoconvert ! v4l2video0h264enc 
extra-controls="controls,video_bitrate=1000000;" ! h264parse ! mp4mux ! 
filesink location=test.mp4

The video_bitrate control seems to be correctly passed to the driver by 
GStreamer since I can see the VIDIOC_S_CTRL call.

Any idea ?

Thanks
Fred
