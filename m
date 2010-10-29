Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:65410 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932900Ab0J2WO7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 18:14:59 -0400
Subject: Re: [RFC PATCH 1/2] ir-nec-decoder: decode Apple's NEC remote
 variant
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20101029031319.GF17238@redhat.com>
References: <20101029031131.GE17238@redhat.com>
	 <20101029031319.GF17238@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 18:15:16 -0400
Message-ID: <1288390516.2387.27.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2010-10-28 at 23:13 -0400, Jarod Wilson wrote:
> Apple's remotes use an NEC-like protocol, but without checksumming. See
> http://en.wikipedia.org/wiki/Apple_Remote for details. Since they always
> send a specific vendor code, check for that, and bypass the checksum
> check.

Jarrod,

This is kind of icky.

According to the Wikipedia article, the Apple remote is use the NEC
protocol's physical (PHY) layer, but it's using a different datalink
(DL) layer.

I say the data link layers are different, because the target device
address bytes are in different places and the command payload differs:

NEC bytes are:   Addr Addr' Command Command'
Apple bytes are: 0xee 0x87  Command ID


In NEC "Addr" is used to address a particular device (TV model, VCR
model, etc.) which in the Apple protocol seems to be the function of ID.

Maybe the Apple remote protocol just needs it's own decoder.  That way
the Apple rc-map can just ignore the ID bytes (or maybe make it a user
configurable option to ignore).

Or, if you really want to work, split up PHY vs DL layer in the ir
protocol decoders. ;) 

Regards,
Andy



> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  drivers/media/IR/ir-nec-decoder.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
> index 70993f7..6dcddd2 100644
> --- a/drivers/media/IR/ir-nec-decoder.c
> +++ b/drivers/media/IR/ir-nec-decoder.c
> @@ -50,6 +50,7 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
>  	struct nec_dec *data = &ir_dev->raw->nec;
>  	u32 scancode;
>  	u8 address, not_address, command, not_command;
> +	bool apple = false;
>  
>  	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_NEC))
>  		return 0;
> @@ -158,7 +159,14 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
>  		command	    = bitrev8((data->bits >>  8) & 0xff);
>  		not_command = bitrev8((data->bits >>  0) & 0xff);
>  
> -		if ((command ^ not_command) != 0xff) {
> +		/* Apple remotes use an NEC-like proto, but w/o a checksum */
> +		if ((address == 0xee) && (not_address == 0x87)) {
> +			apple = true;
> +			IR_dprintk(1, "Apple remote, ID byte 0x%02x\n",
> +				   not_command);
> +		}
> +
> +		if (((command ^ not_command) != 0xff) && !apple) {
>  			IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
>  				   data->bits);
>  			break;
> -- 
> 1.7.1
> 
> 


