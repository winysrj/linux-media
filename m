Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55610 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933567AbdLRQtB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 11:49:01 -0500
Date: Mon, 18 Dec 2017 14:48:52 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCH 05/24] media: v4l2-dev: convert VFL_TYPE_* into an enum
Message-ID: <20171218144852.6ed9b816@vento.lan>
In-Reply-To: <20171010204704.GE6361@starlite>
References: <cover.1507544011.git.mchehab@s-opensource.com>
        <ddbc94767e3aebb52d4f8bf96611136dda2e2c12.1507544011.git.mchehab@s-opensource.com>
        <20171010204704.GE6361@starlite>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Oct 2017 21:47:04 +0100
Andrey Utkin <andrey_utkin@fastmail.com> escreveu:

> On Mon, Oct 09, 2017 at 07:19:11AM -0300, Mauro Carvalho Chehab wrote:
> > Using enums makes easier to document, as it can use kernel-doc
> > markups. It also allows cross-referencing, with increases the
> > kAPI readability.
> >   
> 
> 
> All changes look legit.
> 
> But I'd expect cx88_querycap() return type change and such to be in
> separate commit.

It should be together, as the switch() now would generate a warning,
because some enum values aren't listed. On such case, it has to
return an error.

I added an explanation at the commit message.

> 
> > diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
> > index e3101f04941c..0e0952e60795 100644
> > --- a/drivers/media/pci/cx88/cx88-blackbird.c
> > +++ b/drivers/media/pci/cx88/cx88-blackbird.c
> > @@ -805,8 +805,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
> >  
> >  	strcpy(cap->driver, "cx88_blackbird");
> >  	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
> > -	cx88_querycap(file, core, cap);
> > -	return 0;
> > +	return cx88_querycap(file, core, cap);
> >  }
> >  
> >  static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
> > diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
> > index 7d25ecd4404b..9be682cdb644 100644
> > --- a/drivers/media/pci/cx88/cx88-video.c
> > +++ b/drivers/media/pci/cx88/cx88-video.c
> > @@ -806,8 +806,8 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> >  	return 0;
> >  }
> >  
> > -void cx88_querycap(struct file *file, struct cx88_core *core,
> > -		   struct v4l2_capability *cap)
> > +int cx88_querycap(struct file *file, struct cx88_core *core,
> > +		  struct v4l2_capability *cap)
> >  {
> >  	struct video_device *vdev = video_devdata(file);
> >    



Thanks,
Mauro
