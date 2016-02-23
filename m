Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37053 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbcBWU1S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 15:27:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julian Scheel <julian@jusst.de>
Cc: linux-media@vger.kernel.org, lars@metafoo.de, hverkuil@xs4all.nl
Subject: Re: [PATCH] media: adv7180: Add of compatible strings for full family
Date: Tue, 23 Feb 2016 22:27:15 +0200
Message-ID: <4025117.uKWex5FVEX@avalon>
In-Reply-To: <56CCBD1D.6070900@jusst.de>
References: <1456228699-22575-1-git-send-email-julian@jusst.de> <1941393.Upgl0HgCbF@avalon> <56CCBD1D.6070900@jusst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julian,

On Tuesday 23 February 2016 21:12:13 Julian Scheel wrote:
> Hi Laurent,
> 
> thanks for the fast review :)
> 
> On 23.02.16 21:06, Laurent Pinchart wrote:
> > On Tuesday 23 February 2016 12:58:19 Julian Scheel wrote:
> >> Add entries for all supported chip variants into the of_match list, so
> >> that the matching driver_info can be selected when using dt.
> > 
> > How about starting by adding a DT bindings document ?
> 
> Probably a good thing to do. Didn't think about it as the of_match table
> was already there. Are you ok with the document being added within this
> commit or shall I better split it?

A separate patch would be nice if you don't mind.

> >> Change-Id: I6ff849726c8f475c81e848423b27c35f2ccb0509
> > 
> > I sympathize with you for the pain gerrit is inflicting on you, but don't
> > share it with all upstream developers please, you can remove this :-)
> 
> Hah, so true. Will drop it in v2 :)

Thanks.

> >> Signed-off-by: Julian Scheel <julian@jusst.de>
> >> ---
> >> 
> >>   drivers/media/i2c/adv7180.c | 8 ++++++++
> >>   1 file changed, 8 insertions(+)
> >> 
> >> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> >> index ff57c1d..5515f3d 100644
> >> --- a/drivers/media/i2c/adv7180.c
> >> +++ b/drivers/media/i2c/adv7180.c
> >> @@ -1328,6 +1328,14 @@ static SIMPLE_DEV_PM_OPS(adv7180_pm_ops,
> >> adv7180_suspend, adv7180_resume);
> >> #ifdef CONFIG_OF
> >>   static const struct of_device_id adv7180_of_id[] = {
> >>   	{ .compatible = "adi,adv7180", },
> >> +	{ .compatible = "adi,adv7182", },
> >> +	{ .compatible = "adi,adv7280", },
> >> +	{ .compatible = "adi,adv7280-m", },
> >> +	{ .compatible = "adi,adv7281", },
> >> +	{ .compatible = "adi,adv7281-m", },
> >> +	{ .compatible = "adi,adv7281-ma", },
> >> +	{ .compatible = "adi,adv7282", },
> >> +	{ .compatible = "adi,adv7282-m", },
> >>   	{ },
> >>   };

-- 
Regards,

Laurent Pinchart

