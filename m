Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37582 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaIXXO3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 19:14:29 -0400
Date: Wed, 24 Sep 2014 20:14:23 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH 09/18] [media] cx88: remove return after BUG()
Message-ID: <20140924201423.4351be8e@recife.lan>
In-Reply-To: <54234664.3030500@iki.fi>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
	<9558d5ca24c16761b267ac700661aeaa501f1b1e.1411597610.git.mchehab@osg.samsung.com>
	<54234664.3030500@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 25 Sep 2014 01:32:04 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Are these even cases you should use BUG()? How about WARN()...

Those are all very bad driver's behavior. Fixing it would
likely require several fixups, as if one of those got hit,
something evil happened.

Anyway, Hans is converting cx88 to VB2, and likely removing
most of this code, if not all.

Still, for now, it is better to have fewer sparse/spatch errors
to allow a better detection on new errors introduced on new
patches.

Regards,
Mauro

> 
> Antti
> 
> On 09/25/2014 01:27 AM, Mauro Carvalho Chehab wrote:
> > As reported by smatch:
> >
> > drivers/media/pci/cx88/cx88-video.c:699 get_queue() info: ignoring unreachable code.
> > drivers/media/pci/cx88/cx88-video.c:714 get_resource() info: ignoring unreachable code.
> > drivers/media/pci/cx88/cx88-video.c:815 video_read() info: ignoring unreachable code.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
> > index ed8cb9037b6f..ce27e6d4f16e 100644
> > --- a/drivers/media/pci/cx88/cx88-video.c
> > +++ b/drivers/media/pci/cx88/cx88-video.c
> > @@ -696,7 +696,6 @@ static struct videobuf_queue *get_queue(struct file *file)
> >   		return &fh->vbiq;
> >   	default:
> >   		BUG();
> > -		return NULL;
> >   	}
> >   }
> >
> > @@ -711,7 +710,6 @@ static int get_resource(struct file *file)
> >   		return RESOURCE_VBI;
> >   	default:
> >   		BUG();
> > -		return 0;
> >   	}
> >   }
> >
> > @@ -812,7 +810,6 @@ video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
> >   					    file->f_flags & O_NONBLOCK);
> >   	default:
> >   		BUG();
> > -		return 0;
> >   	}
> >   }
> >
> >
> 
