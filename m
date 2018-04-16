Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48544 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752786AbeDPSKI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 14:10:08 -0400
Date: Mon, 16 Apr 2018 15:09:56 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCHv2 6/9] media: add 'index' to struct media_v2_pad
Message-ID: <20180416150956.22b5b021@vento.lan>
In-Reply-To: <20180416150335.66f6ab12@vento.lan>
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
        <20180416132121.46205-7-hverkuil@xs4all.nl>
        <20180416150335.66f6ab12@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Apr 2018 15:03:35 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Mon, 16 Apr 2018 15:21:18 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > From: Hans Verkuil <hansverk@cisco.com>
> > 
> > The v2 pad structure never exposed the pad index, which made it impossible
> > to call the MEDIA_IOC_SETUP_LINK ioctl, which needs that information.
> > 
> > It is really trivial to just expose this information, so implement this.  
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Err... I looked on it too fast... See my comments below.

The same applies to patch 8/9.

> > 
> > Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> > ---
> >  drivers/media/media-device.c | 1 +
> >  include/uapi/linux/media.h   | 7 ++++++-
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index dca1e5a3e0f9..73ffea3e81c9 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -331,6 +331,7 @@ static long media_device_get_topology(struct media_device *mdev,
> >  		kpad.id = pad->graph_obj.id;
> >  		kpad.entity_id = pad->entity->graph_obj.id;
> >  		kpad.flags = pad->flags;
> > +		kpad.index = pad->index;
> >  
> >  		if (copy_to_user(upad, &kpad, sizeof(kpad)))
> >  			ret = -EFAULT;
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index ac08acffdb65..15f7f432f808 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -310,11 +310,16 @@ struct media_v2_interface {
> >  	};
> >  } __attribute__ ((packed));
> >  
> > +/* Appeared in 4.18.0 */
> > +#define MEDIA_V2_PAD_HAS_INDEX(media_version) \
> > +	((media_version) >= 0x00041200)
> > +

I don't like this, for a couple of reasons:

1) it has a magic number on it, with is actually a parsed
   version of LINUX_VERSION() macro;

2) it sounds really weird to ship a header file with a new
   kernel version meant to provide backward compatibility with
   older versions;

3) this isn't any different than:

	#define MEDIA_V2_PAD_HAS_INDEX -1

I think we need to think a little bit more about that.


> >  struct media_v2_pad {
> >  	__u32 id;
> >  	__u32 entity_id;
> >  	__u32 flags;
> > -	__u32 reserved[5];
> > +	__u32 index;
> > +	__u32 reserved[4];
> >  } __attribute__ ((packed));
> >  
> >  struct media_v2_link {  
> 
> 
> 
> Thanks,
> Mauro



Thanks,
Mauro
