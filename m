Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:43891 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966645Ab3HINYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 09:24:16 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MR9008TWMK1NS40@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 Aug 2013 09:24:15 -0400 (EDT)
Date: Fri, 09 Aug 2013 10:24:10 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Alfredo =?UTF-8?B?SmVzw7pz?= Delaiti <alfredodelaiti@netscape.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC 0/3] Experimental patches for ISDB-T on Mygica
 X8502/X8507
Message-id: <20130809102410.73d896de@samsung.com>
In-reply-to: <5204311E.6070602@netscape.net>
References: <1375980712-9349-1-git-send-email-m.chehab@samsung.com>
 <5204311E.6070602@netscape.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 08 Aug 2013 21:00:30 -0300
Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:

> Hi
> 
> 
> El 08/08/13 13:51, Mauro Carvalho Chehab escribió:
> > This is a first set of experimental patches for Mygica X8502/X8507.
> >
> > The last patch is just a very dirty hack, for testing purposes. I intend
> > to get rid of it, but it is there to replace exactly the same changes that
> > Alfredo reported to work on Kernel 3.2.
> >
> > I intend to remove it on a final series, eventually replacing by some
> > other changes at mb86a20s.
> >
> > Alfredo,
> >
> > Please test, and send your tested-by, if this works for you.
> 
> tested-by:  Alfredo Delaiti <alfredodelaiti@netscape.net>
> 
> 
> 
> two comments:
> 
> two  "breaks":
> 
> @@ -1106,6 +1112,8 @@ static int dvb_register(struct cx23885_tsport *port)
>   				&i2c_bus2->i2c_adap,
>   				&mygica_x8506_xc5000_config);
>   		}
> +		cx23885_set_frontend_hook(port, fe0->dvb.frontend);
> +		break;
>   		break;
>   		
> 
> and I would add this on cx23885-cards.c (is not a patch):
> 
>      case CX23885_BOARD_MYGICA_X8506:
>      case CX23885_BOARD_MAGICPRO_PROHDTVE2:
>      case CX23885_BOARD_MYGICA_X8507:
>          /* GPIO-0 (0)Analog / (1)Digital TV */
>          /* GPIO-1 reset XC5000 */
> -        /* GPIO-2 reset LGS8GL5 / LGS8G75 */
> +        /* GPIO-2 reset LGS8GL5 / LGS8G75 / MB86A20S */
>          cx23885_gpio_enable(dev, GPIO_0 | GPIO_1 | GPIO_2, 1);
>          cx23885_gpio_clear(dev, GPIO_1 | GPIO_2);
>          mdelay(100);
>          cx23885_gpio_set(dev, GPIO_0 | GPIO_1 | GPIO_2);
>          mdelay(100);
>          break;
> 
> 
> Thanks again Mauro,

Thank you for your tests. I just pushed a new patch series addressing the
above, and getting rid of the horrible mb86a20s hack.

Please test it again, to see if the mb86a20s fixes also worked for you.

Thanks!
Mauro
