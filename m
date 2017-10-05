Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:51050 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbdJEOaM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 10:30:12 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 3E87A20993
        for <linux-media@vger.kernel.org>; Thu,  5 Oct 2017 16:30:10 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Date: Thu, 05 Oct 2017 16:30:07 +0200
From: Martin Kepplinger <martink@posteo.de>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: Re: platform: coda: how to use firmware-imx binary
 =?UTF-8?Q?releases=3F=20/=20how=20to=20use=20VDOA=20on=20imx=36=3F?=
In-Reply-To: <1507212647.27175.25.camel@ndufresne.ca>
References: <ef7cc5b91829f383842a1e4692af5b07@posteo.de>
 <1507108964.11691.6.camel@pengutronix.de>
 <7dd05afd338e81d293d0424e0b8e6b6a@posteo.de>
 <1507191578.8473.1.camel@pengutronix.de>
 <e0335e29f79b719c6f315473b3db74ad@posteo.de>
 <1507212647.27175.25.camel@ndufresne.ca>
Message-ID: <3eb6a9b35d891d04608c569b3286496e@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.10.2017 16:10 schrieb Nicolas Dufresne:
> Le jeudi 05 octobre 2017 à 13:54 +0200, Martin Kepplinger a écrit :
>> > This message is most likely just a result of the VDOA not supporting
>> > the
>> > selected capture format. In vdoa_context_configure, you can see that
>> > the
>> > VDOA only writes YUYV or NV12.
>> 
>> ok. I'll have to look into it, and just in case you see a problem on
>> first sight:
>> this is what coda says with debug level 1, when doing
>> 
>> gst-launch-1.0 playbin uri=file:///data/test2_hd480.h264
>> video-sink=fbdevsink
> 
> A bit unrelated, but kmssink remains a better choice here.
> 

True, but I'm currently not yet interested in the other end of the pipe 
:) Decoding
works in principal. VDOA is still disabled however :( I don't see what I 
can do
about this right now, which is a bit odd. It is definitely probed (and 
not removed).
I see at least a few frames of the video, so I guess the video file is 
fine? Or could
it be a file (or pixel) format that isn't supported? Again, ffprobe says

Stream #0:0: Video: h264 (High), yuv420p(progressive), 852x480, 24 fps, 
24 tbr, 1200k tbn, 48 tbc

                             thanks


After this, I want to have video conversion (color space) via a v4l2 
interface that
in turn uses the imx6 IPU. I guess gst-inspect-1.0 should see a V4L2 
Converter,
which it currently doesn't here:

# gst-inspect-1.0 | grep v4l2
video4linux2:  v4l2video1dec: V4L2 Video Decoder
video4linux2:  v4l2deviceprovider (GstDeviceProviderFactory)
video4linux2:  v4l2radio: Radio (video4linux2) Tuner
video4linux2:  v4l2sink: Video (video4linux2) Sink
video4linux2:  v4l2src: Video (video4linux2) Source

# dmesg | grep ipu
[    1.394717] imx-drm display-subsystem: bound imx-ipuv3-crtc.2 (ops 
0xc07d4b60)
[    1.402258] imx-drm display-subsystem: bound imx-ipuv3-crtc.3 (ops 
0xc07d4b60)
[    1.514984] imx-ipuv3 2400000.ipu: IPUv3H probed

should imx-ipuv3 provide a video4linux2 interface for video conversion? 
At least I don't
see it yet. (or other V4L2 Linux config options than I already have 
enabled)
