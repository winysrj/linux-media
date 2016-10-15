Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48695 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753523AbcJONn2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Oct 2016 09:43:28 -0400
Date: Sat, 15 Oct 2016 14:33:39 +0100
From: Sean Young <sean@mess.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 04/18] [media] RedRat3: One function call less in
 redrat3_transmit_ir() after error detection
Message-ID: <20161015133339.GB3393@gofer.mess.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
 <7878868c-bc54-5577-b808-ed096bbf3759@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7878868c-bc54-5577-b808-ed096bbf3759@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 13, 2016 at 06:24:46PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 13 Oct 2016 10:50:24 +0200
> 
> The kfree() function was called in one case by the
> redrat3_transmit_ir() function during error handling
> even if the passed variable contained a null pointer.
> 
> * Adjust jump targets according to the Linux coding style convention.
> 
> * Move the resetting for the data structure member "transmitting"
>   at the end.
> 
> * Delete initialisations for the variables "irdata" and "sample_lens"
>   at the beginning which became unnecessary with this refactoring.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/rc/redrat3.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
> index 7ae2ced..71e901d 100644
> --- a/drivers/media/rc/redrat3.c
> +++ b/drivers/media/rc/redrat3.c
> @@ -723,10 +723,10 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
>  {
>  	struct redrat3_dev *rr3 = rcdev->priv;
>  	struct device *dev = rr3->dev;
> -	struct redrat3_irdata *irdata = NULL;
> +	struct redrat3_irdata *irdata;
>  	int ret, ret_len;
>  	int lencheck, cur_sample_len, pipe;
> -	int *sample_lens = NULL;
> +	int *sample_lens;
>  	u8 curlencheck;
>  	unsigned i, sendbuf_len;
>  
> @@ -747,7 +747,7 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
>  	irdata = kzalloc(sizeof(*irdata), GFP_KERNEL);
>  	if (!irdata) {
>  		ret = -ENOMEM;
> -		goto out;
> +		goto free_sample;
>  	}
>  
>  	/* rr3 will disable rc detector on transmit */
> @@ -776,7 +776,7 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
>  				curlencheck++;
>  			} else {
>  				ret = -EINVAL;
> -				goto out;
> +				goto reset_member;
>  			}
>  		}
>  		irdata->sigdata[i] = lencheck;
> @@ -811,14 +811,12 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
>  		dev_err(dev, "Error: control msg send failed, rc %d\n", ret);
>  	else
>  		ret = count;
> -
> -out:
> -	kfree(irdata);
> -	kfree(sample_lens);
> -
> +reset_member:
>  	rr3->transmitting = false;
>  	/* rr3 re-enables rc detector because it was enabled before */
> -
> +	kfree(irdata);
> +free_sample:
> +	kfree(sample_lens);

In this error path, rr3->transmitting is not set to false so now the driver
will never allow you transmit again.

Also this patch does not apply against latest.

Sean

>  	return ret;
>  }
>  
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
