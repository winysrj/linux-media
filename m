Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:23294 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab0AMUeU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 15:34:20 -0500
Message-ID: <4B4E2E48.1000509@gmail.com>
Date: Wed, 13 Jan 2010 21:34:16 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, Pekka Sarnila <sarnila@adit.fi>
Subject: Re: [PATCH 1/1] HID: ignore afatech 9016
References: <1263412773-23220-1-git-send-email-jslaby@suse.cz> <alpine.LNX.2.00.1001132111570.30977@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1001132111570.30977@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/13/2010 09:20 PM, Jiri Kosina wrote:
>> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
>> index 38773dc..788d9a3 100644
>> --- a/drivers/hid/usbhid/hid-quirks.c
>> +++ b/drivers/hid/usbhid/hid-quirks.c
>> @@ -41,7 +41,7 @@ static const struct hid_blacklist {
>>  	{ USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RUMBLEPAD, HID_QUIRK_BADPAD },
>>  	{ USB_VENDOR_ID_TOPMAX, USB_DEVICE_ID_TOPMAX_COBRAPAD, HID_QUIRK_BADPAD },
>>  
>> -	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
>> +	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_IGNORE },
> 
> Hmm, why do we keep HID_QUIRK_IGNORE anyway, when we already have generic 
> hid_ignore_list[]?

You returned it back because of dynamic quirks...

> We don't set it for any device in the current codebase any more.

Oh yeah, it's hard for people who don't remember code they wrote :).
Will respin. Thanks for the reminder.

-- 
js
