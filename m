Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:33462 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbBRIhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 03:37:31 -0500
Received: by wevk48 with SMTP id k48so3193003wev.0
        for <linux-media@vger.kernel.org>; Wed, 18 Feb 2015 00:37:30 -0800 (PST)
Date: Wed, 18 Feb 2015 09:42:45 +0100
From: Zahari Doychev <zahari.doychev@linux.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: Using the coda driver with Gstreamer
Message-ID: <20150218084245.GB30358@riot.fritz.box>
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>
 <20141117185554.GW25554@pengutronix.de>
 <CAOMZO5DGR=Y1MVAc46OG6f26s9kEAoT+XCXgyezFOefM6H_NQg@mail.gmail.com>
 <CAOMZO5CtXEzBw2_McwTpn3S4FB_8wRE-HYTghv=ceBo_AAuMqA@mail.gmail.com>
 <546B92E3.30105@collabora.com>
 <CAOMZO5AkyqNt5g8+AVhoLdLiKv20_q9YRQidNv+2JuOO4BBzSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5AkyqNt5g8+AVhoLdLiKv20_q9YRQidNv+2JuOO4BBzSg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Fabio,

On Mon, Dec 01, 2014 at 05:17:40PM -0200, Fabio Estevam wrote:
> On Tue, Nov 18, 2014 at 4:41 PM, Nicolas Dufresne
> <nicolas.dufresne@collabora.com> wrote:
> 
> > Ok, let us know when the switch is made. Assuming your goal is to get
> > the HW decoder working, you should test with simpler pipeline. In your
> > specific case, you should try and get this pipeline to preroll:
> >
> > gst-launch-1.0 \
> >   filesrc location=/home/H264_test1_Talk inghead_mp4_480x360.mp4 \
> >   ! qtdemux ! h264parse ! v4l2video1dec ! fakesink
> 
> After applying Philipp's dts patch:
> http://www.spinics.net/lists/arm-kernel/msg382314.html
> 
> ,I am able to play the video clip with the following Gstreamer pipeline:
> 
> gst-launch-1.0 filesrc
> location=/home/H264_test1_Talkinghead_mp4_480x360.mp4 ! qtdemux !
> h264parse ! v4l2video1dec ! videoconvert ! fbdevsink

I am using this pipeline with gstreamer 1.4.5 and current media branch but I am
getting very poor performance 1-2 fps when playing 800x400 video. Is it possible
that fbdevsink is too slow for that? Does anyone know what is going wrong?

Regards,

Zahari

Video Type:

root@imx6q-dmo-edm-qmx6:/# gst-discoverer-1.0 linux_800x480.mov -v
Analyzing file:///DemoVideos/linux_800x480.mov
Done discovering file:///DemoVideos/linux_800x480.mov
Missing plugins
 (gstreamer|1.0|gst-discoverer-1.0|MPEG-4 AAC decoder|decoder-audio/mpeg, mpegversion=(int)4, framed=(boolean)true, stream-format=(string)raw, level=(string)2, base-profile=(string)lc, profile=(string)lc)

Topology:
  container: video/quicktime
    audio: audio/mpeg, mpegversion=(int)4, framed=(boolean)true, stream-format=(string)raw, level=(string)2, base-profile=(string)lc, profile=(string)lc, codec_data=(buffer)120856e500, rate=(int)44100, channels=(int)1
      Codec:
        audio/mpeg, mpegversion=(int)4, framed=(boolean)true, stream-format=(string)raw, level=(string)2, base-profile=(string)lc, profile=(string)lc, codec_data=(buffer)120856e500, rate=(int)44100, channels=(int)1
      Additional info:
        None
      Stream ID: (null)
      Language: <unknown>
      Channels: 1
      Sample rate: 44100
      Depth: 0
      Bitrate: 0
      Max bitrate: 0
      Tags:
        None
      
    video: video/x-h264, stream-format=(string)avc, alignment=(string)au, level=(string)3.1, profile=(string)high, codec_data=(buffer)0164001fffe100176764001facd940c83da100000303e90000ea600f18319601000668ebe3cb22c0, width=(int)800, height=(int)480, framerate=(fraction)30000/1001, pixel-aspect-ratio=(fraction)1/1
      Codec:
        video/x-h264, stream-format=(string)avc, alignment=(string)au, level=(string)3.1, profile=(string)high, codec_data=(buffer)0164001fffe100176764001facd940c83da100000303e90000ea600f18319601000668ebe3cb22c0, width=(int)800, height=(int)480, framerate=(fraction)30000/1001, pixel-aspect-ratio=(fraction)1/1
      Additional info:
        None
      Stream ID: 0b5ab36c52878431d95e588951bfa2cf80c530ad5deda45bf3f9fdd5a4d4a48f/001
      Width: 800
      Height: 480
      Depth: 24
      Frame rate: 30000/1001
      Pixel aspect ratio: 1/1
      Interlaced: false
      Bitrate: 496256
      Max bitrate: 10069
      Tags:
        taglist, application-name=(string)Lavf55.7.100, container-format=(string)Quicktime, video-codec=(string)H.264, language-code=(string)en, bitrate=(uint)496256, minimum-bitrate=(uint)10069, maximum-bitrate=(uint)10069;
      

Properties:
  Duration: 0:03:12.006000000
  Seekable: yes
  Tags: 
      application name: Lavf55.7.100
      container format: Quicktime
      video codec: H.264
      language code: en
      bitrate: 496256
      minimum bitrate: 10069
      maximum bitrate: 10069
