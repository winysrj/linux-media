Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:41503 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbeCCPty (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2018 10:49:54 -0500
Received: by mail-lf0-f41.google.com with SMTP id m69so17402137lfe.8
        for <linux-media@vger.kernel.org>; Sat, 03 Mar 2018 07:49:53 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sat, 3 Mar 2018 16:49:51 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v11 28/32] rcar-vin: add link notify for Gen3
Message-ID: <20180303154951.GI12470@bigcity.dyn.berto.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
 <20180302015751.25596-29-niklas.soderlund+renesas@ragnatech.se>
 <5042630.eZtUuC7CUs@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5042630.eZtUuC7CUs@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

On 2018-03-02 14:00:19 +0200, Laurent Pinchart wrote:

[snip]

> > +
> > +	/* If any entity is in use don't allow link changes. */
> > +	media_device_for_each_entity(entity, &group->mdev)
> > +		if (entity->use_count)
> > +			return -EBUSY;
> 
> This means that you disallow link setup when any video node is open. According 
> to the comment above, isn't it stream_count that you want to check ? If so the 
> MC core does it for you (unless you create links with the MEDIA_LNK_FL_DYNAMIC 
> flag set), see __media_entity_setup_link().

You are correct that the comment and code don't align. I rather update 
the comment and keep denying link enablement if any video devices are 
open. I'm sure this is not a real issue but this group concept feels a 
bit fragile, so better safe then sorry. Or do you feel there is a 
benefit for the user to be able to change the graph with video nodes 
open? We can always loosen the constraint later if it becomes a problem 
but introducing it if we would need it could be considered a regression?


> 
> > +	mutex_lock(&group->lock);
> > +
> > +	/*
> > +	 * Figure out which VIN the link concern's and lookup
> > +	 * which master VIN controls the routes for that VIN.
> > +	 */
> 
> Can't you simply use a container_of to cast from vdev to vin ?

Thank you for this, made the code much more readable!

> 
> > +	vdev = media_entity_to_video_device(link->sink->entity);
> > +	for (i = 0; i < RCAR_VIN_NUM; i++) {
> > +		if (group->vin[i] && &group->vin[i]->vdev == vdev) {
> > +			vin = group->vin[i];
> > +			master_id = rvin_group_id_to_master(vin->id);
> > +			break;
> > +		}
> > +	}

[snip]

-- 
Regards,
Niklas Söderlund
