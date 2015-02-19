Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38935 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbBSHTU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 02:19:20 -0500
Received: by mail-wi0-f173.google.com with SMTP id bs8so46000020wib.0
        for <linux-media@vger.kernel.org>; Wed, 18 Feb 2015 23:19:18 -0800 (PST)
Date: Thu, 19 Feb 2015 08:24:36 +0100
From: Zahari Doychev <zahari.doychev@linux.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Fabio Estevam <festevam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: Using the coda driver with Gstreamer
Message-ID: <20150219072436.GE30358@riot.fritz.box>
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>
 <20141117185554.GW25554@pengutronix.de>
 <CAOMZO5DGR=Y1MVAc46OG6f26s9kEAoT+XCXgyezFOefM6H_NQg@mail.gmail.com>
 <CAOMZO5CtXEzBw2_McwTpn3S4FB_8wRE-HYTghv=ceBo_AAuMqA@mail.gmail.com>
 <546B92E3.30105@collabora.com>
 <CAOMZO5AkyqNt5g8+AVhoLdLiKv20_q9YRQidNv+2JuOO4BBzSg@mail.gmail.com>
 <20150218084245.GB30358@riot.fritz.box>
 <54E494F3.6030302@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54E494F3.6030302@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 18, 2015 at 08:34:43AM -0500, Nicolas Dufresne wrote:
> 
> Le 2015-02-18 03:42, Zahari Doychev a écrit :
> >>gst-launch-1.0 filesrc
> >>>location=/home/H264_test1_Talkinghead_mp4_480x360.mp4 ! qtdemux !
> >>>h264parse ! v4l2video1dec ! videoconvert ! fbdevsink
> >I am using this pipeline with gstreamer 1.4.5 and current media branch but I am
> >getting very poor performance 1-2 fps when playing 800x400 video. Is it possible
> >that fbdevsink is too slow for that? Does anyone know what is going wrong?
> In this context, you most likely have a conversion happening in videoconvert
> followed by a copy at fbdevsink. Framebuffer device is not a very good
> solution if performance matter (no possible zero-copy). Specially if the
> selected framebuffer color format does not match the decoded format.

So can you tell me if there are some drivers and plugins that can do this
in efficient way. Is there some work going on in this directions. I suppose
glimagesink maybe will be a good way to go.

Regards,

Zahari


