Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43553 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbBLXia (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2015 18:38:30 -0500
From: luis@debethencourt.com
Date: Thu, 12 Feb 2015 23:38:26 +0000
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, david@hardeman.nu,
	james.harper@ejbdigital.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dib0700: remove unused macros
Message-ID: <20150212233826.GA10015@turing>
References: <20150212221147.GA12614@turing>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150212221147.GA12614@turing>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 12, 2015 at 10:11:47PM +0000, Luis de Bethencourt wrote:
> Remove unused macros RC_REPEAT_DELAY and RC_REPEAT_DELAY_V1_20
> 
> Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
> ---
>  drivers/media/usb/dvb-usb/dib0700_core.c    | 3 ---
>  drivers/media/usb/dvb-usb/dib0700_devices.c | 3 ---
>  2 files changed, 6 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
> index 50856db..2b40393 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_core.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_core.c
> @@ -651,9 +651,6 @@ out:
>  	return ret;
>  }
>  
> -/* Number of keypresses to ignore before start repeating */
> -#define RC_REPEAT_DELAY_V1_20 10
> -
>  /* This is the structure of the RC response packet starting in firmware 1.20 */
>  struct dib0700_rc_response {
>  	u8 report_id;
> diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
> index e1757b8..d7d55a2 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_devices.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
> @@ -510,9 +510,6 @@ static int stk7700ph_tuner_attach(struct dvb_usb_adapter *adap)
>  
>  static u8 rc_request[] = { REQUEST_POLL_RC, 0 };
>  
> -/* Number of keypresses to ignore before start repeating */
> -#define RC_REPEAT_DELAY 6
> -
>  /*
>   * This function is used only when firmware is < 1.20 version. Newer
>   * firmwares use bulk mode, with functions implemented at dib0700_core,
> -- 
> 2.1.0
> 

For some context, the only usage of macro RC_REPEAT_DELAY_V1_20 was removed in
commit 72b393106bddc9f0a1ab502b4c8c5793a0441a30

And the last usage of macro RC_REPEAT_DELAY was removed in commit
72b393106bddc9f0a1ab502b4c8c5793a0441a30

Thanks,
Luis
