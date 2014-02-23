Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbaBWVrd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 16:47:33 -0500
Message-ID: <530A6C69.7010106@redhat.com>
Date: Sun, 23 Feb 2014 22:47:21 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, linux-media@vger.kernel-org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Brian Johnson <brijohn@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: gspca: sn9c20x: add ID for Genius Look 1320 V2
References: <1391279164-2935-1-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1391279164-2935-1-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks I've added this to my gspca tree for 3.15, with a
Cc: stable@vger.kernel.org
For backporting it to older kernels.

Regards,

Hans


On 02/01/2014 07:26 PM, Wolfram Sang wrote:
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  Documentation/video4linux/gspca.txt | 1 +
>  drivers/media/usb/gspca/sn9c20x.c   | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/Documentation/video4linux/gspca.txt b/Documentation/video4linux/gspca.txt
> index 1e6b653..d2ba80b 100644
> --- a/Documentation/video4linux/gspca.txt
> +++ b/Documentation/video4linux/gspca.txt
> @@ -55,6 +55,7 @@ zc3xx		0458:700f	Genius VideoCam Web V2
>  sonixj		0458:7025	Genius Eye 311Q
>  sn9c20x		0458:7029	Genius Look 320s
>  sonixj		0458:702e	Genius Slim 310 NB
> +sn9c20x		0458:7045	Genius Look 1320 V2
>  sn9c20x		0458:704a	Genius Slim 1320
>  sn9c20x		0458:704c	Genius i-Look 1321
>  sn9c20x		045e:00f4	LifeCam VX-6000 (SN9C20x + OV9650)
> diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
> index 2a38621..41a9a89 100644
> --- a/drivers/media/usb/gspca/sn9c20x.c
> +++ b/drivers/media/usb/gspca/sn9c20x.c
> @@ -2359,6 +2359,7 @@ static const struct usb_device_id device_table[] = {
>  	{USB_DEVICE(0x045e, 0x00f4), SN9C20X(OV9650, 0x30, 0)},
>  	{USB_DEVICE(0x145f, 0x013d), SN9C20X(OV7660, 0x21, 0)},
>  	{USB_DEVICE(0x0458, 0x7029), SN9C20X(HV7131R, 0x11, 0)},
> +	{USB_DEVICE(0x0458, 0x7045), SN9C20X(MT9M112, 0x5d, LED_REVERSE)},
>  	{USB_DEVICE(0x0458, 0x704a), SN9C20X(MT9M112, 0x5d, 0)},
>  	{USB_DEVICE(0x0458, 0x704c), SN9C20X(MT9M112, 0x5d, 0)},
>  	{USB_DEVICE(0xa168, 0x0610), SN9C20X(HV7131R, 0x11, 0)},
> 
