Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2364 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZKSHZM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 02:25:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH v3] V4L - Adding Digital Video Timings APIs
Date: Thu, 19 Nov 2009 08:25:12 +0100
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
References: <1258584239-12092-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1258584239-12092-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911190825.12788.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 November 2009 23:43:59 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> Some minor updates (comment format) made to previous v3.
> 
> This is v3 of the digital video timings APIs implementation.
> This has updates based on comments received against v2 of the patch. Hopefully
> this can be merged to 2.6.33 if there are no more comments.
> 
> This adds the above APIs to the v4l2 core. This is based on version v1.2
> of the RFC titled "V4L - Support for video timings at the input/output interface"
> Following new ioctls are added:-
> 
> 	- VIDIOC_ENUM_DV_PRESETS
> 	- VIDIOC_S_DV_PRESET
> 	- VIDIOC_G_DV_PRESET
> 	- VIDIOC_QUERY_DV_PRESET
> 	- VIDIOC_S_DV_TIMINGS
> 	- VIDIOC_G_DV_TIMINGS
> 
> Please refer to the RFC for the details. This code was tested using vpfe
> capture driver on TI's DM365. Following is the test configuration used :-
> 
> Blue Ray HD DVD source -> TVP7002 -> DM365 (VPFE) ->DDR
> 
> A draft version of the TVP7002 driver (currently being reviewed in the mailing
> list) was used that supports V4L2_DV_1080I60 & V4L2_DV_720P60 presets. 
> 
> A loopback video capture application was used for testing these APIs. This calls
> following IOCTLS :-
> 
>  -  verify the new v4l2_input capabilities flag added
>  -  Enumerate available presets using VIDIOC_ENUM_DV_PRESETS
>  -  Set one of the supported preset using VIDIOC_S_DV_PRESET
>  -  Get current preset using VIDIOC_G_DV_PRESET
>  -  Detect current preset using VIDIOC_QUERY_DV_PRESET
>  -  Using stub functions in tvp7002, verify VIDIOC_S_DV_TIMINGS
>     and VIDIOC_G_DV_TIMINGS ioctls are received at the sub device. 
>  -  Tested on 64bit platform by Hans Verkuil
> 	
> TODOs :
> 
>  - Update v4l2-apps for the new ioctl (will send another patch after
>    compilation issue is resolved)
> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

I actually had not signed off on this yet, but now I do:

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Thanks!

	Hans

> Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>




-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
