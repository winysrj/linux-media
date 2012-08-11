Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab2HKUbX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 16:31:23 -0400
Message-ID: <5026C10F.6010600@redhat.com>
Date: Sat, 11 Aug 2012 17:31:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net
Subject: Re: [PATCH] [media] nec-decoder: fix NEC decoding for Pioneer Laserdisc
 CU-700 remote
References: <1343731049-9856-1-git-send-email-sean@mess.org>
In-Reply-To: <1343731049-9856-1-git-send-email-sean@mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-07-2012 07:37, Sean Young escreveu:
> This remote sends a header pulse of 8150us followed by a space of 4000us.

 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/ir-nec-decoder.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
> index 3c9431a..2ca509e 100644
> --- a/drivers/media/rc/ir-nec-decoder.c
> +++ b/drivers/media/rc/ir-nec-decoder.c
> @@ -70,7 +70,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		if (!ev.pulse)
>  			break;
>  
> -		if (eq_margin(ev.duration, NEC_HEADER_PULSE, NEC_UNIT / 2)) {
> +		if (eq_margin(ev.duration, NEC_HEADER_PULSE, NEC_UNIT * 2)) {
>  			data->is_nec_x = false;
>  			data->necx_repeat = false;
>  		} else if (eq_margin(ev.duration, NECX_HEADER_PULSE, NEC_UNIT / 2))
> @@ -86,7 +86,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		if (ev.pulse)
>  			break;
>  
> -		if (eq_margin(ev.duration, NEC_HEADER_SPACE, NEC_UNIT / 2)) {
> +		if (eq_margin(ev.duration, NEC_HEADER_SPACE, NEC_UNIT)) {
>  			data->state = STATE_BIT_PULSE;
>  			return 0;
>  		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
> 

The timings above are adjusted for 9000us/4500us, with a tolerance of 281,250us.
You're changing the pulse tolerance to 1125us for pulse, and 562,5us for space.

I double-checked: this shouldn't interfere with the other decoders, so it could
be possible to apply it, without causing regressions.

I'll apply it.

Regards,
Mauro
