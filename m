Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:52919 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbaKRSIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 13:08:42 -0500
Received: by mail-lb0-f178.google.com with SMTP id f15so19620752lbj.23
        for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 10:08:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DGR=Y1MVAc46OG6f26s9kEAoT+XCXgyezFOefM6H_NQg@mail.gmail.com>
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>
	<20141117185554.GW25554@pengutronix.de>
	<CAOMZO5DGR=Y1MVAc46OG6f26s9kEAoT+XCXgyezFOefM6H_NQg@mail.gmail.com>
Date: Tue, 18 Nov 2014 16:08:41 -0200
Message-ID: <CAOMZO5CtXEzBw2_McwTpn3S4FB_8wRE-HYTghv=ceBo_AAuMqA@mail.gmail.com>
Subject: Re: Using the coda driver with Gstreamer
From: Fabio Estevam <festevam@gmail.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 17, 2014 at 5:58 PM, Fabio Estevam <festevam@gmail.com> wrote:

>> Just a wild guess - we usually test here with dmabuf capable devices and
>> without X. As you are using gstglimagesink, the code around
>> ext/gl/gstglimagesink.c (453) looks like gst_gl_context_create() went
>> wrong. Does your GL work correctly? Maybe you can test the glimagesink
>> with a simpler pipeline first.
>
> Yes, maybe it would be better to remove X from my initial tests. I
> will give it a try.

Now I have a rootfs without X:

root@imx6qsabresd:/home# gst-inspect-1.0 | grep v4l2
video4linux2:  v4l2src: Video (video4linux2) Source
video4linux2:  v4l2sink: Video (video4linux2) Sink
video4linux2:  v4l2radio: Radio (video4linux2) Tuner
video4linux2:  v4l2deviceprovider (GstDeviceProviderFactory)
video4linux2:  v4l2video1dec: V4L2 Video Decoder

Basic test works fine:
root@imx6qsabresd:/home# gst-launch-1.0 videotestsrc ! fbdevsink

root@imx6qsabresd:/home# gst-launch-1.0 playbin uri=file:///home/H264_test1_Talk
inghead_mp4_480x360.mp4
Setting pipeline to PAUSED ...
Pipeline is PREROLLING ...
Redistribute latency...
[  138.267329] coda 2040000.vpu: CODA PIC_RUN timeout

I was not able to switch to Gstreamer 1.4.4 yet, so this was on 1.4.1.

Thanks
