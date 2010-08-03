Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0HCCB3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 22:01:29 -0400
Message-ID: <4C577888.30408@redhat.com>
Date: Mon, 02 Aug 2010 23:01:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Richard Zidlicky <rz@linux-m68k.org>
CC: linux-media@vger.kernel.org, udia@siano-ms.com,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH 3/6] V4L/DVB: smsusb: enable IR port for Hauppauge	WinTV
 MiniStick
References: <cover.1280693675.git.mchehab@redhat.com> <20100801171718.5ad62978@pedra> <20100802072711.GA5852@linux-m68k.org>
In-Reply-To: <20100802072711.GA5852@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Richard,

Em 02-08-2010 04:27, Richard Zidlicky escreveu:
> On Sun, Aug 01, 2010 at 05:17:18PM -0300, Mauro Carvalho Chehab wrote:
>> Add the proper gpio port for WinTV MiniStick, with the information provided
>> by Michael.
>>
>> Thanks-to: Michael Krufky <mkrufky@kernellabs.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/dvb/siano/sms-cards.c b/drivers/media/dvb/siano/sms-cards.c
>> index cff77e2..dcde606 100644
>> --- a/drivers/media/dvb/siano/sms-cards.c
>> +++ b/drivers/media/dvb/siano/sms-cards.c
>> @@ -67,6 +67,7 @@ static struct sms_board sms_boards[] = {
>>  		.board_cfg.leds_power = 26,
>>  		.board_cfg.led0 = 27,
>>  		.board_cfg.led1 = 28,
>> +		.board_cfg.ir = 9,
>                                ^^^^
> 
> are you sure about this?
> 
> I am using the value of 4 for the ir port and it definitely works.. confused.

I got this from a reliable source, and that worked perfectly  my with a Model 55009 
LF Rev B1F7. What's the model of your device?

> Thanks for looking at it, will test the patches as soon as I can.

I'd appreciate if you could test those patches, as the new implementation is feature-rich,
as it uses the in-kernel decoders via RC subsystem.
> 
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers,
Mauro
