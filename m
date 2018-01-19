Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:42359 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754507AbeASAqH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 19:46:07 -0500
Received: by mail-lf0-f54.google.com with SMTP id q17so70133lfa.9
        for <linux-media@vger.kernel.org>; Thu, 18 Jan 2018 16:46:07 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 19 Jan 2018 01:46:03 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 19/28] rcar-vin: use different v4l2 operations in
 media controller mode
Message-ID: <20180119004603.GD10270@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
 <20171208010842.20047-20-niklas.soderlund+renesas@ragnatech.se>
 <4037381.ip89KhYXee@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4037381.ip89KhYXee@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your comments.

Apart from the issue with the input API Hans pointed which indicates I 
need to keep that around until it's fixed in the framework I agree with 
all your comments but one.

<snip>

On 2017-12-08 12:14:05 +0200, Laurent Pinchart wrote:
> > @@ -628,7 +628,8 @@ static int rvin_setup(struct rvin_dev *vin)
> >  		/* Default to TB */
> >  		vnmc = VNMC_IM_FULL;
> >  		/* Use BT if video standard can be read and is 60 Hz format */
> > -		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
> > +		if (!vin->info->use_mc &&
> > +		    !v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
> >  			if (std & V4L2_STD_525_60)
> >  				vnmc = VNMC_IM_FULL | VNMC_FOC;
> >  		}
> 
> I think the subdev should be queried in rcar-v4l2.c and the information cached 
> in the rvin_dev structure instead of queried here. Interactions with the 
> subdev should be minimized in rvin-dma.c. You can fix this in a separate patch 
> if you prefer.
> 

This can't be a cached value it needs to be read at stream on time. The 
input source could have changed format, e.g. the user may have 
disconnected a NTSC source and plugged in a PAL.

This is a shame as I otherwise agree with you that interactions with the 
subdevice should be kept at a minimum.

<snip>

-- 
Regards,
Niklas Söderlund
