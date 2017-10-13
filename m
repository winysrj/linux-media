Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:21726 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdJMR64 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 13:58:56 -0400
Date: Fri, 13 Oct 2017 12:58:17 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Tero Kristo <t-kristo@ti.com>, Rob Herring <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: [Patch 2/6] ARM: DRA7: hwmod: Add CAL nodes
Message-ID: <20171013175817.GG25400@ti.com>
References: <20171012192719.15193-1-bparrot@ti.com>
 <20171012192719.15193-3-bparrot@ti.com>
 <20171013165654.GK4394@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20171013165654.GK4394@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tony Lindgren <tony@atomide.com> wrote on Fri [2017-Oct-13 09:56:54 -0700]:
> * Benoit Parrot <bparrot@ti.com> [171012 12:28]:
> > This patch adds the required hwmod nodes to support the Camera
> > Adaptation Layer (CAL) for the DRA72 family of devices.
> ...
> 
> > +static struct omap_hwmod_class_sysconfig dra7xx_cal_sysc = {
> > +	.sysc_offs	= 0x0010,
> 
> Also has .rev_offs at 0 so please add that too.

Ok, I'll add that.

Benoit

> 
> Regards,
> 
> Tony
