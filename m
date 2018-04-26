Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34491 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932150AbeDZPUI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 11:20:08 -0400
Received: by mail-lf0-f65.google.com with SMTP id h4-v6so4544054lfc.1
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 08:20:07 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 26 Apr 2018 17:20:05 +0200
To: Simon Horman <horms@verge.net.au>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-vin: fix null pointer dereference in
 rvin_group_get()
Message-ID: <20180426152005.GE3315@bigcity.dyn.berto.se>
References: <20180424234506.22630-1-niklas.soderlund+renesas@ragnatech.se>
 <20180425071851.tcytzfkpofsbkxgm@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180425071851.tcytzfkpofsbkxgm@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

Thanks for your feedback.

On 2018-04-25 09:18:51 +0200, Simon Horman wrote:
> On Wed, Apr 25, 2018 at 01:45:06AM +0200, Niklas Söderlund wrote:
> > Store the group pointer before disassociating the VIN from the group.
> > 
> > Fixes: 3bb4c3bc85bf77a7 ("media: rcar-vin: add group allocator functions")
> > Reported-by: Colin Ian King <colin.king@canonical.com>
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > index 7bc2774a11232362..d3072e166a1ca24f 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -338,19 +338,21 @@ static int rvin_group_get(struct rvin_dev *vin)
> >  
> >  static void rvin_group_put(struct rvin_dev *vin)
> >  {
> > -	mutex_lock(&vin->group->lock);
> > +	struct rvin_group *group = vin->group;
> > +
> > +	mutex_lock(&group->lock);
> 
> Hi Niklas, its not clear to me why moving the lock is safe.
> Could you explain the locking scheme a little?

The lock here protects the members of the group struct and not any of 
the members of the vin struct. The intent of the rvin_group_put() 
function is:

1. Disassociate the vin struct from the group struct. This is done by 
   removing the pointer to the vin from the group->vin array and 
   removing the pointer from vin->group to the group struct. Here the 
   lock is needed to protect access to the group->vin array.

2. Decrease the refcount of the struct group and if we are the last one 
   out release the group.

The problem with the original code is that I first disassociate group 
from the vin 'vin->group = NULL' but still use the pointer stored in the 
vin struct when I try to disassociate the vin from the group 
'vin->group->vin[vin->id]'.

AFIK can tell the locking here is fine, the problem was that I pulled 
the rug from under my own feet in how I access the lock in order to not 
having to declare a variable to store the pointer in ;-)

Do this explanation help put you at ease?

> 
> >  
> >  	vin->group = NULL;
> >  	vin->v4l2_dev.mdev = NULL;
> >  
> > -	if (WARN_ON(vin->group->vin[vin->id] != vin))
> > +	if (WARN_ON(group->vin[vin->id] != vin))
> >  		goto out;
> >  
> > -	vin->group->vin[vin->id] = NULL;
> > +	group->vin[vin->id] = NULL;
> >  out:
> > -	mutex_unlock(&vin->group->lock);
> > +	mutex_unlock(&group->lock);
> >  
> > -	kref_put(&vin->group->refcount, rvin_group_release);
> > +	kref_put(&group->refcount, rvin_group_release);
> >  }
> >  
> >  /* -----------------------------------------------------------------------------
> > -- 
> > 2.17.0
> > 

-- 
Regards,
Niklas Söderlund
