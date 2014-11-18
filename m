Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58680 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbaKRSlp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 13:41:45 -0500
Message-ID: <546B92E3.30105@collabora.com>
Date: Tue, 18 Nov 2014 13:41:39 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: Using the coda driver with Gstreamer
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>	<20141117185554.GW25554@pengutronix.de>	<CAOMZO5DGR=Y1MVAc46OG6f26s9kEAoT+XCXgyezFOefM6H_NQg@mail.gmail.com> <CAOMZO5CtXEzBw2_McwTpn3S4FB_8wRE-HYTghv=ceBo_AAuMqA@mail.gmail.com>
In-Reply-To: <CAOMZO5CtXEzBw2_McwTpn3S4FB_8wRE-HYTghv=ceBo_AAuMqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Le 2014-11-18 13:08, Fabio Estevam a écrit :
> On Mon, Nov 17, 2014 at 5:58 PM, Fabio Estevam <festevam@gmail.com> wrote:
> 
>>> Just a wild guess - we usually test here with dmabuf capable devices and
>>> without X. As you are using gstglimagesink, the code around
>>> ext/gl/gstglimagesink.c (453) looks like gst_gl_context_create() went
>>> wrong. Does your GL work correctly? Maybe you can test the glimagesink
>>> with a simpler pipeline first.
>>
>> Yes, maybe it would be better to remove X from my initial tests. I
>> will give it a try.
> 
> Now I have a rootfs without X:

Ok, nice, though what is your plan to display the result now ? This is
important information to get any help.

> 
> root@imx6qsabresd:/home# gst-inspect-1.0 | grep v4l2
> video4linux2:  v4l2src: Video (video4linux2) Source
> video4linux2:  v4l2sink: Video (video4linux2) Sink
> video4linux2:  v4l2radio: Radio (video4linux2) Tuner
> video4linux2:  v4l2deviceprovider (GstDeviceProviderFactory)
> video4linux2:  v4l2video1dec: V4L2 Video Decoder
> 
> Basic test works fine:
> root@imx6qsabresd:/home# gst-launch-1.0 videotestsrc ! fbdevsink
> 
> root@imx6qsabresd:/home# gst-launch-1.0 playbin uri=file:///home/H264_test1_Talk
> inghead_mp4_480x360.mp4
> Setting pipeline to PAUSED ...
> Pipeline is PREROLLING ...
> Redistribute latency...
> [  138.267329] coda 2040000.vpu: CODA PIC_RUN timeout
> 
> I was not able to switch to Gstreamer 1.4.4 yet, so this was on 1.4.1.
> 

Ok, let us know when the switch is made. Assuming your goal is to get
the HW decoder working, you should test with simpler pipeline. In your
specific case, you should try and get this pipeline to preroll:

gst-launch-1.0 \
  filesrc location=/home/H264_test1_Talk inghead_mp4_480x360.mp4 \
  ! qtdemux ! h264parse ! v4l2video1dec ! fakesink

If that pipeline does not reach PLAYING state, it means the decoder
never produced any output. You should also learn to use the tracing
system in GStreamer and make sure you have the source code next to you.
I would also suggest to try your best to sort as much as you can, make
sure you understand what you are trying to achieve and then come back
with questions.

http://gstreamer.freedesktop.org/data/doc/gstreamer/head/gstreamer/html/gst-running.html
