Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:39211 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab2KWRJZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 12:09:25 -0500
Date: Fri, 23 Nov 2012 18:09:09 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] gspca - ov534: Fix the light frequency filter
Message-Id: <20121123180909.021c55a8c3795329836c42b7@studenti.unina.it>
In-Reply-To: <20121122124652.3a832e33@armhf>
References: <20121122124652.3a832e33@armhf>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 22 Nov 2012 12:46:52 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> (fix lack of signature)
> From: Jean-François Moine <moinejf@free.fr>
> 
> The exchanges relative to the light frequency filter were adapted
> from a description found in a ms-windows driver. It seems that the
> registers were the ones of some other sensor.
>

The PS3 sends the old sequence too AFAIR, for the PS3 Eye.

> This patch was done thanks to the documentation of the right
> OmniVision sensors.
>

In the datasheet I have for ov772x, bit[6] of register 0x13 is described
as:

  Bit[6]: AEC - Step size limit
    0: Step size is limited to vertical blank
    1: Unlimited step size

And the patch makes Light Frequency _NOT_ work with the PS3 eye (based
on ov772x).

What does the ov767x datasheet say?

Maybe we should use the new values only when
	sd->sensor == SENSOR_OV767x

What sensor does Alexander's webcam use?

> Note: The light frequency filter is either off or automatic.
> The application will see either off or "50Hz" only.
> 
> Tested-by: alexander calderon <fabianp902@gmail.com>
> Signed-off-by: Jean-François Moine <moinejf@free.fr>
> 
> --- a/drivers/media/usb/gspca/ov534.c
> +++ b/drivers/media/usb/gspca/ov534.c
> @@ -1038,13 +1038,12 @@
>  {
>  	struct sd *sd = (struct sd *) gspca_dev;
> 

drivers/media/usb/gspca/ov534.c: In function ‘setlightfreq’:
drivers/media/usb/gspca/ov534.c:1039:13: warning: unused variable ‘sd’ [-Wunused-variable]

But that will go away if we check for the sensor again in a next
version of the patch.

> -	val = val ? 0x9e : 0x00;
> -	if (sd->sensor == SENSOR_OV767x) {
> -		sccb_reg_write(gspca_dev, 0x2a, 0x00);
> -		if (val)
> -			val = 0x9d;	/* insert dummy to 25fps for 50Hz */
> -	}
> -	sccb_reg_write(gspca_dev, 0x2b, val);
> +	if (!val)
> +		sccb_reg_write(gspca_dev, 0x13,		/* off */
> +				sccb_reg_read(gspca_dev, 0x13) & ~0x20);
> +	else
> +		sccb_reg_write(gspca_dev, 0x13,		/* auto */
> +				sccb_reg_read(gspca_dev, 0x13) | 0x20);
>  }
>  

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
