Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:54111 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbeBTIH5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 03:07:57 -0500
Received: by mail-wm0-f67.google.com with SMTP id t74so19633793wme.3
        for <linux-media@vger.kernel.org>; Tue, 20 Feb 2018 00:07:56 -0800 (PST)
Subject: Re: [PATCH v2] [media] Use common error handling code in 20 functions
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        Sean Young <sean@mess.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Shyam Saini <mayhs11saini@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <weiyongjun1@huawei.com>
Cc: linux-media@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Brian Johnson <brijohn@gmail.com>,
        =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph@boehmwalder.at>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Daniele Nicolodi <daniele@grinta.net>,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Devendra Sharma <devendra.sharma9091@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Inki Dae <inki.dae@samsung.com>, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Mike Isely <isely@pobox.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <227d2d7c-5aee-1190-1624-26596a048d9c@users.sourceforge.net>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <fd7945f1-cdf5-932f-2fa4-c4144305fc11@linaro.org>
Date: Tue, 20 Feb 2018 10:07:52 +0200
MIME-Version: 1.0
In-Reply-To: <227d2d7c-5aee-1190-1624-26596a048d9c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Thank you for the patch.

On 19.02.2018 20:11, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 19 Feb 2018 18:50:40 +0100
> 
> Adjust jump targets so that a bit of exception handling can be better
> reused at the end of these functions.
> 
> This issue was partly detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> 
> v2:
> Hans Verkuil insisted on patch squashing. Thus several changes
> were recombined based on source files from Linux next-20180216.
> 
> The implementation of the function "tda8261_set_params" was improved
> after a notification by Christoph Böhmwalder on 2017-09-26.
> 
>  drivers/media/dvb-core/dmxdev.c                    | 16 ++++----
>  drivers/media/dvb-frontends/tda1004x.c             | 20 ++++++----
>  drivers/media/dvb-frontends/tda8261.c              | 19 ++++++----
>  drivers/media/pci/bt8xx/dst.c                      | 19 ++++++----
>  drivers/media/pci/bt8xx/dst_ca.c                   | 30 +++++++--------
>  drivers/media/pci/cx88/cx88-input.c                | 17 +++++----
>  drivers/media/platform/omap3isp/ispvideo.c         | 29 +++++++--------
>  .../media/platform/qcom/camss-8x16/camss-csid.c    | 20 +++++-----
>  drivers/media/tuners/tuner-xc2028.c                | 30 +++++++--------
>  drivers/media/usb/cpia2/cpia2_usb.c                | 13 ++++---
>  drivers/media/usb/gspca/gspca.c                    | 17 +++++----
>  drivers/media/usb/gspca/sn9c20x.c                  | 17 +++++----
>  drivers/media/usb/pvrusb2/pvrusb2-ioread.c         | 10 +++--
>  drivers/media/usb/tm6000/tm6000-cards.c            |  7 ++--
>  drivers/media/usb/tm6000/tm6000-dvb.c              | 11 ++++--
>  drivers/media/usb/tm6000/tm6000-video.c            | 13 ++++---
>  drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  | 13 +++----
>  drivers/media/usb/ttusb-dec/ttusb_dec.c            | 43 ++++++++--------------
>  drivers/media/usb/uvc/uvc_v4l2.c                   | 13 ++++---
>  19 files changed, 180 insertions(+), 177 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
> index 6d53af00190e..6a0411c91195 100644

<snip>

> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csid.c b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
> index 64df82817de3..92d4dc6b4a66 100644
> --- a/drivers/media/platform/qcom/camss-8x16/camss-csid.c
> +++ b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
> @@ -328,16 +328,12 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
>  			return ret;
>  
>  		ret = csid_set_clock_rates(csid);
> -		if (ret < 0) {
> -			regulator_disable(csid->vdda);
> -			return ret;
> -		}
> +		if (ret < 0)
> +			goto disable_regulator;
>  
>  		ret = camss_enable_clocks(csid->nclocks, csid->clock, dev);
> -		if (ret < 0) {
> -			regulator_disable(csid->vdda);
> -			return ret;
> -		}
> +		if (ret < 0)
> +			goto disable_regulator;
>  
>  		enable_irq(csid->irq);
>  
> @@ -345,8 +341,7 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
>  		if (ret < 0) {
>  			disable_irq(csid->irq);
>  			camss_disable_clocks(csid->nclocks, csid->clock);
> -			regulator_disable(csid->vdda);
> -			return ret;
> +			goto disable_regulator;
>  		}
>  
>  		hw_version = readl_relaxed(csid->base + CAMSS_CSID_HW_VERSION);
> @@ -357,6 +352,11 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
>  		ret = regulator_disable(csid->vdda);
>  	}
>  
> +	goto exit;

I think it will be cleaner if you remove the exit label and return here instead.

> +
> +disable_regulator:
> +	regulator_disable(csid->vdda);
> +exit:
>  	return ret;
>  }

-- 
Best regards,
Todor Tomov
