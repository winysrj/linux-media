Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m08.mx.aol.com ([64.12.222.129]:49367 "EHLO
	omr-m08.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966789Ab3HIAKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 20:10:14 -0400
Message-ID: <5204311E.6070602@netscape.net>
Date: Thu, 08 Aug 2013 21:00:30 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC 0/3] Experimental patches for ISDB-T on Mygica X8502/X8507
References: <1375980712-9349-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1375980712-9349-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi


El 08/08/13 13:51, Mauro Carvalho Chehab escribió:
> This is a first set of experimental patches for Mygica X8502/X8507.
>
> The last patch is just a very dirty hack, for testing purposes. I intend
> to get rid of it, but it is there to replace exactly the same changes that
> Alfredo reported to work on Kernel 3.2.
>
> I intend to remove it on a final series, eventually replacing by some
> other changes at mb86a20s.
>
> Alfredo,
>
> Please test, and send your tested-by, if this works for you.

tested-by:  Alfredo Delaiti <alfredodelaiti@netscape.net>



two comments:

two  "breaks":

@@ -1106,6 +1112,8 @@ static int dvb_register(struct cx23885_tsport *port)
  				&i2c_bus2->i2c_adap,
  				&mygica_x8506_xc5000_config);
  		}
+		cx23885_set_frontend_hook(port, fe0->dvb.frontend);
+		break;
  		break;
  		

and I would add this on cx23885-cards.c (is not a patch):

     case CX23885_BOARD_MYGICA_X8506:
     case CX23885_BOARD_MAGICPRO_PROHDTVE2:
     case CX23885_BOARD_MYGICA_X8507:
         /* GPIO-0 (0)Analog / (1)Digital TV */
         /* GPIO-1 reset XC5000 */
-        /* GPIO-2 reset LGS8GL5 / LGS8G75 */
+        /* GPIO-2 reset LGS8GL5 / LGS8G75 / MB86A20S */
         cx23885_gpio_enable(dev, GPIO_0 | GPIO_1 | GPIO_2, 1);
         cx23885_gpio_clear(dev, GPIO_1 | GPIO_2);
         mdelay(100);
         cx23885_gpio_set(dev, GPIO_0 | GPIO_1 | GPIO_2);
         mdelay(100);
         break;


Thanks again Mauro,

Alfredo

>
> Thanks!
> Mauro
>
> Mauro Carvalho Chehab (3):
>    cx23885-dvb: use a better approach to hook set_frontend
>    cx23885: Add DTV support for Mygica X8502/X8507 boards
>    mb86a20s: hack it to emulate what x8502 driver does
>
>   drivers/media/dvb-frontends/mb86a20s.c    | 100 ++++++++++++++++++++++++++++++
>   drivers/media/pci/cx23885/Kconfig         |   1 +
>   drivers/media/pci/cx23885/cx23885-cards.c |   4 +-
>   drivers/media/pci/cx23885/cx23885-dvb.c   |  49 ++++++++++++---
>   drivers/media/pci/cx23885/cx23885.h       |   2 +
>   5 files changed, 147 insertions(+), 9 deletions(-)
>

