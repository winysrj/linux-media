Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:42881 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbbBKNao (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 08:30:44 -0500
To: david.cimburek@gmail.com
Subject: Re: [PATCH] media: Pinnacle 73e infrared control stopped working  since kernel 3.17
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 11 Feb 2015 14:24:38 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
In-Reply-To: <54D9E14A.5090200@iki.fi>
References: <CAEmZozMOenY096OwgMgdL27hizp8Z26PJ_ZZRsq0DyNpSZam-g@mail.gmail.com>
 <54D9E14A.5090200@iki.fi>
Message-ID: <e65f6b905eae37f11e697ad20b97c37c@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David C: are you using the in-kernel keymap or loading a custom one?

On 2015-02-10 11:45, Antti Palosaari wrote:
> David Härdeman,
> Could you look that as it is your patch which has broken it
> 
> commit af3a4a9bbeb00df3e42e77240b4cdac5479812f9
> Author: David Härdeman <david@hardeman.nu>
> Date:   Thu Apr 3 20:31:51 2014 -0300
> 
>     [media] dib0700: NEC scancode cleanup
> 
> 
> Antti
> 
> On 02/10/2015 12:38 PM, David Cimbůrek wrote:
>> Please include this patch to kernel! It takes too much time for such a
>> simple fix!
>> 
>> 
>> 2015-01-07 13:51 GMT+01:00 David Cimbůrek <david.cimburek@gmail.com>:
>>> No one is interested? I'd like to get this patch to kernel to fix the
>>> issue. Can someone here do it please?
>>> 
>>> 
>>> 2014-12-20 14:36 GMT+01:00 David Cimbůrek <david.cimburek@gmail.com>:
>>>> Hi,
>>>> 
>>>> with kernel 3.17 remote control for Pinnacle 73e (ID 2304:0237
>>>> Pinnacle Systems, Inc. PCTV 73e [DiBcom DiB7000PC]) does not work
>>>> anymore.
>>>> 
>>>> I checked the changes and found out the problem in commit
>>>> af3a4a9bbeb00df3e42e77240b4cdac5479812f9.
>>>> 
>>>> In dib0700_core.c in struct dib0700_rc_response the following union:
>>>> 
>>>> union {
>>>>      u16 system16;
>>>>      struct {
>>>>          u8 not_system;
>>>>          u8 system;
>>>>      };
>>>> };
>>>> 
>>>> has been replaced by simple variables:
>>>> 
>>>> u8 system;
>>>> u8 not_system;
>>>> 
>>>> But these variables are in reverse order! When I switch the order
>>>> back, the remote works fine again! Here is the patch:
>>>> 
>>>> 
>>>> --- a/drivers/media/usb/dvb-usr/dib0700_core.c    2014-12-20
>>>> 14:27:15.000000000 +0100
>>>> +++ b/drivers/media/usb/dvb-usr/dib0700_core.c    2014-12-20
>>>> 14:27:36.000000000 +0100
>>>> @@ -658,8 +658,8 @@
>>>>   struct dib0700_rc_response {
>>>>       u8 report_id;
>>>>       u8 data_state;
>>>> -    u8 system;
>>>>       u8 not_system;
>>>> +    u8 system;
>>>>       u8 data;
>>>>       u8 not_data;
>>>>   };
>>>> 
>>>> 
>>>> Regards,
>>>> David
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
