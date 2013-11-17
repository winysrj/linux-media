Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab3KQNlS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 08:41:18 -0500
Message-ID: <5288C775.8070505@redhat.com>
Date: Sun, 17 Nov 2013 14:41:09 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] gspca-stk1135: Add delay after configuring clock
References: <1383437347-29262-1-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1383437347-29262-1-git-send-email-linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/03/2013 01:09 AM, Ondrej Zary wrote:
> Add a small delay at the end of configure_clock() to allow sensor to initialize.
> This is needed by Asus VX2S laptop webcam to detect sensor type properly (the already-supported MT9M112).
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>   drivers/media/usb/gspca/stk1135.c |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/usb/gspca/stk1135.c b/drivers/media/usb/gspca/stk1135.c
> index 8add2f7..d8a813c 100644
> --- a/drivers/media/usb/gspca/stk1135.c
> +++ b/drivers/media/usb/gspca/stk1135.c
> @@ -361,6 +361,9 @@ static void stk1135_configure_clock(struct gspca_dev *gspca_dev)
>
>   	/* set serial interface clock divider (30MHz/0x1f*16+2) = 60240 kHz) */
>   	reg_w(gspca_dev, STK1135_REG_SICTL + 2, 0x1f);
> +
> +	/* wait a while for sensor to catch up */
> +	udelay(1000);
>   }
>
>   static void stk1135_camera_disable(struct gspca_dev *gspca_dev)
>

Thanks for the patch. I've added this to my tree for 3.13 .

Regards,

Hans

