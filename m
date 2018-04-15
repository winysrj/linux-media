Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:39772 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752537AbeDOUrk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 16:47:40 -0400
Received: by mail-lf0-f41.google.com with SMTP id p142-v6so19195080lfd.6
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2018 13:47:39 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sun, 15 Apr 2018 22:47:37 +0200
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180415204737.GF20093@bigcity.dyn.berto.se>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
 <20180329113039.4v5whquyrtgf5yaa@flea>
 <20180404201357.kx7e4dbqurn5zx2r@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180404201357.kx7e4dbqurn5zx2r@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for your feedback.

On 2018-04-04 23:13:57 +0300, Sakari Ailus wrote:

[snip]

> > > +	pm_runtime_enable(&pdev->dev);
> > 
> > Is CONFIG_PM mandatory on Renesas SoCs? If not, you end up with the
> > device uninitialised at probe, and pm_runtime_get_sync will not
> > initialise it either if CONFIG_PM is not enabled. I guess you could
> > call your runtime_resume function unconditionally, and mark the device
> > as active in runtime_pm using pm_runtime_set_active.
> 
> There doesn't seem to be any runtime_resume function. Was there supposed
> to be one?

No there is not suppose to be one.

> 
> Assuming runtime PM would actually do something here, you might add
> pm_runtime_idle() to power the device off after probing.
> 
> I guess pm_runtime_set_active() should precede pm_runtime_enable().

The CSI-2 is in the always on power domain so the calls to 
pm_runtime_get_sync() and pm_runtime_put() are there in the s_stream() 
callback to enable and disable the module clock. I'm no expert on PM but 
in my testing the pm_ calls in this driver seems to be correct.

1. In probe I call pm_runtime_enable(). And rudimentary tests shows the 
   clock is off (but I might miss something) as I wish it to be until 
   stream on time.
2. In s_stream() I call pm_runtime_get_sync() before writing any 
   register when starting a stream. And likewise I call pm_runtime_put() 
   when stopping and I no longer need to write to a register.
3. In remove() I call pm_runtime_disable().

Am I missing something obvious here?

-- 
Regards,
Niklas Söderlund
