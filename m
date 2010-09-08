Return-path: <mchehab@pedra>
Received: from smtp1.Stanford.EDU ([171.67.219.81]:49377 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751164Ab0IHC1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 22:27:14 -0400
Message-ID: <4C86F210.2060605@stanford.edu>
Date: Tue, 07 Sep 2010 19:16:48 -0700
From: Eino-Ville Talvala <talvala@stanford.edu>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: eduardo.valentin@nokia.com,
	ext Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Illuminators and status LED controls
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>
In-Reply-To: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

 This is probably a bit OT, but these sorts of indicator LEDs can get quite complicated.

As part of our FCamera sample program on the Nokia N900 (which uses V4L2 way down there), we wanted to reprogram the front indicator LED to flash exactly when a picture is taken.  The N900 front LED is quite a programmable beast [1], with a dedicated microcontroller (the lp5521) that runs little programs that define the blink patterns for the RGB LED.

I'm not really suggesting that the V4L2 control should be able to handle this sort of an LED, but as these sorts of things get cheaper, it may become a case of 'why not?' for manufacturers putting in more complex RGB LEDs.   And if you don't want to encapsulate all that in V4L2, it may be better to leave it to other APIs at some point of complexity (the current lp5521 driver seems to have a sysfs-only interface for now for the programmable patterns, and the standard LED API otherwise)

[1] http://wiki.maemo.org/LED_patterns

Eino-Ville Talvala
Computer Graphics Lab
Stanford University

On 9/7/2010 1:33 PM, Andy Walls wrote:
> It has already been discussed.  Please check the list archives for the past few days.
>
> Do you know of any V4L2 application developer or development team that prefers to use a separate API just to turn lights on and off, when all other aspects of the incoming video are controlled with the V4L2 control API?
>
> (That question is mostly rhetorical, but I'd still actually be interested from video app developers.)
>
> Regards,
> Andy
>
> Eduardo Valentin <eduardo.valentin@nokia.com> wrote:
>
>> Hello,
>>
>> On Mon, Sep 06, 2010 at 08:11:05PM +0200, ext Jean-Francois Moine wrote:
>>> Hi,
>>>
>>> This new proposal cancels the previous 'LED control' patch.
>>>
>>> Cheers.
>>>
>>> -- 
>>> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
>>> Jef		|		http://moinejf.free.fr/
>> Apologies if this has been already discussed but,
>> doesn't this patch duplicates the same feature present
>> nowadays under include/linux/leds.h ??
>>
>> I mean, if you want to control leds, I think we already have that API, no?
>>
>> BR,
>>
>> ---
>> Eduardo Valentin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥

