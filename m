Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:40031 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LWOBJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Dec 2012 09:01:09 -0500
Received: by mail-ee0-f42.google.com with SMTP id c41so3130510eek.15
        for <linux-media@vger.kernel.org>; Sun, 23 Dec 2012 06:01:07 -0800 (PST)
Message-ID: <50D70EB6.3040409@googlemail.com>
Date: Sun, 23 Dec 2012 15:01:26 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 21/21] em28xx: add module parameter for selection of
 the preferred USB transfer type
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com> <1352398313-3698-22-git-send-email-fschaefer.oss@googlemail.com> <20121223114413.6d2c7dc1@redhat.com>
In-Reply-To: <20121223114413.6d2c7dc1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.12.2012 14:44, schrieb Mauro Carvalho Chehab:
> Hi Frank,
>
> Em Thu,  8 Nov 2012 20:11:53 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> By default, isoc transfers are used if possible.
>> With the new module parameter, bulk can be selected as the
>> preferred USB transfer type.
> I did some tests yesterday with prefer_bulk. IMHO, webcams should
> select bulk mode by default, as this allows more than one camera to
> work at the same time (I tested yesterday with 3 Silvercrest ones on
> my notebook). With ISOC transfers, the core won't let it to happen, as
> a single camera reserves 51% of the max allowed isoc traffic.

Ok. I just didn't want to change the current behavior because of
potential regressions.
Why not change it for all devices ? Frame data processing with bulk
transfers has a smaller overhead than with isoc (although not really
measurable ;) ).

I will send a patch after christmas.

>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-cards.c |   11 +++++++++--
>>  1 Datei geändert, 9 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
>> index a9344f0..7f5b303 100644
>> --- a/drivers/media/usb/em28xx/em28xx-cards.c
>> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
>> @@ -61,6 +61,11 @@ static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
>>  module_param_array(card,  int, NULL, 0444);
>>  MODULE_PARM_DESC(card,     "card type");
>>  
>> +static unsigned int prefer_bulk;
>> +module_param(prefer_bulk, int, 0644);
> This needs to be changed to 0444, as prefer_bulk doesn't allow changing
> it dynamically, as the test is done during device probe, not at stream on.

Good catch !
Can you fix it ? I'm a bit in hurry right now.
Otherwise I will try to send a patch tomorrow.

Merry Christmas !
Frank

>
> Regards,
> Mauro

