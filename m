Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39127 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbbBJKpe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2015 05:45:34 -0500
Message-ID: <54D9E14A.5090200@iki.fi>
Date: Tue, 10 Feb 2015 12:45:30 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgQ2ltYsWvcmVr?= <david.cimburek@gmail.com>,
	linux-media@vger.kernel.org,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
Subject: Re: [PATCH] media: Pinnacle 73e infrared control stopped working
 since kernel 3.17
References: <CAEmZozMOenY096OwgMgdL27hizp8Z26PJ_ZZRsq0DyNpSZam-g@mail.gmail.com>
In-Reply-To: <CAEmZozMOenY096OwgMgdL27hizp8Z26PJ_ZZRsq0DyNpSZam-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Härdeman,
Could you look that as it is your patch which has broken it

commit af3a4a9bbeb00df3e42e77240b4cdac5479812f9
Author: David Härdeman <david@hardeman.nu>
Date:   Thu Apr 3 20:31:51 2014 -0300

     [media] dib0700: NEC scancode cleanup


Antti

On 02/10/2015 12:38 PM, David Cimbůrek wrote:
> Please include this patch to kernel! It takes too much time for such a
> simple fix!
>
>
> 2015-01-07 13:51 GMT+01:00 David Cimbůrek <david.cimburek@gmail.com>:
>> No one is interested? I'd like to get this patch to kernel to fix the
>> issue. Can someone here do it please?
>>
>>
>> 2014-12-20 14:36 GMT+01:00 David Cimbůrek <david.cimburek@gmail.com>:
>>> Hi,
>>>
>>> with kernel 3.17 remote control for Pinnacle 73e (ID 2304:0237
>>> Pinnacle Systems, Inc. PCTV 73e [DiBcom DiB7000PC]) does not work
>>> anymore.
>>>
>>> I checked the changes and found out the problem in commit
>>> af3a4a9bbeb00df3e42e77240b4cdac5479812f9.
>>>
>>> In dib0700_core.c in struct dib0700_rc_response the following union:
>>>
>>> union {
>>>      u16 system16;
>>>      struct {
>>>          u8 not_system;
>>>          u8 system;
>>>      };
>>> };
>>>
>>> has been replaced by simple variables:
>>>
>>> u8 system;
>>> u8 not_system;
>>>
>>> But these variables are in reverse order! When I switch the order
>>> back, the remote works fine again! Here is the patch:
>>>
>>>
>>> --- a/drivers/media/usb/dvb-usr/dib0700_core.c    2014-12-20
>>> 14:27:15.000000000 +0100
>>> +++ b/drivers/media/usb/dvb-usr/dib0700_core.c    2014-12-20
>>> 14:27:36.000000000 +0100
>>> @@ -658,8 +658,8 @@
>>>   struct dib0700_rc_response {
>>>       u8 report_id;
>>>       u8 data_state;
>>> -    u8 system;
>>>       u8 not_system;
>>> +    u8 system;
>>>       u8 data;
>>>       u8 not_data;
>>>   };
>>>
>>>
>>> Regards,
>>> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
http://palosaari.fi/
