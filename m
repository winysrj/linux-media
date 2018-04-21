Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56589 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752478AbeDUK1d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Apr 2018 06:27:33 -0400
Date: Sat, 21 Apr 2018 11:27:32 +0100
From: Sean Young <sean@mess.org>
To: Vladislav Zhurba <vzhurba@nvidia.com>
Cc: linux-kernel@vger.kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, Daniel Fu <danifu@nvidia.com>
Subject: Re: [PATCH 1/1] media: nec-decoder: remove trailer_space state
Message-ID: <20180421102732.5sbi6nzfu33b435m@gofer.mess.org>
References: <20180420185139.29238-1-vzhurba@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180420185139.29238-1-vzhurba@nvidia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 11:51:39AM -0700, Vladislav Zhurba wrote:
> From: Daniel Fu <danifu@nvidia.com>
> 
> Remove STATE_TRAILER_SPACE from state machine.
> Causing 2 issue:
> - can not decode the keycode, if it didn't following with
>   another keycode/repeat code
> - will generate one more code in current logic.
>   i.e. key_right + repeat code + key_left + repeat code.
>   expect: key_right, key_left.
>   Result: key_right, key_right, key_right.
>   Reason: when receive repeat code of key_right, state machine will
>   stay in STATE_TRAILER_SPACE state, then wait for a new interrupt,
>   if an interrupt came after keyup_timer, then will generate another
>   fake key.

This behaviour is symptomatic of rc driver which does not generate
ir timeouts. If an rc driver does not do this, then it won't be just the
nec protocol which is not parsed correctly. For example, rc-6 in mode 6a
can have 16, 24 or 32 bits and we rely on the ir timeout to demarcate the
end of the IR message -- else we are stuck with the behaviour as you
describe above.

> According to the NEC protocol, it don't need a trailer space. Remove it.

This isn't the right solution, so NAK I'm afraid. 

Please let us know what rc driver you are using, I'm happy to help fix it.


Sean

> 
> Signed-off-by: Daniel Fu <danifu@nvidia.com>
> Signed-off-by: Vladislav Zhurba <vzhurba@nvidia.com>
> ---
>  drivers/media/rc/ir-nec-decoder.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
> index 21647b809e6f..760b66affd1a 100644
> --- a/drivers/media/rc/ir-nec-decoder.c
> +++ b/drivers/media/rc/ir-nec-decoder.c
> @@ -128,16 +128,6 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		if (!eq_margin(ev.duration, NEC_TRAILER_PULSE, NEC_UNIT / 2))
>  			break;
>  
> -		data->state = STATE_TRAILER_SPACE;
> -		return 0;
> -
> -	case STATE_TRAILER_SPACE:
> -		if (ev.pulse)
> -			break;
> -
> -		if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
> -			break;
> -
>  		if (data->count == NEC_NBITS) {
>  			address     = bitrev8((data->bits >> 24) & 0xff);
>  			not_address = bitrev8((data->bits >> 16) & 0xff);
> -- 
> 2.16.2
