Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60775 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbbLHXK6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2015 18:10:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
Subject: Re: [PATCH] v4l: Fix dma buf single plane compat handling
Date: Wed, 09 Dec 2015 01:11:12 +0200
Message-ID: <1496823.l1L2kFkYyq@avalon>
In-Reply-To: <20151208152915.GH17128@valkosipuli.retiisi.org.uk>
References: <1449477939-5658-1-git-send-email-laurent.pinchart@ideasonboard.com> <20151208152915.GH17128@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 08 December 2015 17:29:16 Sakari Ailus wrote:
> On Mon, Dec 07, 2015 at 10:45:39AM +0200, Laurent Pinchart wrote:
> > From: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
> > 
> > Buffer length is needed for single plane as well, otherwise
> > is uninitialized and behaviour is undetermined.
> 
> How about:
> 
> The v4l2_buffer length field must be passed as well from user to kernel and
> back, otherwise uninitialised values will be used.
> 
> > Signed-off-by: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Shouldn't this be submitted to stable as well?

I'll CC stable.

> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index
> > 8fd84a67478a..b0faa1f7e3a9 100644
> > --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > @@ -482,8 +482,10 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp,
> > struct v4l2_buffer32 __user> 
> >  				return -EFAULT;
> >  			
> >  			break;
> >  		
> >  		case V4L2_MEMORY_DMABUF:
> > -			if (get_user(kp->m.fd, &up->m.fd))
> > +			if (get_user(kp->m.fd, &up->m.fd) ||
> > +			    get_user(kp->length, &up->length))
> > 
> >  				return -EFAULT;
> > 
> > +
> > 
> >  			break;
> >  		
> >  		}
> >  	
> >  	}
> > 
> > @@ -550,7 +552,8 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp,
> > struct v4l2_buffer32 __user> 
> >  				return -EFAULT;
> >  			
> >  			break;
> >  		
> >  		case V4L2_MEMORY_DMABUF:
> > -			if (put_user(kp->m.fd, &up->m.fd))
> > +			if (put_user(kp->m.fd, &up->m.fd) ||
> > +			    put_user(kp->length, &up->length))
> > 
> >  				return -EFAULT;
> >  			
> >  			break;
> >  		
> >  		}

-- 
Regards,

Laurent Pinchart

