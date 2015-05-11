Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49730 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbbEKMo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2015 08:44:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Subject: Re: [PATCH] rcar-vin: use monotonic timestamps
Date: Mon, 11 May 2015 15:45:01 +0300
Message-ID: <4034219.qcMWoD1LzB@avalon>
In-Reply-To: <554B0713.6060003@xs4all.nl>
References: <554B058D.2040001@xs4all.nl> <554B0713.6060003@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 07 May 2015 08:32:51 Hans Verkuil wrote:
> On 05/07/2015 08:26 AM, Hans Verkuil wrote:
> > Even though the rcar-vin driver tells userspace that it will give a
> > monotonic timestamp, it is actually using gettimeofday. Replace this with
> > a proper monotonic timestamp.
> 
> It was clearly too early in the day for me, but here is my Signed-off-by:
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

And my

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> > diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
> > b/drivers/media/platform/soc_camera/rcar_vin.c index 35deed8..b64dfea
> > 100644
> > --- a/drivers/media/platform/soc_camera/rcar_vin.c
> > +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> > @@ -894,7 +894,7 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
> > 
> >  		priv->queue_buf[slot]->v4l2_buf.field = priv->field;
> >  		priv->queue_buf[slot]->v4l2_buf.sequence = priv->sequence++;
> > 
> > -		do_gettimeofday(&priv->queue_buf[slot]->v4l2_buf.timestamp);
> > +		v4l2_get_timestamp(&priv->queue_buf[slot]->v4l2_buf.timestamp);
> > 
> >  		vb2_buffer_done(priv->queue_buf[slot], VB2_BUF_STATE_DONE);
> >  		priv->queue_buf[slot] = NULL;

-- 
Regards,

Laurent Pinchart

