Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:35587 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbZGUAHg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 20:07:36 -0400
Subject: Re: ir-kbd-i2c: Drop irrelevant inline keywords
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>
In-Reply-To: <20090719145936.0c21917f@hyperion.delvare>
References: <20090719145936.0c21917f@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 20:09:44 -0400
Message-Id: <1248134984.3148.78.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-07-19 at 14:59 +0200, Jean Delvare wrote:
> Functions which are referenced by their address can't be inlined by
> definition.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>

Jean,

Looks godd to me, but you forgot to add [PATCH] to the subject.  I'll
add this one to my revised patch set I submit to the list, unless you
object.

Regards,
Andy

> ---
>  linux/drivers/media/video/ir-kbd-i2c.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- v4l-dvb.orig/linux/drivers/media/video/ir-kbd-i2c.c	2009-07-19 14:30:29.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/ir-kbd-i2c.c	2009-07-19 14:50:30.000000000 +0200
> @@ -127,12 +127,12 @@ static int get_key_haup_common(struct IR
>  	return 1;
>  }
>  
> -static inline int get_key_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
> +static int get_key_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>  {
>  	return get_key_haup_common (ir, ir_key, ir_raw, 3, 0);
>  }
>  
> -static inline int get_key_haup_xvr(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
> +static int get_key_haup_xvr(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>  {
>  	return get_key_haup_common (ir, ir_key, ir_raw, 6, 3);
>  }
> 
> 

