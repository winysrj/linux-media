Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56030 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbeILUPO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 16:15:14 -0400
Date: Wed, 12 Sep 2018 12:10:12 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: Convert to using %pOFn instead of
 device_node.name
Message-ID: <20180912121012.33cc3c21@coco.lan>
In-Reply-To: <CAL_JsqKdLoH9X_ThSr45NOqijWRBJgC7eV_iCrCXf5Jhu-dpkQ@mail.gmail.com>
References: <20180828015252.28511-1-robh@kernel.org>
        <20180828015252.28511-28-robh@kernel.org>
        <2863201.EMhOTYQe29@avalon>
        <CAL_JsqKdLoH9X_ThSr45NOqijWRBJgC7eV_iCrCXf5Jhu-dpkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 28 Aug 2018 07:21:46 -0500
Rob Herring <robh@kernel.org> escreveu:

> On Tue, Aug 28, 2018 at 5:06 AM Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> >
> > Hi Rob,
> >
> > Thank you for the patch.
> >
> > On Tuesday, 28 August 2018 04:52:29 EEST Rob Herring wrote:  
> > > In preparation to remove the node name pointer from struct device_node,
> > > convert printf users to use the %pOFn format specifier.
> > >
> > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> > > Cc: Benoit Parrot <bparrot@ti.com>
> > > Cc: Philipp Zabel <p.zabel@pengutronix.de>
> > > Cc: Hyun Kwon <hyun.kwon@xilinx.com>
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Cc: Michal Simek <michal.simek@xilinx.com>
> > > Cc: linux-media@vger.kernel.org
> > > Signed-off-by: Rob Herring <robh@kernel.org>  
> >
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >
> > Which tree would you like to merge this through ?  
> 
> Media tree. There's no dependency.

Ok. I'm applying it.

> 
> Rob



Thanks,
Mauro
