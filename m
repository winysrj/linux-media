Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway05.websitewelcome.com ([69.93.35.13]:56613 "EHLO
	gateway05.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbaKDWlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Nov 2014 17:41:42 -0500
Received: from cm5.websitewelcome.com (cm5.websitewelcome.com [192.185.178.233])
	by gateway05.websitewelcome.com (Postfix) with ESMTP id BD38C2C07B4D2
	for <linux-media@vger.kernel.org>; Tue,  4 Nov 2014 16:20:37 -0600 (CST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Nov 2014 16:20:35 -0600
From: Dean Anderson <linux-dev@sensoray.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH] [media] s2255drv: fix spinlock issue
In-Reply-To: <1415133243-9929-1-git-send-email-linux-dev@sensoray.com>
References: <1415133243-9929-1-git-send-email-linux-dev@sensoray.com>
Message-ID: <bc42c2ddb9dfa9019862a6c56291dfe6@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is not so urgent, but should still be considered.  Please 
disregard the second comment below, which is not correct.

The original code, however, holds the spinlock for a long time.  From 
the structure of videobuf2, we could just hold qlock during buf_list and 
sequence accesses.


On 2014-11-04 14:34, Dean Anderson wrote:
> qlock spinlock controls access to buf_list and sequence.
> qlock spinlock should not be locked during a copy to video buffers, an
> operation that may sleep.
> 
> Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
> ---
>  drivers/media/usb/s2255/s2255drv.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/usb/s2255/s2255drv.c
> b/drivers/media/usb/s2255/s2255drv.c
> index ccc0009..24c4413 100644
> --- a/drivers/media/usb/s2255/s2255drv.c
> +++ b/drivers/media/usb/s2255/s2255drv.c
> @@ -558,27 +558,31 @@ static void s2255_fwchunk_complete(struct urb 
> *urb)
> 
>  }
> 
> -static int s2255_got_frame(struct s2255_vc *vc, int jpgsize)
> +static void s2255_got_frame(struct s2255_vc *vc, int jpgsize)
>  {
>  	struct s2255_buffer *buf;
>  	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
>  	unsigned long flags = 0;
> -	int rc = 0;
> +
>  	spin_lock_irqsave(&vc->qlock, flags);
>  	if (list_empty(&vc->buf_list)) {
>  		dprintk(dev, 1, "No active queue to serve\n");
> -		rc = -1;
> -		goto unlock;
> +		spin_unlock_irqrestore(&vc->qlock, flags);
> +		return;
>  	}
>  	buf = list_entry(vc->buf_list.next,
>  			 struct s2255_buffer, list);
>  	list_del(&buf->list);
>  	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
> +	buf->vb.v4l2_buf.field = vc->field;
> +	buf->vb.v4l2_buf.sequence = vc->frame_count;
> +	spin_unlock_irqrestore(&vc->qlock, flags);
> +
>  	s2255_fillbuff(vc, buf, jpgsize);
> +	/* tell v4l buffer was filled */
> +	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
>  	dprintk(dev, 2, "%s: [buf] [%p]\n", __func__, buf);
> -unlock:
> -	spin_unlock_irqrestore(&vc->qlock, flags);
> -	return rc;
> +	return;
>  }
> 
>  static const struct s2255_fmt *format_by_fourcc(int fourcc)
> @@ -649,11 +653,6 @@ static void s2255_fillbuff(struct s2255_vc *vc,
>  	}
>  	dprintk(dev, 2, "s2255fill at : Buffer 0x%08lx size= %d\n",
>  		(unsigned long)vbuf, pos);
> -	/* tell v4l buffer was filled */
> -	buf->vb.v4l2_buf.field = vc->field;
> -	buf->vb.v4l2_buf.sequence = vc->frame_count;
> -	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
> -	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
>  }
> 
> 
> --
> 1.9.1
