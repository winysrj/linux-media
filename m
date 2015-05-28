Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60586 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbbE1L7v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 07:59:51 -0400
Message-ID: <1432814386.3228.51.camel@pengutronix.de>
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
Date: Thu, 28 May 2015 13:59:46 +0200
In-Reply-To: <5566FC95.3020000@melag.de>
References: <1426674173-17088-1-git-send-email-p.zabel@pengutronix.de>
		 <1426674173-17088-3-git-send-email-p.zabel@pengutronix.de>
		 <CAH-u=82OC=r+kgyHpvQFLMwrBiuaV_V3Q7W5FKV3eK4o_n0-HA@mail.gmail.com>
		 <5566D92F.8090802@melag.de> <1432809845.3228.25.camel@pengutronix.de>
	 <5566FC95.3020000@melag.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 28.05.2015, 13:31 +0200 schrieb Enrico Weigelt, metux
IT consult:
> Am 28.05.2015 um 12:44 schrieb Philipp Zabel:
> 
> Hi,
> 
>  >> Are these patches same as in your git branch tmp/imx-ipu-scaler ?
> >
> > No, that is an older version.
> 
> Where can I get the recent ones ?
> Could you push it to your public repo ?

I've updated the tmp/imx-ipu-scaler branch.

> >> when using it w/ gst for video playback, can be directly pass buffers
> >> between VPU, IPU and FB (or let them directly write into shared
> >> buffers), so CPU doesn't need to act on each frame for each step
> >> in the decoding pipeline ?
> >
> > Check out the (capture/output-)io-mode parameters, that's what the
> > dmabuf/dmabuf-import option pairs are for.
> 
> Tried dmabuf, but load stays at the same (77..80% CPU, 1.2 loadavg).
> dmabuf-import doesnt run at all:
> 
> root@KoMo:/usr/share/videos/komo gst-launch-1.0 filesrc
> location=montage.mp4 \! qtdemux \! h264parse \! v4l2video4dec
> output-io-mode=5 \! v4l2video0convert capture-io-mode=5 output-io-mode=4
> \! fbdevsink

That should be capture-io-mode=dmabuf for the decoder and
output-io-mode=dmabuf-import for the converter element. h264parse
doesn't provide and fbdevsink can't handle dmabufs, so the decoder's
output-io-mode and the converter's capture-io-mode should be kept as
mmio.

[...]
> By the way: do you have any idea whether the proprietary driver
> (or the gpus itself) might talk to ipu and vpu ?

Not that I am aware of.

regards
Philipp

