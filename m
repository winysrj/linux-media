Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42811 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153AbbHKLQI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 07:16:08 -0400
Date: Tue, 11 Aug 2015 04:16:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Michael Allwright <michael.allwright@upb.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>, Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH RFC] DT support for omap4-iss
Message-ID: <20150811111604.GD10928@atomide.com>
References: <CALcgO_6UXp-Xqwim8WpLXz7XWAEpejipR7JNQc0TdH0ETL4JYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALcgO_6UXp-Xqwim8WpLXz7XWAEpejipR7JNQc0TdH0ETL4JYQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Michael Allwright <michael.allwright@upb.de> [150810 08:19]:
> +
> +/*
> +We need a better solution for this
> +*/
> +#include <../arch/arm/mach-omap2/omap-pm.h>

Please let's not do things like this, I end up having to deal with
all these eventually :(

> +static void iss_set_constraints(struct iss_device *iss, bool enable)
> +{
> +    if (!iss)
> +        return;
> +
> +    /* FIXME: Look for something more precise as a good throughtput limit */
> +    omap_pm_set_min_bus_tput(iss->dev, OCP_INITIATOR_AGENT,
> +                 enable ? 800000 : -1);
> +}
> +
> +static struct iss_platform_data iss_dummy_pdata = {
> +    .set_constraints = iss_set_constraints,
> +};

If this is one time setting, you could do it based on the
compatible string using arch/arm/mach-omap2/pdata-quirks.c.

If you need to toggle it, you could populate a function pointer
in pdata-quirks.c. Those are easy to fix once there is some Linux
generic API available :)

Regards,

Tony
