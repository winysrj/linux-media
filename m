Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:34867 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750765AbdAXSLM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jan 2017 13:11:12 -0500
Message-ID: <1485281461.3600.138.camel@pengutronix.de>
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Marek Vasut <marex@denx.de>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 24 Jan 2017 19:11:01 +0100
In-Reply-To: <1483990983.13625.58.camel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
         <20161019213026.GU9460@valkosipuli.retiisi.org.uk>
         <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
         <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de>
         <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
         <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com>
         <1483990983.13625.58.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Mon, 2017-01-09 at 20:43 +0100, Philipp Zabel wrote:
> On the other hand, there is currently no way to communicate to userspace
> that the IC can't downscale bilinearly, but only to 1/2 or 1/4 of the
> input resolution, and then scale up bilinearly for there.

This is completely wrong.

For some reason I that I can't reconstruct anymore, I didn't realize
that the PRPENC/VF_RS_R_V/H coefficient fields for the resizing section
are 14 bits wide, so the bilinear scaling factor can in fact be reduced
down to 8192/16383 ~= 0.50003 before the /2 downsizing section needs to
be engaged.

>  So instead of
> pretending to be able to downscale to any resolution, it would be better
> to split each IC task into two subdevs, one for the
> 1/2-or-1/4-downscaler, and one for the bilinear upscaler.

So this point is moot. I still like the unified PRP subdev because of
the single input pad, but splitting the scaling over two subdevs is not
useful after all.

regards
Philipp
