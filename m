Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:55512 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751027AbdFVEui (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 00:50:38 -0400
Date: Thu, 22 Jun 2017 07:50:34 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] radio: wl1273: add check on core->write() return value
Message-ID: <20170622045034.tkyksrbdm353xmdu@tarshish>
References: <20170622040122.GA7161@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170622040122.GA7161@embeddedgus>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavi,

On Wed, Jun 21, 2017 at 11:01:22PM -0500, Gustavo A. R. Silva wrote:
> Check return value from call to core->write(), so in case of
> error print error message, jump to goto label fail and eventually
> return.
> 
> Addresses-Coverity-ID: 1226943
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/media/radio/radio-wl1273.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
> index 7240223..17e82a9 100644
> --- a/drivers/media/radio/radio-wl1273.c
> +++ b/drivers/media/radio/radio-wl1273.c
> @@ -610,10 +610,21 @@ static int wl1273_fm_start(struct wl1273_device *radio, int new_mode)
>  			}
>  		}
>  
> -		if (radio->rds_on)
> +		if (radio->rds_on) {
>  			r = core->write(core, WL1273_RDS_DATA_ENB, 1);
> -		else
> +			if (r) {
> +				dev_err(dev, "%s: RDS_DATA_ENB ON fails\n",
> +					__func__);
> +				goto fail;
> +			}
> +		} else {
>  			r = core->write(core, WL1273_RDS_DATA_ENB, 0);
> +			if (r) {
> +				dev_err(dev, "%s: RDS_DATA_ENB OFF fails\n",
> +					__func__);
> +				goto fail;
> +			}
> +		}
>  	} else {
>  		dev_warn(dev, "%s: Illegal mode.\n", __func__);
>  	}

An alternative that duplicates less code (untested):

	r = core->write(core, WL1273_RDS_DATA_ENB, !!radio->rds_on);
	if (r) {
		dev_err(dev, "%s: RDS_DATA_ENB %s fails\n",
		     	__func__, radio->rds_on ? "ON" : "OFF");
		goto fail;
	}

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
