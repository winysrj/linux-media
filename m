Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36720 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728054AbeHCOag (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 10:30:36 -0400
Date: Fri, 3 Aug 2018 15:34:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCHv5 01/12] media: add 'index' to struct media_v2_pad
Message-ID: <20180803123426.7tmsibfnpv6jdbth@valkosipuli.retiisi.org.uk>
References: <20180629114331.7617-1-hverkuil@xs4all.nl>
 <4833769.fujQdFkPkF@avalon>
 <360b9ee9-8e29-1c34-0887-182f5c91be38@xs4all.nl>
 <2727885.HQxqLs6WZl@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2727885.HQxqLs6WZl@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Jul 11, 2018 at 02:33:47PM +0300, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday, 9 July 2018 16:40:51 EEST Hans Verkuil wrote:
> > On 09/07/18 14:55, Laurent Pinchart wrote:
> > > On Friday, 29 June 2018 14:43:20 EEST Hans Verkuil wrote:
> > >> From: Hans Verkuil <hansverk@cisco.com>
> > >> 
> > >> The v2 pad structure never exposed the pad index, which made it
> > >> impossible
> > >> to call the MEDIA_IOC_SETUP_LINK ioctl, which needs that information.
> > >> 
> > >> It is really trivial to just expose this information, so implement this.
> > >> 
> > >> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> > >> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >> ---
> > >> 
> > >>  drivers/media/media-device.c |  1 +
> > >>  include/uapi/linux/media.h   | 12 +++++++++++-
> > >>  2 files changed, 12 insertions(+), 1 deletion(-)
> > >> 
> > >> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > >> index 47bb2254fbfd..047d38372a27 100644
> > >> --- a/drivers/media/media-device.c
> > >> +++ b/drivers/media/media-device.c
> > >> @@ -331,6 +331,7 @@ static long media_device_get_topology(struct
> > >> media_device *mdev, void *arg)
> > >>  		kpad.id = pad->graph_obj.id;
> > >>  		kpad.entity_id = pad->entity->graph_obj.id;
> > >>  		kpad.flags = pad->flags;
> > >> +		kpad.index = pad->index;
> > >> 
> > >>  		if (copy_to_user(upad, &kpad, sizeof(kpad)))
> > >>  			ret = -EFAULT;
> > >> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > >> index 86c7dcc9cba3..f6338bd57929 100644
> > >> --- a/include/uapi/linux/media.h
> > >> +++ b/include/uapi/linux/media.h
> > >> @@ -305,11 +305,21 @@ struct media_v2_interface {
> > >>  	};
> > >>  } __attribute__ ((packed));
> > >> 
> > >> +/*
> > >> + * Appeared in 4.19.0.
> > >> + *
> > >> + * The media_version argument comes from the media_version field in
> > >> + * struct media_device_info.
> > >> + */
> > >> +#define MEDIA_V2_PAD_HAS_INDEX(media_version) \
> > >> +	((media_version) >= ((4 << 16) | (19 << 8) | 0))
> > > 
> > > I agree that we need tn index field, but I don't think we need to care
> > > about backward compatibility. The lack of an index field makes it clear
> > > that the API has never been properly used, as it was impossible to do so.
> > 
> > We do need to care: there is no reason why a v4l2 application can't be used
> > on an older kernel. Most v4l2 applications copy the V4L2 headers to the
> > application (in fact, that's what v4l-utils does) and so they need to know
> > if a field is actually filled in by whatever kernel is used. In most cases
> > they can just check against 0, but that happens to be a valid index :-(
> > 
> > So this is really needed. Same for the flags field.
> 
> You're right. I was thinking we could detect this on the kernel side by 
> checking the ioctl argument size if we added the index field to the 
> media_v2_pad structure instead of replacing one of the reserved fields, but 
> media_v2_pad is not passed directly to the G_TOPOLOGY ioctl, so that won't 
> help.
> 
> I wonder whether we shouldn't just define
> 
> #define MEDIA_V2_IS_BROKEN(media_version) \
> 	((media_version) < ((4 << 16) | (19 << 8) | 0))
> 
> as in practice applications should really avoid the G_TOPOLOGY ioctl without 
> this patch series. Having multiple version-based macros to check for features 
> won't be very helpful, and could be counter-productive as applications might 
> incorrectly decide to still use the API to retrieve some information when they 
> should really avoid it.
> 
> And, while at it, should we use KERNEL_VERSION() instead of hardcoding it ?
> 
> #define MEDIA_V2_IS_BROKEN(media_version) \
> 	((media_version) < KERNEL_VERSION(4, 19, 0))
> 
> Still thinking out loud, the fact that we can't change the size of the 
> structures pointed to by media_v2_topology bothers me. We could add a version 
> field to media_v2_topology that would be set by applications to tell the 
> kernel which version of the API they expect. On the other hand, maybe we'll 
> just do a media_v3_topology when the need arises...

What you could to is to allocate another field for the new struct; we're
entirely free to put whatever we want there, and the kernel would simply
need to convert between the two. Not ideal though. Another option would be to
explicitly convey the struct size as for the IOCTL argument itself. Both
should probably be used sparingly.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
