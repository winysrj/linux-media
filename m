Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50871 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935696AbdEVUqq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 16:46:46 -0400
Date: Mon, 22 May 2017 21:46:39 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 4/7] rc-core: sanyo - leave the internals of rc_dev alone
Message-ID: <20170522204639.GB22650@gofer.mess.org>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
 <149365501201.13489.12300860491124752633.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149365501201.13489.12300860491124752633.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 01, 2017 at 06:10:12PM +0200, David Härdeman wrote:
> Leave repeat handling to rc-core.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/ir-sanyo-decoder.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
> index 520bb77dcb62..e6a906a34f90 100644
> --- a/drivers/media/rc/ir-sanyo-decoder.c
> +++ b/drivers/media/rc/ir-sanyo-decoder.c
> @@ -110,13 +110,9 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  			break;
>  
>  		if (!data->count && geq_margin(ev.duration, SANYO_REPEAT_SPACE, SANYO_UNIT / 2)) {
> -			if (!dev->keypressed) {
> -				IR_dprintk(1, "SANYO discarding last key repeat: event after key up\n");
> -			} else {
> -				rc_repeat(dev);
> -				IR_dprintk(1, "SANYO repeat last key\n");
> -				data->state = STATE_INACTIVE;
> -			}
> +			rc_repeat(dev);
> +			IR_dprintk(1, "SANYO repeat last key\n");
> +			data->state = STATE_INACTIVE;

Same as the nec decoder: the original code checks whether there has been
a key up event already, so you don't get old scancodes repeated for no
reason.

>  			return 0;
>  		}
>  
