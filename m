Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4935 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbZCCVSh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 16:18:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Subject: Re: Possible omission in v4l2-common.c?
Date: Tue, 3 Mar 2009 22:18:55 +0100
Cc: linux-media@vger.kernel.org
References: <de8cad4d0903030450qf4063f1r9e4e53f5f83f1763@mail.gmail.com>
In-Reply-To: <de8cad4d0903030450qf4063f1r9e4e53f5f83f1763@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903032218.55382.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 03 March 2009 13:50:30 Brandon Jenkins wrote:
> Hello all,
>
> I was upgrading drivers this morning to capture the latest changes for
> the cx18 and I received a merge conflict in v4l2-common.c. In my
> system, 1 HDPVR and 3 CX18s. The HDPVR sources are 5 weeks old from
> their last sync up but contain:
>
> case V4L2_CID_SHARPNESS:
>
> The newer sources do not, but still have reference to sharpness at
> line 420: case V4L2_CID_SHARPNESS:                return "Sharpness";
>
> Because I don't know which way the code is going (is sharpness in or
> out) I can't submit a patch, but thought I would raise here. Diff
> below was pulled from clean clone of v4l-dvb tree.

Sharpness is definitely in. This is a bug, please submit this patch with a 
Signed-off-by line and I'll get it merged.

Thanks,

	Hans

> Thanks,
>
> Brandon
>
> diff -r 91f9c6c451f7 linux/drivers/media/video/v4l2-common.c
> --- a/linux/drivers/media/video/v4l2-common.c	Mon Mar 02 09:39:13 2009
> -0300 +++ b/linux/drivers/media/video/v4l2-common.c	Tue Mar 03 07:44:58
> 2009 -0500 @@ -567,6 +567,7 @@
>  	case V4L2_CID_CONTRAST:
>  	case V4L2_CID_SATURATION:
>  	case V4L2_CID_HUE:
> +	case V4L2_CID_SHARPNESS:
>  	case V4L2_CID_RED_BALANCE:
>  	case V4L2_CID_BLUE_BALANCE:
>  	case V4L2_CID_GAMMA:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
