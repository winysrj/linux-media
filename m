Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50366 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965029AbaKNPfk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 10:35:40 -0500
Date: Fri, 14 Nov 2014 17:35:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 03/11] videodev2.h: rename reserved2 to config_store
 in v4l2_buffer.
Message-ID: <20141114153505.GE8907@valkosipuli.retiisi.org.uk>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
 <1411310909-32825-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411310909-32825-4-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

One more comment...

On Sun, Sep 21, 2014 at 04:48:21PM +0200, Hans Verkuil wrote:
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 83ef28a..2ca44ed 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -672,6 +672,7 @@ struct v4l2_plane {
>   * @length:	size in bytes of the buffer (NOT its payload) for single-plane
>   *		buffers (when type != *_MPLANE); number of elements in the
>   *		planes array for multi-plane buffers
> + * @config_store: this buffer should use this configuration store
>   *
>   * Contains data exchanged by application and driver using one of the Streaming
>   * I/O methods.
> @@ -695,7 +696,7 @@ struct v4l2_buffer {
>  		__s32		fd;
>  	} m;
>  	__u32			length;
> -	__u32			reserved2;
> +	__u32			config_store;
>  	__u32			reserved;
>  };
>  

I would use __u16 instead since the value is 16-bit on the control
interface.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
