Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42797 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3DUQm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 12:42:59 -0400
Date: Sun, 21 Apr 2013 19:42:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] media: info leak in media_device_enum_entities()
Message-ID: <20130421164256.GM6638@mwanda>
References: <20130421111003.GD6171@elgon.mountain>
 <5173D2DC.4060200@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5173D2DC.4060200@bfs.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 21, 2013 at 01:51:56PM +0200, walter harms wrote:
> 
> 
> Am 21.04.2013 13:10, schrieb Dan Carpenter:
> > The last part of the "u_ent.name" buffer isn't cleared so it still has
> > uninitialized stack memory.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 99b80b6..1957c0d 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -102,9 +102,12 @@ static long media_device_enum_entities(struct media_device *mdev,
> >  		return -EINVAL;
> >  
> >  	u_ent.id = ent->id;
> > -	u_ent.name[0] = '\0';
> > -	if (ent->name)
> > -		strlcpy(u_ent.name, ent->name, sizeof(u_ent.name));
> > +	if (ent->name) {
> > +		strncpy(u_ent.name, ent->name, sizeof(u_ent.name));
> > +		u_ent.name[sizeof(u_ent.name) - 1] = '\0';
> > +	} else {
> > +		memset(u_ent.name, 0, sizeof(u_ent.name));
> > +	}
> 
> I would always memset()
> and then do strncpy() for sizeof(u_ent.name) - 1
> the rest is always zero.

Both ways are fine.  You'd still have to test for "if (ent->name)",
of course.  This way is a little faster because I do the test first.

Mauro, if you want I can redo it?

regards,
dan carpenter

