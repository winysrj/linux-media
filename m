Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29293 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab2DCJ62 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 05:58:28 -0400
Message-ID: <4F7AC9B8.50200@linux.intel.com>
Date: Tue, 03 Apr 2012 12:58:16 +0300
From: David Cohen <david.a.cohen@linux.intel.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] fc0011: Reduce number of retries
References: <20120403110503.392c8432@milhouse>
In-Reply-To: <20120403110503.392c8432@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/03/2012 12:05 PM, Michael Büsch wrote:
> Now that i2c transfers are fixed, 3 retries are enough.
>
> Signed-off-by: Michael Buesch<m@bues.ch>
>
> ---
>
> Index: linux/drivers/media/common/tuners/fc0011.c
> ===================================================================
> --- linux.orig/drivers/media/common/tuners/fc0011.c	2012-04-03 08:48:39.000000000 +0200
> +++ linux/drivers/media/common/tuners/fc0011.c	2012-04-03 10:44:07.243418827 +0200
> @@ -314,7 +314,7 @@
>   	if (err)
>   		return err;
>   	vco_retries = 0;
> -	while (!(vco_cal&  FC11_VCOCAL_OK)&&  vco_retries<  6) {
> +	while (!(vco_cal&  FC11_VCOCAL_OK)&&  vco_retries<  3) {

Do we need to retry at all?
I2C core layer is responsible to retry is xfer() fails.
If failure is propagated to driver I'd assume:
  - I2C is still buggy by not return -EAGAIN on arbitrary error
  - I2C xfer failed for real.

Look this piece of code from i2c-core.c:

int i2c_transfer()
{
...
                 /* Retry automatically on arbitration loss */
                 orig_jiffies = jiffies;
                 for (ret = 0, try = 0; try <= adap->retries; try++) {
                         ret = adap->algo->master_xfer(adap, msgs, num);
                         if (ret != -EAGAIN)
                                 break;
                         if (time_after(jiffies, orig_jiffies + 
adap->timeout))
                                 break;
                 }
...
}

BR,

David

>   		/* Reset the tuner and try again */
>   		err = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
>   				   FC0011_FE_CALLBACK_RESET, priv->addr);
>
>

