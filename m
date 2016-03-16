Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36543 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935240AbcCPW23 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 18:28:29 -0400
Date: Wed, 16 Mar 2016 22:28:26 +0000
From: Sean Young <sean@mess.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: reduce size of struct ir_raw_event
Message-ID: <20160316222826.GA6635@gofer.mess.org>
References: <56E9CDAE.2040200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56E9CDAE.2040200@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 16, 2016 at 10:18:38PM +0100, Heiner Kallweit wrote:
> struct ir_raw_event currently has a size of 12 bytes on most (all?)
> architectures. This can be reduced to 8 bytes whilst maintaining
> full backwards compatibility.
> This saves 2KB in size of struct ir_raw_event_ctrl (as element
> kfifo is reduced by 512 * 4 bytes) and it allows to copy the
> full struct ir_raw_event with a single 64 bit operation.
> 
> Successfully tested with the Nuvoton driver and successfully
> compile-tested with the ene_ir driver (as it uses the carrier /
> duty_cycle elements).
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  include/media/rc-core.h | 26 ++++++++------------------
>  1 file changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 0f77b3d..b8f27c9 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -214,27 +214,17 @@ enum raw_event_type {
>  
>  struct ir_raw_event {
>  	union {
> -		u32             duration;
> -
> -		struct {
> -			u32     carrier;
> -			u8      duty_cycle;
> -		};
> +		u32	duration;
> +		u32	carrier;
>  	};
> -
> -	unsigned                pulse:1;
> -	unsigned                reset:1;
> -	unsigned                timeout:1;
> -	unsigned                carrier_report:1;
> +	u8		duty_cycle;

Moving duty_cycle does indeed reduce the structure size from 12 to 8.

> +	u8		pulse:1;
> +	u8		reset:1;
> +	u8		timeout:1;
> +	u8		carrier_report:1;

Why are you changing the type of the bitfields? 

>  };
>  
> -#define DEFINE_IR_RAW_EVENT(event) \
> -	struct ir_raw_event event = { \
> -		{ .duration = 0 } , \
> -		.pulse = 0, \
> -		.reset = 0, \
> -		.timeout = 0, \
> -		.carrier_report = 0 }
> +#define DEFINE_IR_RAW_EVENT(event) struct ir_raw_event event = {}

Seems fine. I've always kinda wondered why this macro is needed.


Sean
