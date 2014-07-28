Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:44338 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaG1TMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 15:12:12 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9F00KT8S0A0450@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Jul 2014 15:12:10 -0400 (EDT)
Date: Mon, 28 Jul 2014 16:12:06 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Raymond Jender <rayj00@yahoo.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/4] au0828: add support for IR decoding
Message-id: <20140728161206.63a13011.m.chehab@samsung.com>
In-reply-to: <1406572808.32558.YahooMailNeo@web162403.mail.bf1.yahoo.com>
References: <1406570842-26316-1-git-send-email-m.chehab@samsung.com>
 <1406572808.32558.YahooMailNeo@web162403.mail.bf1.yahoo.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nobody can help you at the ML. AFAIKT, none of the VGER admins subscribe this
list.

Yet, the procedure is very simple for you to do... just send an email to
the VGER robot (majordomo@vger.kernel.org) from the e-mail you're subscribed
with:

	unsubscribe linux-media

on its body. No need to add a subject to such email. It will send you a
confirmation e-mail. Reply to it with the authentication ID provided
by the robot and you'll be unsubscribed.

Regards,
Mauro

Em Mon, 28 Jul 2014 11:40:08 -0700
Raymond Jender <rayj00@yahoo.com> escreveu:

> Reading the FAQ page,  there are a ton of things not to do  in this list but only one thing to do if you don't want this list anymore and it doesn't fucking work!
> 
> Get me the fuck off of this list.....somebody??
> 
> 
> 
> 
> On Monday, July 28, 2014 11:11 AM, Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
>  
> 
> 
> au0828 chipset have a built-in IR decoder, at au8522. Add
> support for it to decode both NEC and RC5 protocols.
> 
> Unfortunately, it is not possible to have a fully generic
> IR decode, as this chipset is not able to detect the initial
> pulse.
> 
> Mauro Carvalho Chehab (4):
>   au0828: improve I2C speed
>   rc-main: allow raw protocol drivers to restrict the allowed protos
>   au0828: add support for IR on HVR-950Q
>   ir-rc5-decoder: print the failed count
> 
> drivers/media/rc/ir-rc5-decoder.c       |   4 +-
> drivers/media/rc/rc-main.c              |   5 +-
> drivers/media/usb/au0828/Kconfig        |   7 +
> drivers/media/usb/au0828/Makefile       |   4 +
> drivers/media/usb/au0828/au0828-cards.c |   7 +-
> drivers/media/usb/au0828/au0828-core.c  |  25 +-
> drivers/media/usb/au0828/au0828-i2c.c   |  23 +-
> drivers/media/usb/au0828/au0828-input.c | 391 ++++++++++++++++++++++++++++++++
> drivers/media/usb/au0828/au0828.h       |  11 +
> 9 files changed, 455 insertions(+), 22 deletions(-)
> create mode 100644 drivers/media/usb/au0828/au0828-input.c
> 
