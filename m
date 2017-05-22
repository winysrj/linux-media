Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:36578 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757688AbdEVJNf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 05:13:35 -0400
Subject: Re: [PATCH 08/12] Add USB quirk for HVR-950q to avoid intermittent
 device resets
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        linux-media@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
 <1492643635-30823-9-git-send-email-dheitmueller@kernellabs.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ffd61598-b939-7404-cbcf-237e339e1eec@xs4all.nl>
Date: Mon, 22 May 2017 11:13:30 +0200
MIME-Version: 1.0
In-Reply-To: <1492643635-30823-9-git-send-email-dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On 04/20/2017 01:13 AM, Devin Heitmueller wrote:
> The USB core and sysfs will attempt to enumerate certain parameters
> which are unsupported by the au0828 - causing inconsistent behavior
> and sometimes causing the chip to reset.  Avoid making these calls.
> 
> This problem manifested as intermittent cases where the au8522 would
> be reset on analog video startup, in particular when starting up ALSA
> audio streaming in parallel - the sysfs entries created by
> snd-usb-audio on streaming startup would result in unsupported control
> messages being sent during tuning which would put the chip into an
> unknown state.
> 
> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>

I've accepted the other patches in this patch series for the media subsystem,
but this patch should go through the USB subsystem. Cc-ed linux-usb.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/usb/core/quirks.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
> index 96b21b0..3116edf 100644
> --- a/drivers/usb/core/quirks.c
> +++ b/drivers/usb/core/quirks.c
> @@ -223,6 +223,10 @@
>  	/* Blackmagic Design UltraStudio SDI */
>  	{ USB_DEVICE(0x1edb, 0xbd4f), .driver_info = USB_QUIRK_NO_LPM },
>  
> +	/* Hauppauge HVR-950q */
> +	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
> +			USB_QUIRK_CONFIG_INTF_STRINGS },
> +
>  	/* INTEL VALUE SSD */
>  	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
>  
> 
