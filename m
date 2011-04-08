Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37233 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab1DHPNK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 11:13:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 8/9] vivi: add support for CTRL_CH_STATE events.
Date: Fri, 8 Apr 2011 17:13:13 +0200
Cc: linux-media@vger.kernel.org
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com> <ee0baff35423ae37b5e7a207477badf8fbf90551.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <ee0baff35423ae37b5e7a207477badf8fbf90551.1301916466.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081713.13624.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the patch.

On Monday 04 April 2011 13:51:53 Hans Verkuil wrote:
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-event.c |    6 ++++--
>  drivers/media/video/vivi.c       |    8 ++++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-event.c
> b/drivers/media/video/v4l2-event.c index c9251a5..9b503aa 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -258,7 +258,8 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  		return -ENOMEM;
>  	}
> 
> -	if (sub->type == V4L2_EVENT_CTRL_CH_VALUE) {
> +	if (sub->type == V4L2_EVENT_CTRL_CH_VALUE ||
> +			sub->type == V4L2_EVENT_CTRL_CH_STATE) {

Indentation looks weird here.

>  		ctrl = v4l2_ctrl_find(fh->ctrl_handler, sub->id);
>  		if (ctrl == NULL)
>  			return -EINVAL;
> @@ -341,7 +342,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  		list_del(&sev->list);
> 
>  	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> -	if (sev->type == V4L2_EVENT_CTRL_CH_VALUE) {
> +	if (sev->type == V4L2_EVENT_CTRL_CH_VALUE ||
> +			sev->type == V4L2_EVENT_CTRL_CH_STATE) {

And here.

>  		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(fh->ctrl_handler, sev->id);
> 
>  		if (ctrl)

-- 
Regards,

Laurent Pinchart
