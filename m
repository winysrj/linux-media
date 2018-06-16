Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53546 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754034AbeFPJGc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Jun 2018 05:06:32 -0400
Date: Sat, 16 Jun 2018 12:06:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "JoonHwan.Kim" <spilit464@gmail.com>
Cc: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: staging: atomisp: add a blank line after
 declarations
Message-ID: <20180616090609.s5s4q2ri7e2x24oo@mwanda>
References: <2750553.3y1WJKmnP5@joonhwan-virtualbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2750553.3y1WJKmnP5@joonhwan-virtualbox>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 16, 2018 at 01:30:48PM +0900, JoonHwan.Kim wrote:
> @@ -1656,6 +1659,7 @@ static void atomisp_pause_buffer_event(struct atomisp_device *isp)
>  /* invalidate. SW workaround for this is to set burst length */
>  /* manually to 128 in case of 13MPx snapshot and to 1 otherwise. */
>  static void atomisp_dma_burst_len_cfg(struct atomisp_sub_device *asd)
> +
>  {

This isn't right.

regards,
dan carpenter
