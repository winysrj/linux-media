Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B9EC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 11:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6B1C2086D
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 11:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfARLSH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 06:18:07 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39487 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfARLSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 06:18:06 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gkSA1-0008OY-Gg; Fri, 18 Jan 2019 12:18:05 +0100
Message-ID: <1547810284.3375.6.camel@pengutronix.de>
Subject: Re: [PATCH v7] media: imx: add mem2mem device
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date:   Fri, 18 Jan 2019 12:18:04 +0100
In-Reply-To: <e68a4de5-a499-ea02-20e7-79e4d175708c@xs4all.nl>
References: <20190117155032.3317-1-p.zabel@pengutronix.de>
         <e68a4de5-a499-ea02-20e7-79e4d175708c@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Fri, 2019-01-18 at 10:30 +0100, Hans Verkuil wrote:
> On 1/17/19 4:50 PM, Philipp Zabel wrote:
[...]
> > +
> > +static const struct video_device ipu_csc_scaler_videodev_template = {
> > +	.name		= "ipu0_ic_pp mem2mem",
> 
> I would expect to see something like 'imx-media-csc-scaler' as the name.
> Wouldn't that be more descriptive?

Yes, thank you. I'll change this as well.

[...]
> > diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> > index 4b344a4a3706..fee2ece0a6f8 100644
> > --- a/drivers/staging/media/imx/imx-media-dev.c
> > +++ b/drivers/staging/media/imx/imx-media-dev.c
> > @@ -318,12 +318,36 @@ static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
> >  		goto unlock;
> >  
> >  	ret = v4l2_device_register_subdev_nodes(&imxmd->v4l2_dev);
> > -unlock:
> > -	mutex_unlock(&imxmd->mutex);
> >  	if (ret)
> > -		return ret;
> > +		goto unlock;
> > +
> > +	imxmd->m2m_vdev = imx_media_csc_scaler_device_init(imxmd);
> > +	if (IS_ERR(imxmd->m2m_vdev)) {
> > +		ret = PTR_ERR(imxmd->m2m_vdev);
> > +		goto unlock;
> > +	}
> >  
> > -	return media_device_register(&imxmd->md);
> > +	ret = imx_media_csc_scaler_device_register(imxmd->m2m_vdev);
> > +	if (ret)
> > +		goto m2m_remove;
> > +
> > +	mutex_unlock(&imxmd->mutex);
> > +
> > +	ret = media_device_register(&imxmd->md);
> > +	if (ret) {
> > +		mutex_lock(&imxmd->mutex);
> > +		goto m2m_unreg;
> > +	}
> 
> I am missing a call to v4l2_m2m_register_media_controller() to ensure that this
> device shows up in the media controller.

I can do that, but what would be the purpose of it showing up in the
media controller?
There is nothing to be configured, no interaction with the rest of the
graph, and the processing subdevice wouldn't even correspond to an
actual hardware unit. I assumed this would clutter the media controller
for no good reason.

[...]
> > @@ -262,6 +265,13 @@ void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
> >  					 struct v4l2_pix_format *pix);
> >  void imx_media_capture_device_error(struct imx_media_video_dev *vdev);
> >  
> > +/* imx-media-mem2mem.c */
> > +struct imx_media_video_dev *
> > +imx_media_csc_scaler_device_init(struct imx_media_dev *dev);
> > +void imx_media_csc_scaler_device_remove(struct imx_media_video_dev *vdev);
> > +int imx_media_csc_scaler_device_register(struct imx_media_video_dev *vdev);
> > +void imx_media_csc_scaler_device_unregister(struct imx_media_video_dev *vdev);
> > +
> >  /* subdev group ids */
> >  #define IMX_MEDIA_GRP_ID_CSI2      BIT(8)
> >  #define IMX_MEDIA_GRP_ID_CSI_BIT   9
> 
> How did you test the rotate control? I'm asking because I would expect to see code
> that checks this control in the *_fmt ioctls: rotating 90 or 270 degrees would mean
> that the reported width and height are swapped for the capture queue. And I see no
> sign that that is done. For the same reason this should also impact the g/s_selection
> code.

I'm probably misunderstanding something.

Which "reported width and height" have to be swapped compared to what?
Since this is a scaler, the capture queue has its own width and height,
independent of the output queue width and height.
What currently happens is that the chosen capture width and height stay
the same upon rotation, so the image is stretched into the configured
dimensions.

The V4L2_CID_ROTATE documentation [1] states:

    Rotates the image by specified angle. Common angles are 90, 270 and
    180. Rotating the image to 90 and 270 will reverse the height and
    width of the display window. It is necessary to set the new height
    and width of the picture using the VIDIOC_S_FMT ioctl according to
    the rotation angle selected.

[1] https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/control.html#control-ids

I didn't understand what the "display window" is in the context of a
mem2mem scaler/rotator/CSC converter. Is this intended to mean that
aspect ratio should be kept as intact as possible, and that every time
V4L2_CID_ROTATE changes between 0/180 and 90/270, an automatic S_FMT
should be issued on the capture queue with width and height switched
compared to the currently set value? This might still slightly modify
width and height due to alignment restrictions.

regards
Philipp
