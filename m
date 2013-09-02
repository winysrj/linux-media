Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab3IBJXK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Sep 2013 05:23:10 -0400
Date: Mon, 2 Sep 2013 11:23:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dinesh Ram <dinram@cisco.com>
Cc: linux-media@vger.kernel.org, dinesh.ram@cern.ch,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 4/6] si4713 : HID blacklist Si4713 USB development
 board
In-Reply-To: <228d4c6c3c411f4f5aad408d5bff88bb09a82e4e.1377861337.git.dinram@cisco.com>
Message-ID: <alpine.LNX.2.00.1309021122460.3796@pobox.suse.cz>
References: <1377862104-15429-1-git-send-email-dinram@cisco.com> <228d4c6c3c411f4f5aad408d5bff88bb09a82e4e.1377861337.git.dinram@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Aug 2013, Dinesh Ram wrote:

> The Si4713 development board contains a Si4713 FM transmitter chip
> and is handled by the radio-usb-si4713 driver.
> The board reports itself as (10c4:8244) Cygnal Integrated Products, Inc.
> and misidentifies itself as a HID device in its USB interface descriptor.
> This patch ignores this device as an HID device and hence loads the custom driver.
> 
> Signed-off-by: Dinesh Ram <dinram@cisco.com>
> 
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: linux-input@vger.kernel.org
> ---
>  drivers/hid/hid-core.c | 1 +
>  drivers/hid/hid-ids.h  | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 36668d1..109510f 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1977,6 +1977,7 @@ static const struct hid_device_id hid_ignore_list[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_BERKSHIRE, USB_DEVICE_ID_BERKSHIRE_PCWD) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CIDC, 0x0103) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI470X) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI4713) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CMEDIA, USB_DEVICE_ID_CM109) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_HIDCOM) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_ULTRAMOUSE) },
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index ffe4c7a..2a38726 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -241,6 +241,8 @@
>  #define USB_VENDOR_ID_CYGNAL		0x10c4
>  #define USB_DEVICE_ID_CYGNAL_RADIO_SI470X	0x818a
>  
> +#define USB_DEVICE_ID_CYGNAL_RADIO_SI4713       0x8244
> +
>  #define USB_VENDOR_ID_CYPRESS		0x04b4
>  #define USB_DEVICE_ID_CYPRESS_MOUSE	0x0001
>  #define USB_DEVICE_ID_CYPRESS_HIDCOM	0x5500

Acked-by: Jiri Kosina <jkosina@suse.cz>

(under the assumption that this goes in together with the custom driver).

-- 
Jiri Kosina
SUSE Labs
