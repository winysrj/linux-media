Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:59252 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaCKTma (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 15:42:30 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2A004G9EQTS700@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Mar 2014 15:42:29 -0400 (EDT)
Date: Tue, 11 Mar 2014 16:42:21 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 05/35] videodev2.h: add struct v4l2_query_ext_ctrl
 and VIDIOC_QUERY_EXT_CTRL.
Message-id: <20140311164221.13537163@samsung.com>
In-reply-to: <1392631070-41868-6-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
 <1392631070-41868-6-git-send-email-hverkuil@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 17 Feb 2014 10:57:20 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add a new struct and ioctl to extend the amount of information you can
> get for a control.
> 
> It gives back a unit string, the range is now a s64 type, and the matrix
> and element size can be reported through cols/rows/elem_size.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/uapi/linux/videodev2.h | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 4d7782a..858a6f3 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1272,6 +1272,35 @@ struct v4l2_queryctrl {
>  	__u32		     reserved[2];
>  };
>  
> +/*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
> +struct v4l2_query_ext_ctrl {
> +	__u32		     id;
> +	__u32		     type;
> +	char		     name[32];
> +	char		     unit[32];
> +	union {
> +		__s64 val;
> +		__u32 reserved[4];

Why to reserve 16 bytes here? for anything bigger than 64
bits, we could use a pointer.

Same applies to the other unions.

> +	} min;
> +	union {
> +		__s64 val;
> +		__u32 reserved[4];
> +	} max;
> +	union {
> +		__u64 val;
> +		__u32 reserved[4];
> +	} step;
> +	union {
> +		__s64 val;
> +		__u32 reserved[4];
> +	} def;

Please call it default. It is ok to simplify names inside a driver,
but better to not do it at the API.

> +	__u32                flags;

> +	__u32                cols;
> +	__u32                rows;
> +	__u32                elem_size;

The three above seem to be too specific for an array.

I would put those on a separate struct and add here an union,
like:

	union {
		struct v4l2_array arr;
		__u32 reserved[8];
	}

> +	__u32		     reserved[17];

This also seems too much. Why 17?

> +};

> +
>  /*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
>  struct v4l2_querymenu {
>  	__u32		id;
> @@ -1965,6 +1994,8 @@ struct v4l2_create_buffers {
>     Never use these in applications! */
>  #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
>  
> +#define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
> +
>  /* Reminder: when adding new ioctls please add support for them to
>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
>  


-- 

Regards,
Mauro
