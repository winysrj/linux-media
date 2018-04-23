Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60498 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754994AbeDWNcw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:32:52 -0400
Date: Mon, 23 Apr 2018 10:32:43 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 02/29] uapi/linux/media.h: add request API
Message-ID: <20180423103243.23815991@vento.lan>
In-Reply-To: <c667b621-8cca-c15f-cbd6-34fb92243d55@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-3-hverkuil@xs4all.nl>
        <20180410063856.32e44ce9@vento.lan>
        <20180410110016.p7dabvuzxazggytn@valkosipuli.retiisi.org.uk>
        <c667b621-8cca-c15f-cbd6-34fb92243d55@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Apr 2018 13:41:31 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 04/10/2018 01:00 PM, Sakari Ailus wrote:
> > On Tue, Apr 10, 2018 at 06:38:56AM -0300, Mauro Carvalho Chehab wrote:  
> >> Em Mon,  9 Apr 2018 16:19:59 +0200
> >> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>  
> >>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>
> >>> Define the public request API.
> >>>
> >>> This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
> >>> and two ioctls that operate on a request in order to queue the
> >>> contents of the request to the driver and to re-initialize the
> >>> request.
> >>>
> >>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>> ---
> >>>  include/uapi/linux/media.h | 8 ++++++++
> >>>  1 file changed, 8 insertions(+)
> >>>
> >>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> >>> index c7e9a5cba24e..f8769e74f847 100644
> >>> --- a/include/uapi/linux/media.h
> >>> +++ b/include/uapi/linux/media.h
> >>> @@ -342,11 +342,19 @@ struct media_v2_topology {
> >>>  
> >>>  /* ioctls */
> >>>  
> >>> +struct __attribute__ ((packed)) media_request_alloc {
> >>> +	__s32 fd;
> >>> +};
> >>> +
> >>>  #define MEDIA_IOC_DEVICE_INFO	_IOWR('|', 0x00, struct media_device_info)
> >>>  #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
> >>>  #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
> >>>  #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
> >>>  #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
> >>> +#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, struct media_request_alloc)
> >>> +  
> >>
> >> Why use a struct here? Just declare it as:
> >>
> >> 	#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, int)  
> > 
> > I'd say it's easier to extend it if it's a struct.

That's not true. Assuming that you declare it as:

 	#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, int)  

If you ever need a struct there, let's say:

struct media_request_alloc {
	int request;
	int new_field;
};

#define MEDIA_IOC_REQUEST_ALLOC_old _IOWR('|', 0x05, int)  
#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, struct media_request_alloc)

And add both MEDIA_IOC_REQUEST_ALLOC_old and MEDIA_IOC_REQUEST_ALLOC
to the ioctl handling logic, where the handler for
MEDIA_IOC_REQUEST_ALLOC_old being something like:

	switch (cmd) {
	...
	case MEDIA_IOC_REQUEST_ALLOC_old:
		struct media_request_alloc arg = {};

		arg.request = parg;

and calling the same routine as MEDIA_IOC_REQUEST_ALLOC would
call, passing &arg as its input.

One advantage of not passing an struct is that there's no
need to call copy_to_user(), making its handler faster.

> > All other IOCTLs also
> > have a struct as an argument. 

That is not true as well, if you consider V4L2 API (or the media
API as a hole). There are several ioctls there that takes just
an integer argument:

include/uapi/linux/videodev2.h:#define VIDIOC_OVERLAY		 _IOW('V', 14, int)
include/uapi/linux/videodev2.h:#define VIDIOC_STREAMON		 _IOW('V', 18, int)
include/uapi/linux/videodev2.h:#define VIDIOC_STREAMOFF	 _IOW('V', 19, int)
include/uapi/linux/videodev2.h:#define VIDIOC_G_INPUT		 _IOR('V', 38, int)
include/uapi/linux/videodev2.h:#define VIDIOC_S_INPUT		_IOWR('V', 39, int)
include/uapi/linux/videodev2.h:#define VIDIOC_G_OUTPUT		 _IOR('V', 46, int)
include/uapi/linux/videodev2.h:#define VIDIOC_S_OUTPUT		_IOWR('V', 47, int)
include/uapi/linux/dvb/frontend.h:#define FE_ENABLE_HIGH_LNB_VOLTAGE _IO('o', 68)  /* int */
include/uapi/linux/dvb/frontend.h:#define FE_SET_FRONTEND_TUNE_MODE  _IO('o', 81) /* unsigned int */
include/uapi/linux/dvb/frontend.h:#define FE_DISHNETWORK_SEND_LEGACY_CMD _IO('o', 80) /* unsigned int */
include/uapi/linux/lirc.h:#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, __u32)
include/uapi/linux/lirc.h:#define LIRC_GET_SEND_MODE             _IOR('i', 0x00000001, __u32)
include/uapi/linux/lirc.h:#define LIRC_GET_REC_MODE              _IOR('i', 0x00000002, __u32)
include/uapi/linux/lirc.h:#define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, __u32)
include/uapi/linux/lirc.h:#define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, __u32)
include/uapi/linux/lirc.h:#define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, __u32)
include/uapi/linux/lirc.h:#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
include/uapi/linux/lirc.h:#define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, __u32)
include/uapi/linux/lirc.h:#define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, __u32)
include/uapi/linux/lirc.h:#define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, __u32)
include/uapi/linux/lirc.h:#define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, __u32)
include/uapi/linux/lirc.h:#define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, __u32)
include/uapi/linux/lirc.h:#define LIRC_SET_TRANSMITTER_MASK      _IOW('i', 0x00000017, __u32)
include/uapi/linux/lirc.h:#define LIRC_SET_REC_TIMEOUT           _IOW('i', 0x00000018, __u32)
include/uapi/linux/lirc.h:#define LIRC_SET_REC_TIMEOUT_REPORTS   _IOW('i', 0x00000019, __u32)
include/uapi/linux/lirc.h:#define LIRC_SET_MEASURE_CARRIER_MODE _IOW('i', 0x0000001d, __u32)
include/uapi/linux/lirc.h:#define LIRC_SET_REC_CARRIER_RANGE     _IOW('i', 0x0000001f, __u32)
include/uapi/linux/lirc.h:#define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
include/uapi/linux/lirc.h:#define LIRC_GET_REC_TIMEOUT         _IOR('i', 0x00000024, __u32)
include/uapi/linux/dvb/frontend.h:#define FE_READ_BER		   _IOR('o', 70, __u32)
include/uapi/linux/dvb/frontend.h:#define FE_READ_SIGNAL_STRENGTH    _IOR('o', 71, __u16)
include/uapi/linux/dvb/frontend.h:#define FE_READ_SNR		   _IOR('o', 72, __u16)
include/uapi/linux/dvb/frontend.h:#define FE_READ_UNCORRECTED_BLOCKS _IOR('o', 73, __u32)

Btw, at the beginning, I found ugly the way lirc API were designed (there,
*all* ioctls pass/receive integers), but the more I looked into it and
started documenting it, the more I liked!

It is a way easier to understand what each ioctl does, as just one thing
is affected by each ioctl. Btw, sysfs follows the same logic: there, you
really need a very strong reason why not just pass a single value to each
sysfs node.

That makes the design better, and usually avoid the need of changes, as,
if you need something else, just add a new sysfs node, or a new ioctl
with would take just one integer.

> > As a struct member, the parameter (fd) also
> > has a name; this is a plus.  

Huh? Why is it a plus?

> 
> While I do not have a very strong opinion on this, I do agree with Sakari here.

The thing is: adding a struct there is overdesign. If are there any
real reason why to have it as a struct (e. g. if we know/foresee any other
parameter to be needed there), then 

> 
> Regards,
> 
> 	Hans
> 
> >   
> >>  
> >>> +#define MEDIA_REQUEST_IOC_QUEUE		_IO('|',  0x80)
> >>> +#define MEDIA_REQUEST_IOC_REINIT	_IO('|',  0x81)
> >>>  
> >>>  #if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
> >>>    
> >>
> >> Thanks,
> >> Mauro  
> >   
> 



Thanks,
Mauro
