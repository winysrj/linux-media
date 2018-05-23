Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43342 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932178AbeEWJlq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 05:41:46 -0400
Date: Wed, 23 May 2018 11:41:41 +0200
From: Ana Guerrero Lopez <ana.guerrero@collabora.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: ming_qian@realsil.com.cn,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kai Heng Feng <kai.heng.feng@canonical.com>
Subject: Re: [PATCH] media: uvcvideo: Support realtek's UVC 1.5 device
Message-ID: <20180523094141.GA32594@delenn>
References: <1525831988-32017-1-git-send-email-ming_qian@realsil.com.cn>
 <2510852.fx2XduE8hM@avalon>
 <C2D9C61E-F990-4C47-8E9E-18CA74C79FA2@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2D9C61E-F990-4C47-8E9E-18CA74C79FA2@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > commit a9c002732695eab2096580a0d1a1687bc2f95928
> > Author: ming_qian <ming_qian@realsil.com.cn>
> > Date:   Wed May 9 10:13:08 2018 +0800
> > 
> >     media: uvcvideo: Support UVC 1.5 video probe & commit controls
> > 
> >     The length of UVC 1.5 video control is 48, and it is 34 for UVC 1.1.
> >     Change it to 48 for UVC 1.5 device, and the UVC 1.5 device can be
> >     recognized.
> > 
> >     More changes to the driver are needed for full UVC 1.5 compatibility.
> >     However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have been
> >     reported to work well.
> > 
> >     Cc: stable@vger.kernel.org
> >     Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
> >     [Factor out code to helper function, update size checks]
> >     Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I tested this new patch and it works well.
> 
> Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

I tested it as well and it works well.

Tested-by: Ana Guerrero Lopez <ana.guerrero@collabora.com>


> > 
> > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > b/drivers/media/usb/uvc/uvc_video.c
> > index eb9e04a59427..285b0e813b9d 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -207,14 +207,27 @@ static void uvc_fixup_video_ctrl(struct
> > uvc_streaming *stream,
> >  	}
> >  }
> > 
> > +static size_t uvc_video_ctrl_size(struct uvc_streaming *stream)
> > +{
> > +	/*
> > +	 * Return the size of the video probe and commit controls, which depends
> > +	 * on the protocol version.
> > +	 */
> > +	if (stream->dev->uvc_version < 0x0110)
> > +		return 26;
> > +	else if (stream->dev->uvc_version < 0x0150)
> > +		return 34;
> > +	else
> > +		return 48;
> > +}
> > +
> >  static int uvc_get_video_ctrl(struct uvc_streaming *stream,
> >  	struct uvc_streaming_control *ctrl, int probe, u8 query)
> >  {
> > +	u16 size = uvc_video_ctrl_size(stream);
> >  	u8 *data;
> > -	u16 size;
> >  	int ret;
> > 
> > -	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
> >  	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
> >  			query == UVC_GET_DEF)
> >  		return -EIO;
> > @@ -271,7 +284,7 @@ static int uvc_get_video_ctrl(struct uvc_streaming
> > *stream,
> >  	ctrl->dwMaxVideoFrameSize = get_unaligned_le32(&data[18]);
> >  	ctrl->dwMaxPayloadTransferSize = get_unaligned_le32(&data[22]);
> > 
> > -	if (size == 34) {
> > +	if (size >= 34) {
> >  		ctrl->dwClockFrequency = get_unaligned_le32(&data[26]);
> >  		ctrl->bmFramingInfo = data[30];
> >  		ctrl->bPreferedVersion = data[31];
> > @@ -300,11 +313,10 @@ static int uvc_get_video_ctrl(struct uvc_streaming
> > *stream,
> >  static int uvc_set_video_ctrl(struct uvc_streaming *stream,
> >  	struct uvc_streaming_control *ctrl, int probe)
> >  {
> > +	u16 size = uvc_video_ctrl_size(stream);
> >  	u8 *data;
> > -	u16 size;
> >  	int ret;
> > 
> > -	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
> >  	data = kzalloc(size, GFP_KERNEL);
> >  	if (data == NULL)
> >  		return -ENOMEM;
> > @@ -321,7 +333,7 @@ static int uvc_set_video_ctrl(struct uvc_streaming
> > *stream,
> >  	put_unaligned_le32(ctrl->dwMaxVideoFrameSize, &data[18]);
> >  	put_unaligned_le32(ctrl->dwMaxPayloadTransferSize, &data[22]);
> > 
> > -	if (size == 34) {
> > +	if (size >= 34) {
> >  		put_unaligned_le32(ctrl->dwClockFrequency, &data[26]);
> >  		data[30] = ctrl->bmFramingInfo;
> >  		data[31] = ctrl->bPreferedVersion;
> > 
> > -- 
> > Regards,
> > 
> > Laurent Pinchart
