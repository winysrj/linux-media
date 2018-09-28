Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:39765 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726665AbeI1UYP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 16:24:15 -0400
Subject: Re: [PATCH 2/5] v4l: controls: Add support for exponential bases,
 prefixes and units
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: tfiga@chromium.org, bingbu.cao@intel.com, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com, tian.shu.qiu@intel.com,
        ricardo.ribalda@gmail.com, grundler@chromium.org,
        ping-chung.chen@intel.com, andy.yeh@intel.com, jim.lai@intel.com,
        helmut.grohne@intenta.de, laurent.pinchart@ideasonboard.com,
        snawrocki@kernel.org
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
 <20180925101434.20327-3-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ed5a453b-41d3-6ab5-2bc2-8cab309ac749@xs4all.nl>
Date: Fri, 28 Sep 2018 16:00:17 +0200
MIME-Version: 1.0
In-Reply-To: <20180925101434.20327-3-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/25/2018 12:14 PM, Sakari Ailus wrote:
> Add support for exponential bases, prefixes as well as units for V4L2
> controls. This makes it possible to convey information on the relation
> between the control value and the hardware feature being controlled.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/uapi/linux/videodev2.h | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index ae083978988f1..23b02f2db85a1 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1652,6 +1652,32 @@ struct v4l2_queryctrl {
>  	__u32		     reserved[2];
>  };
>  
> +/* V4L2 control exponential bases */
> +#define V4L2_CTRL_BASE_UNDEFINED	0
> +#define V4L2_CTRL_BASE_LINEAR		1

I'm not really sure you need BASE_LINEAR. That is effectively the same
as UNDEFINED since what else can you do? It's also weird to have this
as 'base' if the EXPONENTIAL flag is set.

I don't see why you need the EXPONENTIAL flag at all: if this is non-0,
then you know the exponential base.

> +#define V4L2_CTRL_BASE_2		2
> +#define V4L2_CTRL_BASE_10		10
> +
> +/* V4L2 control unit prefixes */
> +#define V4L2_CTRL_PREFIX_NANO		-9
> +#define V4L2_CTRL_PREFIX_MICRO		-6
> +#define V4L2_CTRL_PREFIX_MILLI		-3
> +#define V4L2_CTRL_PREFIX_1		0

I would prefer PREFIX_NONE, since there is no prefix in this case.

I assume this prefix is only valid if the unit is not UNDEFINED and not
NONE?

Is 'base' also dependent on a valid unit? (it doesn't appear to be)

> +#define V4L2_CTRL_PREFIX_KILO		3
> +#define V4L2_CTRL_PREFIX_MEGA		6
> +#define V4L2_CTRL_PREFIX_GIGA		9
> +
> +/* V4L2 control units */
> +#define V4L2_CTRL_UNIT_UNDEFINED	0
> +#define V4L2_CTRL_UNIT_NONE		1
> +#define V4L2_CTRL_UNIT_SECOND		2
> +#define V4L2_CTRL_UNIT_AMPERE		3
> +#define V4L2_CTRL_UNIT_LINE		4
> +#define V4L2_CTRL_UNIT_PIXEL		5
> +#define V4L2_CTRL_UNIT_PIXELS_PER_SEC	6
> +#define V4L2_CTRL_UNIT_HZ		7
> +
> +
>  /*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
>  struct v4l2_query_ext_ctrl {
>  	__u32		     id;
> @@ -1666,7 +1692,10 @@ struct v4l2_query_ext_ctrl {
>  	__u32                elems;
>  	__u32                nr_of_dims;
>  	__u32                dims[V4L2_CTRL_MAX_DIMS];
> -	__u32		     reserved[32];
> +	__u8		     base;
> +	__s8		     prefix;
> +	__u16		     unit;
> +	__u32		     reserved[31];
>  };
>  
>  /*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
> @@ -1692,6 +1721,7 @@ struct v4l2_querymenu {
>  #define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x00000100
>  #define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x00000200
>  #define V4L2_CTRL_FLAG_MODIFY_LAYOUT	0x00000400
> +#define V4L2_CTRL_FLAG_EXPONENTIAL	0x00000800
>  
>  /*  Query flags, to be ORed with the control ID */
>  #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
> 

Regards,

	Hans
