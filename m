Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38086 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751774AbeDJLAS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 07:00:18 -0400
Date: Tue, 10 Apr 2018 14:00:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 02/29] uapi/linux/media.h: add request API
Message-ID: <20180410110016.p7dabvuzxazggytn@valkosipuli.retiisi.org.uk>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-3-hverkuil@xs4all.nl>
 <20180410063856.32e44ce9@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180410063856.32e44ce9@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 10, 2018 at 06:38:56AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon,  9 Apr 2018 16:19:59 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Define the public request API.
> > 
> > This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
> > and two ioctls that operate on a request in order to queue the
> > contents of the request to the driver and to re-initialize the
> > request.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  include/uapi/linux/media.h | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index c7e9a5cba24e..f8769e74f847 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -342,11 +342,19 @@ struct media_v2_topology {
> >  
> >  /* ioctls */
> >  
> > +struct __attribute__ ((packed)) media_request_alloc {
> > +	__s32 fd;
> > +};
> > +
> >  #define MEDIA_IOC_DEVICE_INFO	_IOWR('|', 0x00, struct media_device_info)
> >  #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
> >  #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
> >  #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
> >  #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
> > +#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, struct media_request_alloc)
> > +
> 
> Why use a struct here? Just declare it as:
> 
> 	#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, int)

I'd say it's easier to extend it if it's a struct. All other IOCTLs also
have a struct as an argument. As a struct member, the parameter (fd) also
has a name; this is a plus.

> 
> > +#define MEDIA_REQUEST_IOC_QUEUE		_IO('|',  0x80)
> > +#define MEDIA_REQUEST_IOC_REINIT	_IO('|',  0x81)
> >  
> >  #if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
> >  
> 
> Thanks,
> Mauro

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
