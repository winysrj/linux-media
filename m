Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:61653 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbaCKXfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 19:35:41 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2A00LHWPJDTJ30@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Mar 2014 19:35:37 -0400 (EDT)
Date: Tue, 11 Mar 2014 20:35:30 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 05/35] videodev2.h: add struct v4l2_query_ext_ctrl
 and VIDIOC_QUERY_EXT_CTRL.
Message-id: <20140311203530.5955a09c@samsung.com>
In-reply-to: <531F7229.9070306@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
 <1392631070-41868-6-git-send-email-hverkuil@xs4all.nl>
 <20140311164221.13537163@samsung.com> <531F7229.9070306@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Mar 2014 21:29:29 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 03/11/2014 08:42 PM, Mauro Carvalho Chehab wrote:
> > Em Mon, 17 Feb 2014 10:57:20 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Add a new struct and ioctl to extend the amount of information you can
> >> get for a control.
> >>
> >> It gives back a unit string, the range is now a s64 type, and the matrix
> >> and element size can be reported through cols/rows/elem_size.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  include/uapi/linux/videodev2.h | 31 +++++++++++++++++++++++++++++++
> >>  1 file changed, 31 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> >> index 4d7782a..858a6f3 100644
> >> --- a/include/uapi/linux/videodev2.h
> >> +++ b/include/uapi/linux/videodev2.h
> >> @@ -1272,6 +1272,35 @@ struct v4l2_queryctrl {
> >>  	__u32		     reserved[2];
> >>  };
> >>  
> >> +/*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
> >> +struct v4l2_query_ext_ctrl {
> >> +	__u32		     id;
> >> +	__u32		     type;
> >> +	char		     name[32];
> >> +	char		     unit[32];
> >> +	union {
> >> +		__s64 val;
> >> +		__u32 reserved[4];
> > 
> > Why to reserve 16 bytes here? for anything bigger than 64
> > bits, we could use a pointer.
> > 
> > Same applies to the other unions.
> 
> The idea was to allow space for min/max/step/def values for compound types
> if applicable. But that may have been overengineering.

It seems overengineering for me ;)

> 
> > 
> >> +	} min;
> >> +	union {
> >> +		__s64 val;
> >> +		__u32 reserved[4];
> >> +	} max;
> >> +	union {
> >> +		__u64 val;
> >> +		__u32 reserved[4];
> >> +	} step;
> >> +	union {
> >> +		__s64 val;
> >> +		__u32 reserved[4];
> >> +	} def;
> > 
> > Please call it default. It is ok to simplify names inside a driver,
> > but better to not do it at the API.
> 
> default_value, then. 'default' is a keyword. I should probably rename min and max
> to minimum and maximum to stay in sync with v4l2_queryctrl.

OK.

> > 
> >> +	__u32                flags;
> > 
> >> +	__u32                cols;
> >> +	__u32                rows;
> >> +	__u32                elem_size;
> > 
> > The three above seem to be too specific for an array.
> > 
> > I would put those on a separate struct and add here an union,
> > like:
> > 
> > 	union {
> > 		struct v4l2_array arr;
> > 		__u32 reserved[8];
> > 	}
> 
> I have to sleep on this. I'm not sure this helps in any way.

Well, for today's needs this may not bring any difference, but it may
help if we need to add something else there.

Also, it helps to make clear, at the documentation which parts of the
struct will be filled every time, and with part is array-specific.

> 
> > 
> >> +	__u32		     reserved[17];
> > 
> > This also seems too much. Why 17?
> 
> It aligned the struct up to some nice number. Also, experience tells me that
> whenever I limit the number of reserved fields it bites me later.
> 
> > 
> >> +};
> > 
> >> +
> >>  /*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
> >>  struct v4l2_querymenu {
> >>  	__u32		id;
> >> @@ -1965,6 +1994,8 @@ struct v4l2_create_buffers {
> >>     Never use these in applications! */
> >>  #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
> >>  
> >> +#define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
> >> +
> >>  /* Reminder: when adding new ioctls please add support for them to
> >>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
> >>  
> > 
> > 
> 
> Regards,
> 
> 	Hans


-- 

Regards,
Mauro
