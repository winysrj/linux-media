Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9229 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab2CBIpd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 03:45:33 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M09001S11NT9S@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Mar 2012 08:45:29 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M09002IW1NV6V@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Mar 2012 08:45:31 +0000 (GMT)
Date: Fri, 02 Mar 2012 09:45:30 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/3] v4l: add contorl definitions for codec devices.
In-reply-to: <007101ccf81a$a507c610$ef175230$%park@samsung.com>
To: jtp.park@samsung.com
Cc: linux-media@vger.kernel.org, 'Kamil Debski' <k.debski@samsung.com>,
	janghyuck.kim@samsung.com, jaeryul.oh@samsung.com,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Message-id: <4F5088AA.80704@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <007101ccf81a$a507c610$ef175230$%park@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jongtae,

On 03/02/2012 03:17 AM, Jeongtae Park wrote:
> @@ -1458,17 +1462,18 @@ enum v4l2_mpeg_video_header_mode {
>  };
>  #define V4L2_CID_MPEG_VIDEO_MAX_REF_PIC			(V4L2_CID_MPEG_BASE+217)
>  #define V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE		(V4L2_CID_MPEG_BASE+218)
> -#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES	(V4L2_CID_MPEG_BASE+219)
> +#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BITS	(V4L2_CID_MPEG_BASE+219)
>  #define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB		(V4L2_CID_MPEG_BASE+220)
>  #define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE		(V4L2_CID_MPEG_BASE+221)
>  enum v4l2_mpeg_video_multi_slice_mode {
>  	V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE		= 0,
> -	V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB		= 1,
> -	V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES	= 2,
> +	V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_MB		= 1,
> +	V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BITS	= 2,

Should this be a separate bugfix patch ? We need to make sure the 
applications work with older kernels too, perhaps a patch with 
stable@vger.kernel.org at Cc would do.

Don't you need to update the multi_slice[] array in v4l2-ctrls.c 
as well ? Now it is:

static const char * const multi_slice[] = {
	"Single",
	"Max Macroblocks",
	"Max Bytes",
	NULL,
}; 

And the corresponding individual controls:

 case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES: return "Maximum Bytes in a Slice";
 case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:	 return "Number of MBs in a Slice";

Please make sure the descriptions are consistent with CIDs.

--

Regards,
Sylwester
