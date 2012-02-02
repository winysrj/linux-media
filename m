Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab2BBIwa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 03:52:30 -0500
Date: Thu, 2 Feb 2012 09:52:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Anssi Hannula <anssi.hannula@iki.fi>, linux-input@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Two devices, same USB ID: one needs HID, the other doesn't. How
 to solve this?
In-Reply-To: <201201131521.49882.hverkuil@xs4all.nl>
Message-ID: <alpine.LNX.2.00.1202020951510.18918@pobox.suse.cz>
References: <201201131142.33779.hverkuil@xs4all.nl> <4F1032F9.8020505@iki.fi> <201201131521.49882.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Jan 2012, Hans Verkuil wrote:

> [RFC PATCH] hid-core: ignore the Keene FM transmitter.
> 
> The Keene FM transmitter USB device has the same USB ID as
> the Logitech AudioHub Speaker, but it should ignore the hid.
> Check if the name is that of the Keene device.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/hid/hid-core.c |   10 ++++++++++
>  drivers/hid/hid-ids.h  |    1 +
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index af35384..f02d197 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1973,6 +1973,16 @@ static bool hid_ignore(struct hid_device *hdev)
>  		if (hdev->product >= USB_DEVICE_ID_LOGITECH_HARMONY_FIRST &&
>  				hdev->product <= USB_DEVICE_ID_LOGITECH_HARMONY_LAST)
>  			return true;
> +		/*
> +		 * The Keene FM transmitter USB device has the same USB ID as
> +		 * the Logitech AudioHub Speaker, but it should ignore the hid.
> +		 * Check if the name is that of the Keene device.
> +		 * For reference: the name of the AudioHub is
> +		 * "HOLTEK  AudioHub Speaker".
> +		 */
> +		if (hdev->product == USB_DEVICE_ID_LOGITECH_AUDIOHUB &&
> +			!strcmp(hdev->name, "HOLTEK  B-LINK USB Audio  "))
> +				return true;
>  		break;
>  	case USB_VENDOR_ID_SOUNDGRAPH:
>  		if (hdev->product >= USB_DEVICE_ID_SOUNDGRAPH_IMON_FIRST &&
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 4a441a6..2f6dc92 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -440,6 +440,7 @@
>  #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
>  
>  #define USB_VENDOR_ID_LOGITECH		0x046d
> +#define USB_DEVICE_ID_LOGITECH_AUDIOHUB 0x0a0e
>  #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
>  #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110
>  #define USB_DEVICE_ID_LOGITECH_HARMONY_LAST 0xc14f
> -- 
> 1.7.7.3
> 
> Comments? Or even better, an Acked-by?
> 
> I'd like to get this driver in for v3.4, that would be nice.

This is fine and I will Ack/take it once it goes in with your driver for 
the device.

-- 
Jiri Kosina
SUSE Labs
