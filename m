Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56610 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbdFZQAP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 12:00:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kbingham@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@iki.fi,
        niklas.soderlund@ragnatech.se
Subject: Re: [PATCH v4 1/2] media: i2c: adv748x: add adv748x driver
Date: Mon, 26 Jun 2017 19:00:13 +0300
Message-ID: <12087293.ibczxtmbyi@avalon>
In-Reply-To: <530a839a-c828-b0cd-03de-858aa69d266c@ideasonboard.com>
References: <cover.d0545e32d322ca1b939fa2918694173629e680eb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com> <07ad1ecd-a63e-3c94-87ad-4e1978759011@xs4all.nl> <530a839a-c828-b0cd-03de-858aa69d266c@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[snip]

On Monday 26 Jun 2017 16:14:47 Kieran Bingham wrote:
> >> +int adv748x_txa_power(struct adv748x_state *state, bool on)
> >> +{
> >> +    int val;
> >> +
> >> +    val = txa_read(state, ADV748X_CSI_FS_AS_LS);
> >> +    if (val < 0)
> >> +        return val;
> >> +
> >> +    /*
> >> +     * This test against BIT(6) is not documented by the datasheet, but
> >> was +     * specified in the downstream driver.
> >> +     * Track with a WARN_ONCE to determine if it is ever set by HW.
> >> +     */
> >> +    WARN_ONCE((on && val & ADV748X_CSI_FS_AS_LS_UNKNOWN),
> >> +            "Enabling with unknown bit set");
> >> +
> >> +    if (on)
> >> +        return adv748x_write_regs(state, adv748x_power_up_txa_4lane);
> >> +    else
> >
> > 'else' isn't needed.
> 
> That's a shame - I think the code is more elegant (/symmetrical) this way -
> but no worries.
> Adapted. (same for the others)

For what it's worth, I would personally have kept the else here. I'm all for

	if (simple_case) {
		handle_simple_case();
		return 0;
	}

	/* Complex case */

or similar constructs with s/simple_case/uncommon_case/ or 
s/simple_case/error_case/, but here the two branches are small and symmetric, 
so an else makes sense to me to highlight that symmetry.

> >> +        return adv748x_write_regs(state, adv748x_power_down_txa_4lane);
> >> +}

-- 
Regards,

Laurent Pinchart
