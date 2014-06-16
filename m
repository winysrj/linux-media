Return-path: <linux-media-owner@vger.kernel.org>
Received: from c.ponzo.net ([69.12.221.20]:57622 "EHLO c.ponzo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbaFPVKO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 17:10:14 -0400
Message-ID: <539F5D35.70201@ponzo.net>
Date: Mon, 16 Jun 2014 14:10:13 -0700
From: Scott Doty <scott@ponzo.net>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2 for v3.16] hdpvr: fix two audio bugs
References: <539EDE3D.7070704@xs4all.nl>
In-Reply-To: <539EDE3D.7070704@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2014 05:08 AM, Hans Verkuil wrote:
> Scott,
>
> Here is the correct version :-) Can you verify that it works for you?
>
> Regards,
>
> 	Hans
>
> When the audio encoding is changed the driver calls hdpvr_set_audio
> with the current opt->audio_input value. However, that should have
> been opt->audio_input + 1. So changing the audio encoding inadvertently
> changes the input as well. This bug has always been there.
>
> The second bug was introduced in kernel 3.10 and that broke the
> default_audio_input module option handling: the audio encoding was
> never switched to AC3 if default_audio_input was set to 2 (SPDIF input).
>
> In addition, since starting with 3.10 the audio encoding is always set
> at the start the first bug now always happens when the driver is loaded.
> In the past this bug would only surface if the user would change the
> audio encoding after the driver was loaded.
>
> Also fixes a small trivial typo (bufffer -> buffer).
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Scott Doty <scott@corp.sonic.net>
> Cc: stable@vger.kernel.org      # for v3.10 and up
> ---
>  drivers/media/usb/hdpvr/hdpvr-video.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index 0500c417..6bce01a 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -82,7 +82,7 @@ static void hdpvr_read_bulk_callback(struct urb *urb)
>  }
>  
>  /*=========================================================================*/
> -/* bufffer bits */
> +/* buffer bits */
>  
>  /* function expects dev->io_mutex to be hold by caller */
>  int hdpvr_cancel_queue(struct hdpvr_device *dev)
> @@ -926,7 +926,7 @@ static int hdpvr_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_MPEG_AUDIO_ENCODING:
>  		if (dev->flags & HDPVR_FLAG_AC3_CAP) {
>  			opt->audio_codec = ctrl->val;
> -			return hdpvr_set_audio(dev, opt->audio_input,
> +			return hdpvr_set_audio(dev, opt->audio_input + 1,
>  					      opt->audio_codec);
>  		}
>  		return 0;
> @@ -1198,7 +1198,7 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
>  	v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
>  		V4L2_CID_MPEG_AUDIO_ENCODING,
>  		ac3 ? V4L2_MPEG_AUDIO_ENCODING_AC3 : V4L2_MPEG_AUDIO_ENCODING_AAC,
> -		0x7, V4L2_MPEG_AUDIO_ENCODING_AAC);
> +		0x7, ac3 ? dev->options.audio_codec : V4L2_MPEG_AUDIO_ENCODING_AAC);
>  	v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
>  		V4L2_CID_MPEG_VIDEO_ENCODING,
>  		V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC, 0x3,


This did the trick!  Now my 5.1 audio is back -- and as a bonus, the
device now resets properly after a channel change.

Thank you very much!  Woo hoo! :)

 -Scott

