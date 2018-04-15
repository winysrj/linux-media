Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:41129 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752554AbeDOSux (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 14:50:53 -0400
Received: by mail-lf0-f68.google.com with SMTP id m202-v6so1715820lfe.8
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2018 11:50:53 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sun, 15 Apr 2018 20:50:51 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: kieran.bingham@ideasonboard.com, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180415185051.GC20093@bigcity.dyn.berto.se>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
 <eb0b92de-cb09-9d72-8d46-80a0359184f2@ideasonboard.com>
 <3087271.YPSegSqyCH@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3087271.YPSegSqyCH@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

On 2018-04-04 18:25:23 +0300, Laurent Pinchart wrote:

[snip]

> > > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > b/drivers/media/platform/rcar-vin/rcar-csi2.c new file mode 100644
> > > index 0000000000000000..c0c2a763151bc928
> > > --- /dev/null
> > > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > @@ -0,0 +1,884 @@
> > > +// SPDX-License-Identifier: GPL-2.0+
> 
> Do you intend making it GPL-2.0+ or did you mean GPL-2.0 ?

Wops I intended to make it GPL-2.0 thanks for catching this.

-- 
Regards,
Niklas Söderlund
