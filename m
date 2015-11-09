Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44881 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbbKIQPq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 11:15:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] mt9v032: Add reset and standby gpios
Date: Mon, 09 Nov 2015 18:15:56 +0200
Message-ID: <3310512.E4vEfn7BXV@avalon>
In-Reply-To: <5144598.EqybrDukyg@adelgunde>
References: <1446815625-18413-1-git-send-email-mpa@pengutronix.de> <1763974.WDKlRvPG0G@avalon> <5144598.EqybrDukyg@adelgunde>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

On Monday 09 November 2015 16:33:03 Markus Pargmann wrote:
> On Monday 09 November 2015 14:28:56 Laurent Pinchart wrote:
> > On Friday 06 November 2015 14:13:43 Markus Pargmann wrote:
> >> Add optional reset and standby gpios. The reset gpio is used to reset
> >> the chip in power_on().
> >> 
> >> The standby gpio is not used currently. It is just unset, so the chip is
> >> not in standby.
> > 
> > We could use a gpio hog for this, but given that the standby signal should
> > eventually get used, and given that specifying it in DT is a good hardware
> > description, that looks good to me.
> > 
> >> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> >> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> >> ---
> >> 
> >>  .../devicetree/bindings/media/i2c/mt9v032.txt      |  2 ++
> >>  drivers/media/i2c/mt9v032.c                        | 23 +++++++++++++++
> >>  2 files changed, 25 insertions(+)

[snip]

> > If you're fine with these changes there's no need to resubmit the patch, I
> > can fix it when applying it to my tree.
> 
> Thanks, I am fine with all your changes. But as there will be a v2 for the
> other two patches I could as well send an updated version if you wish.

As you wish, both options are fine with me.

-- 
Regards,

Laurent Pinchart

