Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab2IIVy4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 17:54:56 -0400
Message-ID: <504D1077.1090807@redhat.com>
Date: Sun, 09 Sep 2012 23:56:07 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] gspca_pac7302: add support for device 1ae7:2001 Speedlink
 Snappy Microphone SL-6825-SBK
References: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Entire series applied and included in my pull-req for 3.7 which I just send out.

Thanks,

Hans


On 09/09/2012 08:02 PM, Frank Schäfer wrote:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> Cc: stable@kernel.org
> ---
>   drivers/media/usb/gspca/pac7302.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
> index 4877f7a..e906f56 100644
> --- a/drivers/media/usb/gspca/pac7302.c
> +++ b/drivers/media/usb/gspca/pac7302.c
> @@ -905,6 +905,7 @@ static const struct usb_device_id device_table[] = {
>   	{USB_DEVICE(0x093a, 0x262a)},
>   	{USB_DEVICE(0x093a, 0x262c)},
>   	{USB_DEVICE(0x145f, 0x013c)},
> +	{USB_DEVICE(0x1ae7, 0x2001)}, /* SpeedLink Snappy Mic SL-6825-SBK */
>   	{}
>   };
>   MODULE_DEVICE_TABLE(usb, device_table);
>
