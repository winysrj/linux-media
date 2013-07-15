Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3GOUa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 16:30:56 -0400
Date: Tue, 16 Jul 2013 05:30:30 +0900
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alfredo =?UTF-8?B?SmVzw7pz?= Delaiti <alfredodelaiti@netscape.net>
Cc: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
Message-ID: <20130716053030.3fda034e.mchehab@infradead.org>
In-Reply-To: <51E44DCA.8060702@netscape.net>
References: <51054759.7050202@netscape.net>
	<20130127141633.5f751e5d@redhat.com>
	<5105A0C9.6070007@netscape.net>
	<20130128082354.607fae64@redhat.com>
	<5106E3EA.70307@netscape.net>
	<511264CF.3010002@netscape.net>
	<51336331.10205@netscape.net>
	<20130303134051.6dc038aa@redhat.com>
	<20130304164234.18df36a7@redhat.com>
	<51353591.4040709@netscape.net>
	<20130304233028.7bc3c86c@redhat.com>
	<513A6968.4070803@netscape.net>
	<515A0D03.7040802@netscape.net>
	<51E44DCA.8060702@netscape.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 15 Jul 2013 16:30:18 -0300
Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:

> Hi all
> 
> After some time trying to see what the problem is, I have found it is 
> not come the RF signal.
> 
> I've gone back using a 3.2 kernel, after doing a couple of tests, the 
> board works :-)
> When I try to apply these changes to a 3.4 or later kernel does not tune 
> plate.
> 
> Between 3.2 and 3.4 kernel there are several changes to the drivers: 
> CX23885, xc5000 and mb86a20s. I tried to cancel several of them on a 3.4 
> kernel, but I can not make the card tune.

If you know already that the breakage happened between 3.2 and 3.4, the better
is to use git bisect to discover what patch broke it.

You can do (using Linus git tree):

	git checkout v3.4
	git bisect bad
	git checkout good v3.2

git bisect will then do a binary search between those two kernels. All you
have to do is to recompile the Kernel and test it. Then you'll tag the
changeset as "bad" or "good", until the end of the search. In general, you'll
discover the changeset responsible for the breakage after a few (8-10) 
interactions.

For more reference, you can take a look, for example, at:
	http://git-scm.com/book/en/Git-Tools-Debugging-with-Git

Regards,
Mauro

PS.: Someone should fix our wiki, as it is still pointing to hg bisect,
instead of pointing to git bisect.

> 
> The changes I have applied to kernel 3.2 are:
> 
> In mb86a20s.c, I replaced the table "mb86a20s_init" for which I got from 
> windows and linux last.
> With the two works, although it seems better that I got from Windows, I 
> have to experiment a bit more.
> Also in "Does a binary search to get RF strength"  I replaced 0x04 for 0x05.
> 
> On cx23885-card.c
>          .name         = "Mygica X8507",
>          .tuner_type     = TUNER_XC5000,
>          .tuner_addr     = 0x61,
>          .tuner_bus     = 1,
>          .porta         = CX23885_ANALOG_VIDEO,
> +        .portb        = CX23885_MPEG_DVB,
>          .input         = {
> 
> 
> 
>        case CX23885_BOARD_MYGICA_X8506:
>      case CX23885_BOARD_MAGICPRO_PROHDTVE2:
> +    case CX23885_BOARD_MYGICA_X8507:
>          ts1->gen_ctrl_val  = 0x5; /* Parallel */
>          ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
>          ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
>          break;
> 
> On cx23885-dvb.c
> 
>   #include "stv0367.h"
> +#include "mb86a20s.h"
> 
> +static struct mb86a20s_config mygica_x8507_mb86a20s_config = {
> +    .demod_address = 0x10,
> +};
> +
> +static struct xc5000_config mygica_x8507_xc5000_config = {
> +    .i2c_address = 0x61,
> +    .if_khz = 4000,
> +};
> 
>      case CX23885_BOARD_MYGICA_X8506:
>      case CX23885_BOARD_MAGICPRO_PROHDTVE2:
> +    case CX23885_BOARD_MYGICA_X8507:
>          /* Select Digital TV */
>          cx23885_gpio_set(dev, GPIO_0);
>          break;
> 
> +    case CX23885_BOARD_MYGICA_X8507:
> +        i2c_bus = &dev->i2c_bus[0];
> +        i2c_bus2 = &dev->i2c_bus[1];
> +        fe0->dvb.frontend = dvb_attach(mb86a20s_attach,
> +            &mygica_x8507_mb86a20s_config,
> +            &i2c_bus->i2c_adap);
> +        if (fe0->dvb.frontend != NULL) {
> +            dvb_attach(xc5000_attach,
> +                fe0->dvb.frontend,
> +                &i2c_bus2->i2c_adap,
> +                &mygica_x8507_xc5000_config);
> +        }
> +        break;
> 
> 
> With kernel 3.4 or greater (I also tried with the latest drivers from 
> git) "looking" i2c bus traffic of mb86a20s I get:
> 
> 0x20 0x0a 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x07 0x20 0x04 0x20 0x20 0x05 0xff 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x03 0x20 0x04 0x20 0x20 0x05 0xff 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x01 0x20 0x04 0x20 0x20 0x05 0xff 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0xff 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x7f 0x20 0x04 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x3f 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x1f 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x0f 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x07 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x03 0x20 0x02 
> 0x21 0x0a
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x05 0x20 0x02 
> 0x21 0x0a
> 0x20 0x0a 0x21 0x02
> 
> and the kernel 3.2 and windows
> 
> 0x20 0x02 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x03 0x20 0x04 0x20 0x20 0x05 0xff 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x01 0x20 0x04 0x20 0x20 0x05 0xff 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0xff 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x7f 0x20 0x02 
> 0x21 0x0a
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0xbf 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x9f 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x3c 0x40 0x04 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x87 0x20 0x02 
> 0x21 0x02
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x83 0x20 0x02 
> 0x21 0x0a
> 0x20 0x04 0x1f 0x20 0x05 0x00 0x20 0x04 0x20 0x20 0x05 0x85 0x20 0x02 
> 0x21 0x02
> 
> Appear not arrived RF signal.
> 
>  From my limited knowledge I can not understand which of the changes 
> between 3.2 and 3.4 kernel affect this.
> 
> As with kernel 3.2 works, discard configuration problems of: GPIO, 
> signal strength, direction i2c bus  and  demodulator and intermediate 
> frequency. I am right?
> 
> 
> Any suggestions or help is very welcome.
> 
> Thanks in advance,
> 
> Alfredo




Cheers,
Mauro
