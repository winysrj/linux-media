Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39110 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaDQOn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:43:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 45/49] adv7604: Add DT support
Date: Thu, 17 Apr 2014 16:43:29 +0200
Message-ID: <2187787.ESP9YKtS5Y@avalon>
In-Reply-To: <534FE7A1.8060800@samsung.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com> <1397744000-23967-46-git-send-email-laurent.pinchart@ideasonboard.com> <534FE7A1.8060800@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 17 April 2014 16:39:29 Sylwester Nawrocki wrote:
> On 17/04/14 16:13, Laurent Pinchart wrote:
> > Parse the device tree node to populate platform data. Only the ADV7611
> > is currently support with DT.
> > 
> > Cc: devicetree@vger.kernel.org
> > Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The patch looks good to me.
> 
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Thank you.

> Just one comment below...

[snip]

> > diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> > index 342d73d..061794e 100644
> > --- a/drivers/media/i2c/adv7604.c
> > +++ b/drivers/media/i2c/adv7604.c
> > @@ -2663,13 +2663,58 @@ static const struct adv7604_chip_info
> > adv7604_chip_info[] = {> 
> >  	},
> >  
> >  };
> > 
> > +static struct i2c_device_id adv7604_i2c_id[] = {
> > +	{ "adv7604", (kernel_ulong_t)&adv7604_chip_info[ADV7604] },
> > +	{ "adv7611", (kernel_ulong_t)&adv7604_chip_info[ADV7611] },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
> > +
> > +static struct of_device_id adv7604_of_id[] = {
> 
> Not adding __maybe_unused attribute to this one ?

Sure, of course. I'll squash patch 49/49 into this one.

> > +	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, adv7604_of_id);

-- 
Regards,

Laurent Pinchart

