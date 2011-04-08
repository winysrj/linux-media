Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44576 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab1DHPTh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 11:19:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 6/9] vivi: add support for control events.
Date: Fri, 8 Apr 2011 17:19:40 +0200
Cc: linux-media@vger.kernel.org
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com> <a2608527646b3a947d8493feaa4f5df81655e571.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <a2608527646b3a947d8493feaa4f5df81655e571.1301916466.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081719.41063.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the patch.
On Monday 04 April 2011 13:51:51 Hans Verkuil wrote:

[snip]

> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> index 21d8f6a..8790e03 100644
> --- a/drivers/media/video/vivi.c
> +++ b/drivers/media/video/vivi.c
> @@ -998,6 +1007,25 @@ static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
>  	File operations for the device
>     ------------------------------------------------------------------*/
> 
> +static int vivi_open(struct file *filp)
> +{
> +	int ret = v4l2_fh_open(filp);
> +	struct v4l2_fh *fh;
> +
> +	if (ret)
> +		return ret;
> +	fh = filp->private_data;
> +	ret = v4l2_event_init(fh);
> +	if (ret)
> +		goto rel_fh;
> +	ret = v4l2_event_alloc(fh, 10);
> +	if (!ret)
> +		return ret;
> +rel_fh:
> +	v4l2_fh_release(filp);
> +	return ret;
> +}
> +

Should the V4L2 core provide a helper function that does just that ?

>  static ssize_t
>  vivi_read(struct file *file, char __user *data, size_t count, loff_t
> *ppos) {
> @@ -1012,10 +1040,17 @@ static unsigned int
>  vivi_poll(struct file *file, struct poll_table_struct *wait)
>  {
>  	struct vivi_dev *dev = video_drvdata(file);
> +	struct v4l2_fh *fh = file->private_data;
>  	struct vb2_queue *q = &dev->vb_vidq;
> +	unsigned int res;
> 
>  	dprintk(dev, 1, "%s\n", __func__);
> -	return vb2_poll(q, file, wait);
> +	res = vb2_poll(q, file, wait);
> +	if (v4l2_event_pending(fh))
> +		res |= POLLPRI;
> +	else
> +		poll_wait(file, &fh->events->wait, wait);

Don't you need to call poll_wait unconditionally ?

> +	return res;
>  }
> 
>  static int vivi_close(struct file *file)

[snip]

-- 
Regards,

Laurent Pinchart
