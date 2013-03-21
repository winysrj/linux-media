Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:23137 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3CUKct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:32:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH 05/10] bttv: separate GPIO part from function audio_mux()
Date: Thu, 21 Mar 2013 11:32:46 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com> <1363807490-3906-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-6-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303211132.46337.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 20 March 2013 20:24:45 Frank Schäfer wrote:
> Move the GPIO part of function audio_mux() to a separate function
> audio_mux_gpio().
> This prepares the code for the next patch which will separate mute and input
> setting.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |   18 ++++++++++++------
>  1 Datei geändert, 12 Zeilen hinzugefügt(+), 6 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 81ee70d..f1cb0db 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -989,11 +989,10 @@ static char *audio_modes[] = {
>  	"audio: intern", "audio: mute"
>  };
>  
> -static int
> -audio_mux(struct bttv *btv, int input, int mute)
> +static void
> +audio_mux_gpio(struct bttv *btv, int input, int mute)
>  {
>  	int gpio_val, signal, mute_gpio;
> -	struct v4l2_ctrl *ctrl;
>  
>  	gpio_inout(bttv_tvcards[btv->c.type].gpiomask,
>  		   bttv_tvcards[btv->c.type].gpiomask);
> @@ -1020,8 +1019,14 @@ audio_mux(struct bttv *btv, int input, int mute)
>  
>  	if (bttv_gpio)
>  		bttv_gpio_tracking(btv, audio_modes[mute_gpio ? 4 : input]);
> -	if (in_interrupt())
> -		return 0;
> +}
> +
> +static int
> +audio_mux(struct bttv *btv, int input, int mute)
> +{
> +	struct v4l2_ctrl *ctrl;
> +
> +	audio_mux_gpio(btv, input, mute);
>  
>  	if (btv->sd_msp34xx) {
>  		u32 in;
> @@ -3846,7 +3851,8 @@ static irqreturn_t bttv_irq(int irq, void *dev_id)
>  			bttv_irq_switch_video(btv);
>  
>  		if ((astat & BT848_INT_HLOCK)  &&  btv->opt_automute)
> -			audio_mute(btv, btv->mute);  /* trigger automute */
> +			/* trigger automute */
> +			audio_mux_gpio(btv, btv->audio_input, btv->mute);
>  
>  		if (astat & (BT848_INT_SCERR|BT848_INT_OCERR)) {
>  			pr_info("%d: %s%s @ %08x,",
> 
