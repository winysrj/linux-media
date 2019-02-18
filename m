Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89CDC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 01:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B349218AD
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 01:44:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="HjOVtcz0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbfBRBoA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 20:44:00 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33821 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfBRBn7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 20:43:59 -0500
Received: by mail-lj1-f196.google.com with SMTP id l5so9496870lje.1
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2019 17:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=YZJoplqrlNuozjljc/2kkOx246y5WC6ILUQHMWpM11s=;
        b=HjOVtcz0OuVYn3zpD6GjLUTR5zQx9CD9AMAeOUAhLWodKUF5p48Ova0f23TGb8omSd
         /GsxQPZaY+7bpzc2JO/yLf0hF36j7se1yQTTt/UmymjrVVkrYEt1j1mplwnhMdm7UH4u
         WYxKzi9+8TY8xeUCZkJK82pR+AW2fIITfGZ1Bwb1F+uYSY/WYpoQx1WAY1LkAEw+WoGN
         bIpShRWuWvir+8IfajoqtJQUWxffryZu163uG8lfnuIC28mgVGTcZpFo1a7g3dRuFKil
         T05bwj8W77oLitCZM5awlc63gj9hnzLil09/DAwqBPvL6X8+e/akieucJvXfdf0TulkF
         ln5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=YZJoplqrlNuozjljc/2kkOx246y5WC6ILUQHMWpM11s=;
        b=VSgDuFCGBp8cWklT9ujjRk+Z5N59sIi4ZYxeUb2WOJRLI6ZVlkSdXweQoxM/r6m95F
         AevSxkpav0pHa1Zsi2d6+kl3+MyMfzf2BvXvZMOoHR8zV7vG5pB5O0WX+tsyi87DEgDa
         fPehek33TaLiRQ8QSCSSI8otN+9aXgzOq51cMECm4Bi+IA24bjWyC4aKc5A9ZiM0mIm0
         RRmSf/u0uMLUZNwiNRRlbbwvUUFjuuIb7E6KFqyNrwqhXQcCskydow3drO8HfYA7q3Z3
         STUDjkuQbhD47mWH1OflHs0IRPb1WFgoyhyukK8NhaV/IlLtjDxjWBaDeCKkzmJwXzS+
         wD+Q==
X-Gm-Message-State: AHQUAubehlYmPc7ouQI8JY1M/A4rUKUcKkbwMyf+RPJ/LjAZfbCnHkwO
        nxt6ZzKjj9IM9q5erw89XGIofQ==
X-Google-Smtp-Source: AHgI3IbM4lycvBp3oKgZtYmG8uMBd0fRet3ssrMB2EadR0MI5OblfeE/9alG09zAA7mhq4Q199Jdyw==
X-Received: by 2002:a2e:9448:: with SMTP id o8-v6mr8549518ljh.164.1550454236812;
        Sun, 17 Feb 2019 17:43:56 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id h7-v6sm3354402ljc.45.2019.02.17.17.43.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Feb 2019 17:43:55 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Mon, 18 Feb 2019 02:43:55 +0100
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-vin: Fix lockdep warning at stream on
Message-ID: <20190218014355.GF31263@bigcity.dyn.berto.se>
References: <20190213220754.14664-1-niklas.soderlund+renesas@ragnatech.se>
 <5a6c4b25-7639-b4b9-bcc8-0da9374e6697@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5a6c4b25-7639-b4b9-bcc8-0da9374e6697@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

On 2019-02-17 22:27:27 +0000, Kieran Bingham wrote:
> Hi Niklas,
> 
> On 13/02/2019 22:07, Niklas Söderlund wrote:
> > Changes to v4l2-fwnode in commit [1] triggered a lockdep warning in
> > rcar-vin. The first attempt to solve this warning in the rcar-vin driver
> > was incomplete and only pushed the warning to happen at at stream on
> > time instead of at probe time.
> > 
> > This change reverts the incomplete fix and properly fix the warning by
> > removing the need to hold the rcar-vin specific group lock when calling
> > v4l2_async_notifier_parse_fwnode_endpoints_by_port(). And instead takes
> > it in the callback where it's really needed.
> > 
> 
> It might have been more readable to provide the revert and the fix
> separately, as it's hard to know which parts of this are the revert, and
> which are 'new', but don't worry about that as it is fortuanately a
> fairly clear separation below..

I agree it would have been clearer to have it as two patches, I wanted 
to make backporting as easy as possible so I kept it in the same patch, 
I'm happy to split it into two if you think it's better.

