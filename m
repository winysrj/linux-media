Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbeH1QNX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 12:13:23 -0400
MIME-Version: 1.0
References: <20180828015252.28511-1-robh@kernel.org> <20180828015252.28511-28-robh@kernel.org>
 <2863201.EMhOTYQe29@avalon>
In-Reply-To: <2863201.EMhOTYQe29@avalon>
From: Rob Herring <robh@kernel.org>
Date: Tue, 28 Aug 2018 07:21:46 -0500
Message-ID: <CAL_JsqKdLoH9X_ThSr45NOqijWRBJgC7eV_iCrCXf5Jhu-dpkQ@mail.gmail.com>
Subject: Re: [PATCH] media: Convert to using %pOFn instead of device_node.name
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 28, 2018 at 5:06 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Rob,
>
> Thank you for the patch.
>
> On Tuesday, 28 August 2018 04:52:29 EEST Rob Herring wrote:
> > In preparation to remove the node name pointer from struct device_node,
> > convert printf users to use the %pOFn format specifier.
> >
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> > Cc: Benoit Parrot <bparrot@ti.com>
> > Cc: Philipp Zabel <p.zabel@pengutronix.de>
> > Cc: Hyun Kwon <hyun.kwon@xilinx.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Michal Simek <michal.simek@xilinx.com>
> > Cc: linux-media@vger.kernel.org
> > Signed-off-by: Rob Herring <robh@kernel.org>
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> Which tree would you like to merge this through ?

Media tree. There's no dependency.

Rob
