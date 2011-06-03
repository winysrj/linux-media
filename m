Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36664 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1FCWC3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 18:02:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv2 PATCH 08/11] v4l2-ctrls: simplify event subscription.
Date: Fri, 3 Jun 2011 21:55:10 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl> <2993c04b0ba330b3f634e281a6b50ee8cd7e6f7c.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <2993c04b0ba330b3f634e281a6b50ee8cd7e6f7c.1306329390.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106032155.10808.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the patch.

On Wednesday 25 May 2011 15:33:52 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |   31 +++++++++++++++++++++++++++++++
>  include/media/v4l2-ctrls.h       |   25 +++++++++++++++++++++++++
>  2 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c
> b/drivers/media/video/v4l2-ctrls.c index e2a7ac7..9807a20 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -831,6 +831,22 @@ int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler
> *hdl, }
>  EXPORT_SYMBOL(v4l2_ctrl_handler_init);
> 
> +/* Count the number of controls */
> +unsigned v4l2_ctrl_handler_cnt(struct v4l2_ctrl_handler *hdl)
> +{
> +	struct v4l2_ctrl_ref *ref;
> +	unsigned cnt = 0;
> +
> +	if (hdl == NULL)
> +		return 0;
> +	mutex_lock(&hdl->lock);
> +	list_for_each_entry(ref, &hdl->ctrl_refs, node)
> +		cnt++;

As you don't use the entry, you can replace list_for_each_entry with 
list_for_each.

Should the handler keep a controls count ? In that case you wouldn't need this 
function.

> +	mutex_unlock(&hdl->lock);
> +	return cnt;
> +}
> +EXPORT_SYMBOL(v4l2_ctrl_handler_cnt);
> +
>  /* Free all controls and control refs */
>  void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
>  {
> @@ -1999,3 +2015,18 @@ void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct
> v4l2_fh *fh) v4l2_ctrl_unlock(ctrl);
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_del_fh);
> +
> +int v4l2_ctrl_sub_fh(struct v4l2_fh *fh, struct v4l2_event_subscription
> *sub, +		     unsigned n)

I would rename this to v4l2_ctrl_subscribe_fh(). I had trouble understanding 
what v4l2_ctrl_sub_fh() before reading the documentation. sub makes me think 
about sub-devices and subtract, not subscription.

> +{
> +	int ret = 0;
> +
> +	if (!fh->events)
> +		ret = v4l2_event_init(fh);
> +	if (!ret)
> +		ret = v4l2_event_alloc(fh, n);
> +	if (!ret)
> +		ret = v4l2_event_subscribe(fh, sub);

I tend to return errors when they occur instead of continuing to the end of 
the function. Handling errors on the spot makes code easier to read in my 
opinion, as I expect the main code flow to be the error-free path.

> +	return ret;
> +}

-- 
Regards,

Laurent Pinchart
