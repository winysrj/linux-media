Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45714 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbeHNLcq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:32:46 -0400
Date: Tue, 14 Aug 2018 05:46:32 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 02/34] uapi/linux/media.h: add request API
Message-ID: <20180814054632.14b5c978@coco.lan>
In-Reply-To: <5b3ac277-a191-0729-5571-8d028ea14e06@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-3-hverkuil@xs4all.nl>
        <20180809145358.2278c795@coco.lan>
        <5b3ac277-a191-0729-5571-8d028ea14e06@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 10 Aug 2018 09:21:59 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/09/2018 07:53 PM, Mauro Carvalho Chehab wrote:
> > Em Sat,  4 Aug 2018 14:44:54 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Define the public request API.
> >>
> >> This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
> >> and two ioctls that operate on a request in order to queue the
> >> contents of the request to the driver and to re-initialize the
> >> request.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> ---
> >>  include/uapi/linux/media.h | 12 ++++++++++++
> >>  1 file changed, 12 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> >> index 36f76e777ef9..cf77f00a0f2d 100644
> >> --- a/include/uapi/linux/media.h
> >> +++ b/include/uapi/linux/media.h
> >> @@ -364,11 +364,23 @@ struct media_v2_topology {
> >>  
> >>  /* ioctls */
> >>  
> >> +struct __attribute__ ((packed)) media_request_alloc {
> >> +	__s32 fd;
> >> +};
> >> +
> >>  #define MEDIA_IOC_DEVICE_INFO	_IOWR('|', 0x00, struct media_device_info)
> >>  #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
> >>  #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
> >>  #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
> >>  #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
> >> +#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, struct media_request_alloc)  

The definition here is wrong... the fd field is not R/W, it is just R, as no
fields inside this struct should be filled by userspace.
The right declaration for it would be:

	#define MEDIA_IOC_REQUEST_ALLOC	_IOR('|', 0x05, struct media_request_alloc)

I do have a strong opinion here: ioctls that just return stuff should use _IOR.

> > 
> > Same comment as in patch 1: keep it simpler: just pass a s32 * as the
> > argument for this ioctl.  
> 
> Same comment as in patch 1: I have no strong opinion, but I want the input from others
> as well.

I'm transcribing a comment you wrote on patch 01/34 here, for the sake of
keeping everything on a single thread:

> The first version just had a s32 argument, not a struct. The main reason for
> going back to a struct was indeed to make it easier to add new fields in the
> future. I don't foresee any, but then, you never do.

First of all, if we declare it as it should be, e. g.: 

#define MEDIA_IOC_REQUEST_ALLOC	_IOR('|', 0x05, int) 

If later find the need for some struct:

	struct media_request_alloc {
		__s32 fd;
		__s32 foo;
	} __packed;

Assuming that "foo" is a write argument, we'll then have:

	#define MEDIA_IOC_REQUEST_ALLOC		_IOR('|', 0x05, int) 
	#define MEDIA_IOC_REQUEST_ALLOC_V2	_IOWR('|', 0x05, struct media_request_alloc)  

The size of the ioctl will also be different, and also the direction.
So, the magic number will be different.

The Kernel can easily handle it on both ways, and, as 
MEDIA_IOC_REQUEST_ALLOC has only an integer output parameter, 
there's no need for compat32 or to keep any old struct.
The MEDIA_IOC_REQUEST_ALLOC code handler will still be very simple,
and backward compatible comes for free.

If, on the other hand, we declare it as:
	#define MEDIA_IOC_REQUEST_ALLOC	_IOR('|', 0x05, struct media_request_alloc_old)

And then we change it to:
	#define MEDIA_IOC_REQUEST_ALLOC	_IORW('|', 0x05, struct media_request_alloc_new)

Keeping backward compatible will be painful, and will require efforts for
no gain.

Thanks,
Mauro
