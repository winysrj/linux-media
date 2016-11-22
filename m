Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42739
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755807AbcKVNfN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 08:35:13 -0500
Date: Tue, 22 Nov 2016 11:35:06 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] [media] nec decoder: wrong bit order for nec32 protocol
Message-ID: <20161122113506.1a604721@vento.lan>
In-Reply-To: <1478708015-1164-5-git-send-email-sean@mess.org>
References: <1478708015-1164-5-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  9 Nov 2016 16:13:35 +0000
Sean Young <sean@mess.org> escreveu:

> The bits are sent in lsb first. Hardware decoders also send nec32
> in this order (e.g. dib0700). This should be consistent, however
> I have no way of knowing which order the LME2510 and Tivo keymaps
> are (the only two kernel keymaps with NEC32).

Hmm.. the lme2510 receives the scancode directly. So, this
patch shouldn't affect it. So, we're stuck with the Tivo IR.

On Tivo, only a few keys (with duplicated scancodes) don't start with
0xa10c. So, it *seems* that this is an address.

The best here would be to try to get a Tivo remote controller[1], and
do some tests with a driver that has a hardware decoder capable of
output NEC32 data, and some driver that receives raw IR data in
order to be sure.

In any case, we need to patch both the NEC32 decoder and the table
at the same time, to be 100% sure.

[1] or some universal remote controller that could emulate
the Tivo's scan codes. I suspect that the IR in question is
this one, but maybe Jarod could shed some light here:
	https://www.amazon.com/TiVo-Remote-Control-Universal-Replacement/dp/B00DYYKA04


> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/ir-nec-decoder.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
> index 2a9d155..ba02d05 100644
> --- a/drivers/media/rc/ir-nec-decoder.c
> +++ b/drivers/media/rc/ir-nec-decoder.c
> @@ -170,7 +170,10 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		if (send_32bits) {
>  			/* NEC transport, but modified protocol, used by at
>  			 * least Apple and TiVo remotes */
> -			scancode = data->bits;
> +			scancode = address     << 24 |
> +				   not_address << 16 |
> +				   command     << 8 |
> +				   not_command;
>  			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
>  			rc_type = RC_TYPE_NEC32;
>  		} else if ((address ^ not_address) != 0xff) {


Thanks,
Mauro
