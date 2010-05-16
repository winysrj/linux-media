Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab0EPB6O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 21:58:14 -0400
Message-ID: <4BEF5130.9080000@redhat.com>
Date: Sat, 15 May 2010 22:58:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC] Add 12 bit RAW Bayer Pattern pixel format support in V4L2
References: <33AB447FBD802F4E932063B962385B351E817016@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <33AB447FBD802F4E932063B962385B351E817016@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Zhang, Xiaolin wrote:
> Hi linux-media,
> 
> Current V4l2 only support 8 bit and 10 bit RAW Bayer Patten pixel format and this is a RFC to add 12 bit RAW Bay pixel format support by 4 more pixel format definition in videodev2.h. 
> The 12 bit RAW Bayer Pattern pixel format is not a platform specific and is available in mainstream digital camera devices. It will be supported by the ISP on Intel Atom platform.
> 
> The current 8 bit/10 bit RAW Bayer Pattern pixel format definitions are listed as in below, 
> 
> /* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
> #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
> #define V4L2_PIX_FMT_SGBRG8  v4l2_fourcc('G', 'B', 'R', 'G') /*  8  GBGB.. RGRG.. */
> #define V4L2_PIX_FMT_SGRBG8  v4l2_fourcc('G', 'R', 'B', 'G') /*  8  GRGR.. BGBG.. */
> #define V4L2_PIX_FMT_SRGGB8  v4l2_fourcc('R', 'G', 'G', 'B') /*  8  RGRG.. GBGB.. */
> #define V4L2_PIX_FMT_SBGGR10 v4l2_fourcc('B', 'G', '1', '0') /* 10  BGBG.. GRGR.. */
> #define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0') /* 10  GBGB.. RGRG.. */
> #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10  GRGR.. BGBG.. */
> #define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0') /* 10  RGRG.. GBGB.. */
> 
> I am proposing to add 4 more pixel format definition in similar with existing ones listed as in below, welcome any comment and suggestion. 
> 
> #define V4L2_PIX_FMT_SBGGR12 v4l2_fourcc('B', 'G', '1', '2') /* 12  BGBG.. GRGR.. */
> #define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
> #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
> #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */

Seems ok to me. A few points to consider:

1) At the patch, you should also patch the V4L2 docbook files, to provide a clean description
of those new formats;

2) Please submit this patch together with the patch series that adds a driver using the new
formats;

3) Please send the patches to add support for those new formats also to v4l-utils, in order to have
it properly supported on userspace.

> 
> BRs
> 
> BRs
> Xiaolin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
