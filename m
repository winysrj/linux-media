Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:34474 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbeDQAFP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 20:05:15 -0400
Received: by mail-lf0-f46.google.com with SMTP id r7-v6so17570469lfr.1
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 17:05:14 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 17 Apr 2018 02:05:11 +0200
To: jacopo mondi <jacopo@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180417000511.GA14371@bigcity.dyn.berto.se>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
 <20180405091001.GI20945@w540>
 <20180415231635.GH20093@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180415231635.GH20093@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 2018-04-16 01:16:35 +0200, Niklas Söderlund wrote:

[snip]

> > > +
> > > +	/* Set frequency range if we have it */
> > > +	if (priv->info->csi0clkfreqrange)
> > > +		rcar_csi2_write(priv, CSI0CLKFCPR_REG,
> > > +				CSI0CLKFREQRANGE(priv->info->csi0clkfreqrange));
> > > +
> > > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt);
> > > +	rcar_csi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
> > > +			LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
> > > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
> > > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ |
> > > +			PHYCNT_RSTZ);
> > 
> > Nit: from tables 25.[17-20] it seems to me you do not have to re-issue
> > PHYCNT_SHUTDOWNZ when writing PHYCNT_RSTZ to PHYCNT_REG.
> 
> You are correct, I miss read '.... Here, the ENABLE_0 to ENABLE_3 and
> ENABLECLK values set above should be retained' as all previous PHYCNT 
> bits should be retained not just the ones explicitly listed. I will give 
> this a test and if it still works I will remove it for the next version.

This change breaks capture and LP-11 is never detected. So I will 
continue to retain the PHYCNT_SHUTDOWNZ here.

-- 
Regards,
Niklas Söderlund
