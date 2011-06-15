Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2383 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1FOG6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 02:58:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 3/4 v9] v4l2-ctrl: add codec controls support to the control framework
Date: Wed, 15 Jun 2011 08:58:09 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com> <1308069416-24723-4-git-send-email-k.debski@samsung.com>
In-Reply-To: <1308069416-24723-4-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106150858.09410.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, June 14, 2011 18:36:55 Kamil Debski wrote:
> Add support for the codec controls to the v4l2 control framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |  281 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 281 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 2412f08..acc76f5 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c

...

> +	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK: 	return "H264 dark region adaptive";
> +	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH: return "H264 smooth region adaptive";
> +	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC: return "H264 static region adaptive";
> +	case V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY: return "H264 MB activity adaptive";

I forgot to mention: MFC51 specific controls should not be added here.
Instead use v4l2_ctrl_new_custom() in the MFC driver itself.

Since these controls are driver-specific it makes no sense to add support for
them to the V4L2 core code.

Regards,

	Hans
