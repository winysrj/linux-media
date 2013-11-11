Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:46359 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3KKWqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 17:46:40 -0500
Received: by mail-we0-f173.google.com with SMTP id u57so5149748wes.18
        for <linux-media@vger.kernel.org>; Mon, 11 Nov 2013 14:46:39 -0800 (PST)
Message-ID: <52815E4C.2080103@gmail.com>
Date: Mon, 11 Nov 2013 23:46:36 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [RESEND] gspca-stk1135: Add delay after configuring clock
References: <201311112331.37052.linux@rainbow-software.org>
In-Reply-To: <201311112331.37052.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ondrej,

On 11/11/2013 11:31 PM, Ondrej Zary wrote:
> Add a small delay at the end of configure_clock() to allow sensor to initialize.
> This is needed by Asus VX2S laptop webcam to detect sensor type properly (the already-supported MT9M112).
>
> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
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

Instead of this 1 ms busy loop waiting it might be more optimal to use 
usleep_range(),
e.g. usleep_range(1000, 1100);

>   }
>
>   static void stk1135_camera_disable(struct gspca_dev *gspca_dev)

--
Regards,
Sylwester
