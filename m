Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59955 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751392AbdAMLSM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 06:18:12 -0500
Message-ID: <1484306282.31475.2.camel@pengutronix.de>
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
Date: Fri, 13 Jan 2017 12:18:02 +0100
In-Reply-To: <9cb9acd3-09fe-1478-9ab4-de6da8866993@mentor.com>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
         <20161019213026.GU9460@valkosipuli.retiisi.org.uk>
         <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
         <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de>
         <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
         <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com>
         <1483990983.13625.58.camel@pengutronix.de>
         <43564c16-f7aa-2d35-a41f-991465faaf8b@mentor.com>
         <5b4bb7bd-83ae-c1f3-6b24-989dd6b0aa48@mentor.com>
         <1484136644.2934.89.camel@pengutronix.de>
         <8e6092a3-d80b-fe01-11b4-fbebe1de3102@mentor.com>
         <d8001f56-7e5b-7b23-1dc2-0c3cef5b6ceb@mentor.com>
         <9cb9acd3-09fe-1478-9ab4-de6da8866993@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 12.01.2017, 18:22 -0800 schrieb Steve Longerbeam:
> 
> On 01/12/2017 03:43 PM, Steve Longerbeam wrote:
> >
> >
> > On 01/12/2017 03:22 PM, Steve Longerbeam wrote:
> >>
> >>
> >>>> and since my PRPVF entity roles
> >>>> up the VDIC internally, it is actually receiving from the VDIC 
> >>>> channel.
> >>>> So unless you think we should have a distinct VDIC entity, I would 
> >>>> like
> >>>> to keep this
> >>>> the way it is.
> >>> Yes, I think VDIC should be separated out of PRPVF. What do you think
> >>> about splitting the IC PRP into three parts?
> >>>
> >>> PRP could have one input pad connected to either CSI0, CSI1, or VDIC,
> >>> and two output pads connected to PRPVF and PRPENC, respectively. This
> >>> would even allow to have the PRP describe the downscale and PRPVF and
> >>> PRPENC describe the bilinear upscale part of the IC.
> >
> > Actually, how about the following:
> >
> > PRP would have one input pad coming from CSI0, CSI1, or VDIC. But
> > instead of another level of indirection with two more PRPENC and PRPVF
> > entities, PRP would instead have two output pads, one for PRPVF output
> > and one for PRPENC output.
> >
> > Both output pads could be activated if the input is connected to CSI0 
> > or CSI1.
> > And only the PRPVF output can be activated if the input is from VDIC.

Regarding the single input issue, I'd be fine with that too. But I
really like the idea of splitting the downsize section from the main
processing section because seeing the decimated resolution at the
downsize output pad makes it really obvious why the resulting frames are
blurry.

> Actually that proved too difficult. I went with your original idea. 
> Branch that
> implements this is imx-media-staging-md-prp. The media dot graph looks good
> but I have not tested yet. I'll start testing it tomorrow.

Thanks, I'll have a look.

regards
Philipp


