Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:59899 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaLATRl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 14:17:41 -0500
Received: by mail-la0-f51.google.com with SMTP id ms9so9334923lab.38
        for <linux-media@vger.kernel.org>; Mon, 01 Dec 2014 11:17:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <546B92E3.30105@collabora.com>
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com>
	<20141117185554.GW25554@pengutronix.de>
	<CAOMZO5DGR=Y1MVAc46OG6f26s9kEAoT+XCXgyezFOefM6H_NQg@mail.gmail.com>
	<CAOMZO5CtXEzBw2_McwTpn3S4FB_8wRE-HYTghv=ceBo_AAuMqA@mail.gmail.com>
	<546B92E3.30105@collabora.com>
Date: Mon, 1 Dec 2014 17:17:40 -0200
Message-ID: <CAOMZO5AkyqNt5g8+AVhoLdLiKv20_q9YRQidNv+2JuOO4BBzSg@mail.gmail.com>
Subject: Re: Using the coda driver with Gstreamer
From: Fabio Estevam <festevam@gmail.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 18, 2014 at 4:41 PM, Nicolas Dufresne
<nicolas.dufresne@collabora.com> wrote:

> Ok, let us know when the switch is made. Assuming your goal is to get
> the HW decoder working, you should test with simpler pipeline. In your
> specific case, you should try and get this pipeline to preroll:
>
> gst-launch-1.0 \
>   filesrc location=/home/H264_test1_Talk inghead_mp4_480x360.mp4 \
>   ! qtdemux ! h264parse ! v4l2video1dec ! fakesink

After applying Philipp's dts patch:
http://www.spinics.net/lists/arm-kernel/msg382314.html

,I am able to play the video clip with the following Gstreamer pipeline:

gst-launch-1.0 filesrc
location=/home/H264_test1_Talkinghead_mp4_480x360.mp4 ! qtdemux !
h264parse ! v4l2video1dec ! videoconvert ! fbdevsink

(Still on Gstreamer 1.4.1 version though, as I was not able to upgrade it yet).

Regards,

Fabio Estevam
