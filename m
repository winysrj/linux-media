Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1826 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaHRMe2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Aug 2014 08:34:28 -0400
Message-ID: <53F1F2A3.9060801@xs4all.nl>
Date: Mon, 18 Aug 2014 12:33:39 +0000
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] au0828: explicitly identify boards with analog TV
References: <1408362689-25583-1-git-send-email-m.chehab@samsung.com> <1408362689-25583-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1408362689-25583-2-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/2014 11:51 AM, Mauro Carvalho Chehab wrote:
> Right now, the au0828 driver uses .tuner to detect if analog
> tv is being used or not. By not filling .tuner fields at the
> board struct, the I2C core can't do decisions based on it.
> 
> So, add a field to explicitly tell when analog TV is supported.
> 
> No functional changes.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-cards.c | 10 +++-------
>  drivers/media/usb/au0828/au0828.h       |  1 +
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
> index 2c6b7da137ed..8f2fc2fe6a89 100644
> --- a/drivers/media/usb/au0828/au0828-cards.c
> +++ b/drivers/media/usb/au0828/au0828-cards.c
> @@ -46,6 +46,7 @@ struct au0828_board au0828_boards[] = {
>  		.name	= "Hauppauge HVR850",
>  		.tuner_type = TUNER_XC5000,
>  		.tuner_addr = 0x61,
> +		.has_analog = 1,
>  		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
>  		.input = {
>  			{
> @@ -72,12 +73,7 @@ struct au0828_board au0828_boards[] = {
>  		.tuner_type = TUNER_XC5000,
>  		.tuner_addr = 0x61,
>  		.has_ir_i2c = 1,
> -		/* The au0828 hardware i2c implementation does not properly
> -		   support the xc5000's i2c clock stretching.  So we need to
> -		   lower the clock frequency enough where the 15us clock
> -		   stretch fits inside of a normal clock cycle, or else the
> -		   au0828 fails to set the STOP bit.  A 30 KHz clock puts the
> -		   clock pulse width at 18us */

Why was this comment block dropped? The commit message makes no mention of it.


> +		.has_analog = 1,
>  		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
>  		.input = {
>  			{
> @@ -232,7 +228,7 @@ void au0828_card_analog_fe_setup(struct au0828_dev *dev)
>  	}
>  
>  	/* Setup tuners */
> -	if (dev->board.tuner_type != TUNER_ABSENT) {
> +	if (dev->board.tuner_type != TUNER_ABSENT && dev->board.has_analog) {

This tests against TUNER_ABSENT and, even after applying patch 2, the 'Unknown
Board' struct still specifies UNSET instead of TUNER_ABSENT. Can you change
that as well in patch 2?

This UNSET/TUNER_ABSENT confusion is similar to what I found in cx23885. I think
there are several drivers that are all inconsistent in how they handle this.

Regards,

	Hans

>  		/* Load the tuner module, which does the attach */
>  		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
>  				"tuner", dev->board.tuner_addr, NULL);
> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
> index 96bec05d7dac..20b82ba5be6c 100644
> --- a/drivers/media/usb/au0828/au0828.h
> +++ b/drivers/media/usb/au0828/au0828.h
> @@ -89,6 +89,7 @@ struct au0828_board {
>  	unsigned char tuner_addr;
>  	unsigned char i2c_clk_divider;
>  	unsigned char has_ir_i2c:1;
> +	unsigned char has_analog:1;
>  	struct au0828_input input[AU0828_MAX_INPUT];
>  
>  };
> 

