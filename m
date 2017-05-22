Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50245 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933464AbdEVUkc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 16:40:32 -0400
Date: Mon, 22 May 2017 21:40:30 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 3/7] rc-core: img-nec-decoder - leave the internals of
 rc_dev alone
Message-ID: <20170522204030.GA22650@gofer.mess.org>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
 <149365500692.13489.9572857464621441673.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149365500692.13489.9572857464621441673.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 01, 2017 at 06:10:06PM +0200, David Härdeman wrote:
> Obvious fix, leave repeat handling to rc-core
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/ir-nec-decoder.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
> index 3ce850314dca..75b9137f6faf 100644
> --- a/drivers/media/rc/ir-nec-decoder.c
> +++ b/drivers/media/rc/ir-nec-decoder.c
> @@ -88,13 +88,9 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  			data->state = STATE_BIT_PULSE;
>  			return 0;
>  		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
> -			if (!dev->keypressed) {
> -				IR_dprintk(1, "Discarding last key repeat: event after key up\n");
> -			} else {
> -				rc_repeat(dev);
> -				IR_dprintk(1, "Repeat last key\n");
> -				data->state = STATE_TRAILER_PULSE;
> -			}
> +			rc_repeat(dev);
> +			IR_dprintk(1, "Repeat last key\n");
> +			data->state = STATE_TRAILER_PULSE;

This is not correct. This means that whenever a nec repeat is received,
the last scancode is sent to the input device, irrespective of whether
there has been no IR for hours. The original code is stricter.

>  			return 0;
>  		}
>  
