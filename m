Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:16455 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab2HNLGO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 07:06:14 -0400
Date: Tue, 14 Aug 2012 14:05:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Gianluca Gennari <gennarone@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] em28xx: use after free in em28xx_v4l2_close()
Message-ID: <20120814110546.GD4559@mwanda>
References: <20120814065814.GB4791@elgon.mountain>
 <CALF0-+UU8dGBdihLgm==d0gCE4aHKdAbEVfe54U1LDjBHss8XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALF0-+UU8dGBdihLgm==d0gCE4aHKdAbEVfe54U1LDjBHss8XQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 14, 2012 at 07:50:12AM -0300, Ezequiel Garcia wrote:
> Hi Dan,
> 
> On Tue, Aug 14, 2012 at 3:58 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > We need to move the unlock before the kfree(dev);
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > Applies to linux-next.
> >
> > diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
> > index ecb23df..78d6ebd 100644
> > --- a/drivers/media/video/em28xx/em28xx-video.c
> > +++ b/drivers/media/video/em28xx/em28xx-video.c
> > @@ -2264,9 +2264,9 @@ static int em28xx_v4l2_close(struct file *filp)
> >                 if (dev->state & DEV_DISCONNECTED) {
> >                         em28xx_release_resources(dev);
> 
> Why not unlocking here?

I don't see a reason to prefer one over the other.

regards,
dan carpenter

> 
> >                         kfree(dev->alt_max_pkt_size);
> > +                       mutex_unlock(&dev->lock);
> >                         kfree(dev);
> >                         kfree(fh);
> > -                       mutex_unlock(&dev->lock);
> 
> Thanks,
> Ezequiel.
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
