Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:41916 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab1EHQcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 12:32:41 -0400
Message-ID: <4DC6C5A5.3070409@infradead.org>
Date: Sun, 08 May 2011 13:32:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Manoel PN <pinusdtv@hotmail.com>
CC: linux-media@vger.kernel.org, Mauro Chehab <mchehab@redhat.com>,
	mpnbol@bol.com.br
Subject: Re: [PATCH] Various modifications to MB86A20S driver
References: <BLU157-w7FFBC4746E77A12455D92D8820@phx.gbl>
In-Reply-To: <BLU157-w7FFBC4746E77A12455D92D8820@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 07-05-2011 04:22, Manoel PN escreveu:
> Hi everyone,
> 
> I made several modifications on the driver for the MB86A20S demodulator and would like to receive comments regarding the modifications.
> 
> The modifications were necessary to allow the use of other drivers, as what I'm finishing for the device "TBS Media JH DTB08 USB2.0 ISDB-T".
> 
> Thanks for the comments, best regards,

Wow! huge changes! I'm currently travelling abroad without ISDB-T signal
here. I'll analyze and better comment your patch after my return. Anyway,
let me popup just two small thinks that come to me on a very quick look
on your patch:

>  config DVB_MB86A20S
> -    tristate "Fujitsu mb86a20s"
> +    tristate "Fujitsu MB86A20S"

Why? we generally use lowercase for device codes.
Please, don't change it.

> +static struct mb86a20s_config_regs_param mb86a20s_config_default[] = {
> +    { REG0001, 0x0d },    /* 0x0d */
> +    { REG0009, 0x3e },    /* 0x1a */

NACK. 

It makes no sense to rename for something as vague as "REG00001".
It would be ok if you had renamed, for someting with a meaning. Like, for example,
renaming reg 0x70 to something like: REG70_RESET_DEVICE

Also, please send renaming patches like that in separate, otherwise it becomes
really hard to discover what you've changed at the initialization sequence.

Thanks,
Mauro
