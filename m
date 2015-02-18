Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35120 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbBRNe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 08:34:57 -0500
Message-ID: <54E494F3.6030302@collabora.com>
Date: Wed, 18 Feb 2015 08:34:43 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Zahari Doychev <zahari.doychev@linux.com>,
	Fabio Estevam <festevam@gmail.com>
CC: Robert Schwebel <r.schwebel@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: Using the coda driver with Gstreamer
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com> <20141117185554.GW25554@pengutronix.de> <CAOMZO5DGR=Y1MVAc46OG6f26s9kEAoT+XCXgyezFOefM6H_NQg@mail.gmail.com> <CAOMZO5CtXEzBw2_McwTpn3S4FB_8wRE-HYTghv=ceBo_AAuMqA@mail.gmail.com> <546B92E3.30105@collabora.com> <CAOMZO5AkyqNt5g8+AVhoLdLiKv20_q9YRQidNv+2JuOO4BBzSg@mail.gmail.com> <20150218084245.GB30358@riot.fritz.box>
In-Reply-To: <20150218084245.GB30358@riot.fritz.box>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2015-02-18 03:42, Zahari Doychev a écrit :
>> gst-launch-1.0 filesrc
>> >location=/home/H264_test1_Talkinghead_mp4_480x360.mp4 ! qtdemux !
>> >h264parse ! v4l2video1dec ! videoconvert ! fbdevsink
> I am using this pipeline with gstreamer 1.4.5 and current media branch but I am
> getting very poor performance 1-2 fps when playing 800x400 video. Is it possible
> that fbdevsink is too slow for that? Does anyone know what is going wrong?
In this context, you most likely have a conversion happening in 
videoconvert followed by a copy at fbdevsink. Framebuffer device is not 
a very good solution if performance matter (no possible zero-copy). 
Specially if the selected framebuffer color format does not match the 
decoded format.

Nicolas
