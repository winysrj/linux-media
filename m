Return-path: <mchehab@pedra>
Received: from gateway14.websitewelcome.com ([69.93.154.35]:57847 "HELO
	gateway14.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753064Ab0JGQms (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 12:42:48 -0400
Subject: Re: [PATCH 04/16] go7007: Fix the TW2804 I2C type name
From: Pete Eberlein <pete@sensoray.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1285337654-5044-5-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1285337654-5044-5-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 09:33:11 -0700
Message-ID: <1286469191.2477.10.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Acked-by: Pete Eberlein <pete@sensoray.com>

On Fri, 2010-09-24 at 16:14 +0200, Laurent Pinchart wrote:
> The TW2804 I2C sub-device type name was incorrectly set to wis_twTW2804
> for the adlink mpg24 board. Rename it to wis_tw2804.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/staging/go7007/go7007-usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/go7007/go7007-usb.c b/drivers/staging/go7007/go7007-usb.c
> index 20ed930..bea9f4d 100644
> --- a/drivers/staging/go7007/go7007-usb.c
> +++ b/drivers/staging/go7007/go7007-usb.c
> @@ -394,7 +394,7 @@ static struct go7007_usb_board board_adlink_mpg24 = {
>  		.num_i2c_devs	 = 1,
>  		.i2c_devs	 = {
>  			{
> -				.type	= "wis_twTW2804",
> +				.type	= "wis_tw2804",
>  				.id	= I2C_DRIVERID_WIS_TW2804,
>  				.addr	= 0x00, /* yes, really */
>  			},


