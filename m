Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:44088 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752251AbdJMQ46 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 12:56:58 -0400
Date: Fri, 13 Oct 2017 09:56:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [Patch 2/6] ARM: DRA7: hwmod: Add CAL nodes
Message-ID: <20171013165654.GK4394@atomide.com>
References: <20171012192719.15193-1-bparrot@ti.com>
 <20171012192719.15193-3-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012192719.15193-3-bparrot@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Benoit Parrot <bparrot@ti.com> [171012 12:28]:
> This patch adds the required hwmod nodes to support the Camera
> Adaptation Layer (CAL) for the DRA72 family of devices.
...

> +static struct omap_hwmod_class_sysconfig dra7xx_cal_sysc = {
> +	.sysc_offs	= 0x0010,

Also has .rev_offs at 0 so please add that too.

Regards,

Tony
