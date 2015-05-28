Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59705 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbbE1KoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 06:44:10 -0400
Message-ID: <1432809845.3228.25.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/5] gpu: ipu-v3: Add mem2mem image conversion
 support to IC
From: Philipp Zabel <p.zabel@pengutronix.de>
To: "Enrico Weigelt, metux IT consult" <weigelt@melag.de>
Cc: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	David Airlie <airlied@linux.ie>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	Ian Molton <imolton@ad-holdings.co.uk>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Lucas Stach <l.stach@pengutronix.de>
Date: Thu, 28 May 2015 12:44:05 +0200
In-Reply-To: <5566D92F.8090802@melag.de>
References: <1426674173-17088-1-git-send-email-p.zabel@pengutronix.de>
	 <1426674173-17088-3-git-send-email-p.zabel@pengutronix.de>
	 <CAH-u=82OC=r+kgyHpvQFLMwrBiuaV_V3Q7W5FKV3eK4o_n0-HA@mail.gmail.com>
	 <5566D92F.8090802@melag.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

Am Donnerstag, den 28.05.2015, 11:00 +0200 schrieb Enrico Weigelt, metux
IT consult:
> Am 27.05.2015 um 20:42 schrieb Jean-Michel Hautbois:
> 
> <snip>
> 
> @Phillip,
> 
> I've missed the previous mails (just subscribed here yesterday) ...
>
> Are these patches same as in your git branch tmp/imx-ipu-scaler ?

No, that is an older version.

> I've got them running on 4.0.4 and currently trying on 4.1-rc*
> 
> Yet another question:
> 
> when using it w/ gst for video playback, can be directly pass buffers
> between VPU, IPU and FB (or let them directly write into shared
> buffers), so CPU doesn't need to act on each frame for each step
> in the decoding pipeline ?

Check out the (capture/output-)io-mode parameters, that's what the
dmabuf/dmabuf-import option pairs are for.

regards
Philipp