> 
> 
> > 1. commit eae2aed1eab9bf08 ("media: v4l2-fwnode: Switch to v4l2_async_notifier_add_subdev")
> > 
> > Fixes: 6458afc8c49148f0 ("media: rcar-vin: remove unneeded locking in async callbacks")
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> 
> Only a couple of minorish comments below.
> 
> With those fixed:
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> 
> 
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 43 +++++++++++++++------
> >  1 file changed, 32 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > index 594d804340047511..abbb5820223965e3 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -546,7 +546,9 @@ static void rvin_parallel_notify_unbind(struct v4l2_async_notifier *notifier,
> >  
> >  	vin_dbg(vin, "unbind parallel subdev %s\n", subdev->name);
> >  
> > +	mutex_lock(&vin->lock);
> >  	rvin_parallel_subdevice_detach(vin);
> > +	mutex_unlock(&vin->lock);
> >  }
> >  
> >  static int rvin_parallel_notify_bound(struct v4l2_async_notifier *notifier,
> > @@ -556,7 +558,9 @@ static int rvin_parallel_notify_bound(struct v4l2_async_notifier *notifier,
> >  	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
> >  	int ret;
> >  
> > +	mutex_lock(&vin->lock);
> >  	ret = rvin_parallel_subdevice_attach(vin, subdev);
> > +	mutex_unlock(&vin->lock);
> >  	if (ret)
> >  		return ret;
> >  
> > @@ -664,6 +668,7 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
> >  	}
> >  
> >  	/* Create all media device links between VINs and CSI-2's. */
> > +	mutex_lock(&vin->group->lock);
> >  	for (route = vin->info->routes; route->mask; route++) {
> >  		struct media_pad *source_pad, *sink_pad;
> >  		struct media_entity *source, *sink;
> > @@ -699,6 +704,7 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
> >  			break;
> >  		}
> >  	}
> > +	mutex_unlock(&vin->group->lock);
> >  
> >  	return ret;
> >  }
> > @@ -714,6 +720,8 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
> >  		if (vin->group->vin[i])
> >  			rvin_v4l2_unregister(vin->group->vin[i]);
> >  
> > +	mutex_lock(&vin->group->lock);
> > +
> >  	for (i = 0; i < RVIN_CSI_MAX; i++) {
> >  		if (vin->group->csi[i].fwnode != asd->match.fwnode)
> >  			continue;
> > @@ -721,6 +729,8 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
> >  		vin_dbg(vin, "Unbind CSI-2 %s from slot %u\n", subdev->name, i);
> >  		break;
> >  	}
> > +
> > +	mutex_unlock(&vin->group->lock);
> >  }
> >  
> >  static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
> > @@ -730,6 +740,8 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
> >  	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
> >  	unsigned int i;
> >  
> > +	mutex_lock(&vin->group->lock);
> > +
> >  	for (i = 0; i < RVIN_CSI_MAX; i++) {
> >  		if (vin->group->csi[i].fwnode != asd->match.fwnode)
> >  			continue;
> > @@ -738,6 +750,8 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
> >  		break;
> >  	}
> >  
> > +	mutex_unlock(&vin->group->lock);
> > +
> >  	return 0;
> >  }
> 
> So if I'm not mistaken, everything above this is the 'revert' and the
> below is the 'fix'

Correct :-)

> 
> 
> 
> 
> >  
> > @@ -752,6 +766,7 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
> >  				     struct v4l2_async_subdev *asd)
> >  {
> >  	struct rvin_dev *vin = dev_get_drvdata(dev);
> > +	int ret = 0;
> >  
> >  	if (vep->base.port != 1 || vep->base.id >= RVIN_CSI_MAX)
> >  		return -EINVAL;
> > @@ -762,38 +777,48 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
> >  		return -ENOTCONN;
> >  	}
> >  
> > +	mutex_lock(&vin->group->lock);
> > +
> >  	if (vin->group->csi[vep->base.id].fwnode) {
> >  		vin_dbg(vin, "OF device %pOF already handled\n",
> >  			to_of_node(asd->match.fwnode));
> > -		return -ENOTCONN;
> > +		ret = -ENOTCONN;
> > +		goto out;
> >  	}
> >  
> >  	vin->group->csi[vep->base.id].fwnode = asd->match.fwnode;
> >  
> >  	vin_dbg(vin, "Add group OF device %pOF to slot %u\n",
> >  		to_of_node(asd->match.fwnode), vep->base.id);
> > +out:
> > +	mutex_unlock(&vin->group->lock);
> 
> I think you could unlock before you print the debug... But perhaps
> that's not a critical path.

It could be done, but then the error path would be more complex. I'm 
open to change this at your leisure.

> 
> 
> 
> >  
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
> >  {
> > -	unsigned int count = 0;
> > +	unsigned int count = 0, vin_mask = 0;
> 
> Shouldn't vin_mask have it's own line?

It could, I'm trying to keep the style of the rest of the file. I'm open 
to change this.

> 
> >  	unsigned int i;
> >  	int ret;
> >  
> >  	mutex_lock(&vin->group->lock);
> >  
> >  	/* If not all VIN's are registered don't register the notifier. */
> > -	for (i = 0; i < RCAR_VIN_NUM; i++)
> > -		if (vin->group->vin[i])
> > +	for (i = 0; i < RCAR_VIN_NUM; i++) {
> > +		if (vin->group->vin[i]) {
> >  			count++;
> > +			vin_mask |= BIT(i);
> > +		}
> > +	}
> >  
> >  	if (vin->group->count != count) {
> >  		mutex_unlock(&vin->group->lock);
> >  		return 0;
> >  	}
> >  
> > +	mutex_unlock(&vin->group->lock);
> > +
> >  	v4l2_async_notifier_init(&vin->group->notifier);
> >  
> >  	/*
> > @@ -802,21 +827,17 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
> >  	 * will only be registered once with the group notifier.
> >  	 */
> >  	for (i = 0; i < RCAR_VIN_NUM; i++) {
> > -		if (!vin->group->vin[i])
> > +		if (!(vin_mask & BIT(i)))
> >  			continue;
> >  
> >  		ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
> >  				vin->group->vin[i]->dev, &vin->group->notifier,
> >  				sizeof(struct v4l2_async_subdev), 1,
> >  				rvin_mc_parse_of_endpoint);
> > -		if (ret) {
> > -			mutex_unlock(&vin->group->lock);
> > +		if (ret)
> >  			return ret;
> > -		}
> >  	}
> >  
> > -	mutex_unlock(&vin->group->lock);
> > -
> >  	if (list_empty(&vin->group->notifier.asd_list))
> >  		return 0;
> >  
> > 
> 
> 
> -- 
> Regards
> --
> Kieran

-- 
Regards,
Niklas Söderlund
