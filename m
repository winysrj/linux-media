Return-Path: <hverkuil@xs4all.nl>
Message-id: <550C21F4.5040502@xs4all.nl>
Date: Fri, 20 Mar 2015 14:34:44 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Arun Kumar K <arun.kk@samsung.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/5] media: New flag V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
References: <1426778486-21807-1-git-send-email-ricardo.ribalda@gmail.com>
 <1426778486-21807-3-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1426778486-21807-3-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
List-ID: <linux-media.vger.kernel.org>



On 03/19/2015 04:21 PM, Ricardo Ribalda Delgado wrote:
> Create a new flag that represent controls that represent controls that

Double 'that represent controls' :-)

> its value needs to be passed to the driver even if it has not changed.
> 
> They typically represent actions, like triggering a flash or clearing an
> error flag.

I would add something like:

"So writing to such a control means some action is executed."

This ties in a bit better with the name of the flag.

	Hans

> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  include/uapi/linux/videodev2.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index fbdc360..1e33e10 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1456,6 +1456,7 @@ struct v4l2_querymenu {
>  #define V4L2_CTRL_FLAG_WRITE_ONLY 	0x0040
>  #define V4L2_CTRL_FLAG_VOLATILE		0x0080
>  #define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x0100
> +#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x0200
>  
>  /*  Query flags, to be ORed with the control ID */
>  #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
> 
