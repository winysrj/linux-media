Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56707 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753914AbaKOOTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 09:19:38 -0500
Date: Sat, 15 Nov 2014 16:18:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 06/11] videodev2.h: add new v4l2_ext_control flags
 field
Message-ID: <20141115141858.GG8907@valkosipuli.retiisi.org.uk>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
 <1411310909-32825-7-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411310909-32825-7-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, Sep 21, 2014 at 04:48:24PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Replace reserved2 by a flags field. This is used to tell whether
> setting a new store value is applied only once or every time that
> v4l2_ctrl_apply_store() is called for that store.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/uapi/linux/videodev2.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 2ca44ed..fa84070 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1282,7 +1282,7 @@ struct v4l2_control {
>  struct v4l2_ext_control {
>  	__u32 id;
>  	__u32 size;
> -	__u32 reserved2[1];
> +	__u32 flags;

16 bits, please. The pad number (for sub-devices) would need to be added
here as well, and that's 16 bits. A flag might be needed to tell it's valid,
too.

>  	union {
>  		__s32 value;
>  		__s64 value64;
> @@ -1294,6 +1294,10 @@ struct v4l2_ext_control {
>  	};
>  } __attribute__ ((packed));
>  
> +/* v4l2_ext_control flags */
> +#define V4L2_EXT_CTRL_FL_IGN_STORE_AFTER_USE	0x00000001
> +#define V4L2_EXT_CTRL_FL_IGN_STORE		0x00000002

Do we need both? Aren't these mutually exclusive, and you must have either
to be meaningful in the context of a store?

> +
>  struct v4l2_ext_controls {
>  	union {
>  		__u32 ctrl_class;

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
