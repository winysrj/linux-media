Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64011 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaKYUp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 15:45:29 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so1942547wgg.19
        for <linux-media@vger.kernel.org>; Tue, 25 Nov 2014 12:45:28 -0800 (PST)
Message-ID: <5474EA63.7070408@gmail.com>
Date: Tue, 25 Nov 2014 20:45:23 +0000
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] lmed04: add missing breaks
References: <d442b15fb4deb2b5d516e2dae1f569b1d5472399.1416914348.git.mchehab@osg.samsung.com>	<5474B7E8.5020402@gmail.com> <20141125160033.4d613dd7@recife.lan>
In-Reply-To: <20141125160033.4d613dd7@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 25/11/14 18:00, Mauro Carvalho Chehab wrote:
> Em Tue, 25 Nov 2014 17:10:00 +0000
> Malcolm Priestley <malcolmpriestley@gmail.com> escreveu:
>
>> On 25/11/14 11:19, Mauro Carvalho Chehab wrote:
>>> drivers/media/usb/dvb-usb-v2/lmedm04.c:828 lme_firmware_switch() warn: missing break? reassigning 'st->dvb_usb_lme2510_firmware'
>>> drivers/media/usb/dvb-usb-v2/lmedm04.c:849 lme_firmware_switch() warn: missing break? reassigning 'st->dvb_usb_lme2510_firmware'
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>> diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
>>> index 9f2c5459b73a..99587418f4f0 100644
>>> --- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
>>> +++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
>>> @@ -826,6 +826,7 @@ static const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
>>>    				break;
>>>    			}
>>>    			st->dvb_usb_lme2510_firmware = TUNER_LG;
>>> +			break;
>>>    		case TUNER_LG:
>>>    			fw_lme = fw_lg;
>>>    			ret = request_firmware(&fw, fw_lme, &udev->dev);
>>> @@ -847,6 +848,7 @@ static const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
>>>    				break;
>>>    			}
>>>    			st->dvb_usb_lme2510_firmware = TUNER_LG;
>>> +			break;
>>>    		case TUNER_LG:
>>>    			fw_lme = fw_c_lg;
>>>    			ret = request_firmware(&fw, fw_lme, &udev->dev);
>>>
>> The break is not missing it's three lines above.
>>
>> All these switches are fall through until it finds firmware the user has.
>>
>> The switch comes into play when the firmware needs to changed.
>
> Oh! Well, I was so sure that the patch was right that I merged it already.
> My bad.
>
> Anyway, smatch complains if dvb_usb_lme2510_firmware is rewritten,
> and that bothers people that use static analyzers. So, IMO, the best
> is to rework the code in order to:
> - document that the breaks should not be used there;
> - remove smatch warning.
>
> What do you think about the following patch?

Fine

Acked-by: Malcolm Priestley <tvboxspy@gmail.com>
