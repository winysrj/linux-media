Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54233 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753695AbeDMHAD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Apr 2018 03:00:03 -0400
Received: from mail-pf0-f198.google.com ([209.85.192.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1f6sgk-0002p6-Hj
        for linux-media@vger.kernel.org; Fri, 13 Apr 2018 07:00:02 +0000
Received: by mail-pf0-f198.google.com with SMTP id p10so4288697pfl.22
        for <linux-media@vger.kernel.org>; Fri, 13 Apr 2018 00:00:02 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii;
        delsp=yes;
        format=flowed
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: [PATCH] media: cx231xx: Add support for AverMedia DVD EZMaker 7
From: Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20180326060616.5354-1-kai.heng.feng@canonical.com>
Date: Fri, 13 Apr 2018 14:59:56 +0800
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <BC47F34C-7BF6-4A61-9EA0-BA8C24E71F6E@canonical.com>
References: <20180326060616.5354-1-kai.heng.feng@canonical.com>
To: mchehab@kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> On Mar 26, 2018, at 2:06 PM, Kai-Heng Feng <kai.heng.feng@canonical.com>  
> wrote:
>
> User reports AverMedia DVD EZMaker 7 can be driven by VIDEO_GRABBER.
> Add the device to the id_table to make it work.

*Gentle ping*
I am hoping this patch can get merged in v4.17.

Kai-Heng

>
> BugLink: https://bugs.launchpad.net/bugs/1620762
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/media/usb/cx231xx/cx231xx-cards.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c  
> b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index f9ec7fedcd5b..da01c5125acb 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -945,6 +945,9 @@ struct usb_device_id cx231xx_id_table[] = {
>  	 .driver_info = CX231XX_BOARD_CNXT_RDE_250},
>  	{USB_DEVICE(0x0572, 0x58A0),
>  	 .driver_info = CX231XX_BOARD_CNXT_RDU_250},
> +	/* AverMedia DVD EZMaker 7 */
> +	{USB_DEVICE(0x07ca, 0xc039),
> +	 .driver_info = CX231XX_BOARD_CNXT_VIDEO_GRABBER},
>  	{USB_DEVICE(0x2040, 0xb110),
>  	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL},
>  	{USB_DEVICE(0x2040, 0xb111),
> -- 
> 2.15.1
