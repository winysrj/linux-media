Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab0DTVWm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 17:22:42 -0400
Date: Tue, 20 Apr 2010 18:22:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 3/3] ir-core: add imon driver
Message-ID: <20100420182236.2e5a1325@pedra>
In-Reply-To: <20100416212902.GD2427@redhat.com>
References: <20100416212622.GA6888@redhat.com>
	<20100416212902.GD2427@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Apr 2010 17:29:02 -0400
Jarod Wilson <jarod@redhat.com> escreveu:

> 
> This is a new driver for the SoundGraph iMON and Antec Veris IR/display
> devices commonly found in many home theater pc cases and as after-market
> case additions.


> +/* IR protocol: native iMON, Windows MCE (RC-6), or iMON w/o PAD stabilize */
> +static int ir_protocol;
> +module_param(ir_protocol, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(ir_protocol, "Which IR protocol to use. 0=auto-detect, "
> +		 "1=Windows Media Center Ed. (RC-6), 2=iMON native, "
> +		 "4=iMON w/o PAD stabilize (default: auto-detect)");
> +

You don't need this. Let's the protocol to be adjustable via sysfs. All you need to do is
to use the set_protocol callbacks with something like:

        props->allowed_protos = IR_TYPE_RC6 | IR_TYPE_<imon protocol>;
        props->change_protocol = imon_ir_change_protocol;

You can see an example of such implementation at drivers/media/video/em28xx-em28xx-input.c.
Look for em28xx_ir_change_protocol() function.

That's said, I'm not sure what would be better way to map IR_TYPE_<imon protocol>. Maybe we
can just use IR_TYPE_OTHER.

So, basically, we'll have:

	IR_TYPE_OTHER | IR_TYPE_RC6	- auto-detected between RC-6 and iMON
	IR_TYPE_OTHER			- iMON proprietary protocol
	IR_TYPE_RC6			- RC-6 protocol


By doing this, the userspace application ir-keycode will already be able to handle the
IR protocol.

I'm not sure how to map the "PAD stablilize" case, but it seems that the better would be to
add a sysfs node for it, at sys/class/rc/rc0. There are other cases where some protocols
may require some adjustments, so I'm thinking on having some protocol-specific properties there.

Except for that, the patch looked sane to my eyes. So, I'll add it on my tree and wait for a
latter patch from you addressing the protocol control.

-- 

Cheers,
Mauro
