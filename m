Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50584 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753239AbeDPJa2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 05:30:28 -0400
Date: Mon, 16 Apr 2018 12:30:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180416093023.dqadxxa3dm72s24w@valkosipuli.retiisi.org.uk>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
 <20180329113039.4v5whquyrtgf5yaa@flea>
 <20180404201357.kx7e4dbqurn5zx2r@valkosipuli.retiisi.org.uk>
 <20180415204737.GF20093@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180415204737.GF20093@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Sun, Apr 15, 2018 at 10:47:37PM +0200, Niklas Söderlund wrote:
> Hi Sakari,
> 
> Thanks for your feedback.
> 
> On 2018-04-04 23:13:57 +0300, Sakari Ailus wrote:
> 
> [snip]
> 
> > > > +	pm_runtime_enable(&pdev->dev);
> > > 
> > > Is CONFIG_PM mandatory on Renesas SoCs? If not, you end up with the
> > > device uninitialised at probe, and pm_runtime_get_sync will not
> > > initialise it either if CONFIG_PM is not enabled. I guess you could
> > > call your runtime_resume function unconditionally, and mark the device
> > > as active in runtime_pm using pm_runtime_set_active.
> > 
> > There doesn't seem to be any runtime_resume function. Was there supposed
> > to be one?
> 
> No there is not suppose to be one.

Ok.

> 
> > 
> > Assuming runtime PM would actually do something here, you might add
> > pm_runtime_idle() to power the device off after probing.
> > 
> > I guess pm_runtime_set_active() should precede pm_runtime_enable().
> 
> The CSI-2 is in the always on power domain so the calls to 
> pm_runtime_get_sync() and pm_runtime_put() are there in the s_stream() 
> callback to enable and disable the module clock. I'm no expert on PM but 
> in my testing the pm_ calls in this driver seems to be correct.
> 
> 1. In probe I call pm_runtime_enable(). And rudimentary tests shows the 
>    clock is off (but I might miss something) as I wish it to be until 
>    stream on time.
> 2. In s_stream() I call pm_runtime_get_sync() before writing any 
>    register when starting a stream. And likewise I call pm_runtime_put() 
>    when stopping and I no longer need to write to a register.
> 3. In remove() I call pm_runtime_disable().
> 
> Am I missing something obvious here?

Looking at the code again, it seems fine in this respect.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
