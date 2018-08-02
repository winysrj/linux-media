Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50424 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387478AbeHBQaX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 12:30:23 -0400
Date: Thu, 2 Aug 2018 11:38:44 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 16/22] [media] tvp5150: add querystd
Message-ID: <20180802113844.6425a23a@coco.lan>
In-Reply-To: <20180802101641.5oyo25ztbh45wcvh@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
        <20180628162054.25613-17-m.felsch@pengutronix.de>
        <20180730150945.3301864f@coco.lan>
        <20180801132125.j4725kthupcc7fnd@pengutronix.de>
        <20180801112212.4f450528@coco.lan>
        <20180801144926.ijqotetin4uhtxw6@pengutronix.de>
        <20180801125056.5d0b14c7@coco.lan>
        <20180802080101.b3en5xcjclcyopfa@pengutronix.de>
        <20180802064900.3dfbd0ec@coco.lan>
        <20180802101641.5oyo25ztbh45wcvh@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 2 Aug 2018 12:16:41 +0200
Marco Felsch <m.felsch@pengutronix.de> escreveu:

> > > Did you drop the DT of_graph support patch? It was there on your first
> > > tvp5150 branch.   
> > 
> > Yes. As discussed, I'm waiting for a replacement patch from you. So,
> > after testing, I removed it, in order to make simpler to add your
> > replacement patch.
> > 
> > IMO, the proper mapping is one input linked to (up to) 3 connectors.  
> 
> I tought it would be okay to have more than 1 input pad since the
> .sig_type pad property. So the tvp5150 media entity can be represented
> like the physical tvp5150 chip.

As I said, tvp5150 has internally two physical inputs only: AIP1A and AIP1B.

IMO, it should be creating 3 PADS (two inputs and the output one), e. g.
something like (names here are just a suggestion):

	TVP5150_PAD_IN_AIP1A,
	TVP5150_PAD_IN_AIP1B,
	TVP5150_PAD_OUT

The S-video connector (if present) should be linked to both inputs.

I discussed this with other core maintainers: we all have the same
opinion about that.

I'll post a separate e-mail from the discussions for you and others to
comment.

It would need some logic that will enforce that just one connector link
will be active on any given time (e. g. when a link is enabled, 
it should disable the other links).

> 
> I will fix it, if it isn't the right way.

Ok.

Thanks,
Mauro
