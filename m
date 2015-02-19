Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37504 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbbBSNbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 08:31:00 -0500
Message-ID: <54E5E58E.7070507@collabora.com>
Date: Thu, 19 Feb 2015 08:30:54 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Zahari Doychev <zahari.doychev@linux.com>
CC: Fabio Estevam <festevam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: Using the coda driver with Gstreamer
References: <CAOMZO5AX0R-s94-5m0G=SKkNb38u+jZo=7Toa+LDOkiJLAh=Tg@mail.gmail.com> <20141117185554.GW25554@pengutronix.de> <CAOMZO5DGR=Y1MVAc46OG6f26s9kEAoT+XCXgyezFOefM6H_NQg@mail.gmail.com> <CAOMZO5CtXEzBw2_McwTpn3S4FB_8wRE-HYTghv=ceBo_AAuMqA@mail.gmail.com> <546B92E3.30105@collabora.com> <CAOMZO5AkyqNt5g8+AVhoLdLiKv20_q9YRQidNv+2JuOO4BBzSg@mail.gmail.com> <20150218084245.GB30358@riot.fritz.box> <54E494F3.6030302@collabora.com> <20150219072436.GE30358@riot.fritz.box>
In-Reply-To: <20150219072436.GE30358@riot.fritz.box>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2015-02-19 02:24, Zahari Doychev a écrit :
> So can you tell me if there are some drivers and plugins that can do this
> in efficient way. Is there some work going on in this directions. I suppose
> glimagesink maybe will be a good way to go.

There is a lot of work happening, you should notice by searching this 
mailing list archive. The most promising seems to be the one targeting 
Wayland and DMABUF. On the GST side, there is experimental patches to 
handle DMABUF import and render queue, these are not yet fully merged 
into Wayland protocol and Weston. Weston can import DMABUF of various 
format and do the colorspace conversion using shaders. This can 
compensate the lack of hw color converter if your GPU is fast and 
precise enough.

Nicolas
