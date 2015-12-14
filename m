Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44497 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbLNUA5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 15:00:57 -0500
Date: Mon, 14 Dec 2015 18:00:52 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media] media-entity: protect object creation/removal using
 spin lock
Message-ID: <20151214180052.4262a0a8@recife.lan>
In-Reply-To: <20151214195053.GA15098@mwanda>
References: <20151214195053.GA15098@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Dec 2015 22:50:53 +0300
Dan Carpenter <dan.carpenter@oracle.com> escreveu:

> Hello Mauro Carvalho Chehab,
> 
> The patch f8fd4c61b5ae: "[media] media-entity: protect object
> creation/removal using spin lock" from Dec 9, 2015, leads to the
> following static checker warning:
> 
> 	drivers/media/media-entity.c:781 media_remove_intf_link()
> 	error: dereferencing freed memory 'link'
> 
> drivers/media/media-entity.c
>    777  void media_remove_intf_link(struct media_link *link)
>    778  {
>    779          spin_lock(&link->graph_obj.mdev->lock);
>    780          __media_remove_intf_link(link);
>    781          spin_unlock(&link->graph_obj.mdev->lock);

Thanks for pointing it!

> 
> Do we need this unlock any more? 

Yes.

> Haven't we freed the lock on the previous line?

No. The lock is at the media_device struct, with is not freed here.

What we actually need is to cache mdev:

	struct media_device *mdev = link->graph_obj.mdev;

	spin_lock(&mdev->lock)
	__media_remove_intf_link(link);
	spin_unlock(&mdev->lock)


Probably the same thing is needed on other similar logic.

I guess gcc optimizer actually does the right thing, but we should
fix it to remove the static analyzer warnings.

Regards,
Mauro

> 
>    782  }
> 
> regards,
> dan carpenter
