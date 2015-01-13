Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:53516 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbbAMQNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 11:13:32 -0500
Received: by mail-lb0-f172.google.com with SMTP id z12so3403182lbi.3
        for <linux-media@vger.kernel.org>; Tue, 13 Jan 2015 08:13:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPx3zdSLb8gzcGTUcWrktc9icJBCCJ0FbPecxeUJRot3ztHwSA@mail.gmail.com>
References: <CAPx3zdRnHcQOasSjnYZkuE+Hk-L6PVaPVAzBbCMnGdM3ZysxFw@mail.gmail.com>
 <CAEt6MX=f-kkemgmAUNsEdZQzH2tRgtPDacbCn4hwH27uY-upDA@mail.gmail.com> <CAPx3zdSLb8gzcGTUcWrktc9icJBCCJ0FbPecxeUJRot3ztHwSA@mail.gmail.com>
From: =?UTF-8?Q?Roberto_Alc=C3=A2ntara?= <roberto@eletronica.org>
Date: Tue, 13 Jan 2015 13:13:09 -0300
Message-ID: <CAEt6MX=rmPAb798TysHDWHAQxpVxzKiaDNv4P9ZtUNPz2YEwpA@mail.gmail.com>
Subject: Re: Driver/module in kernel fault. Anyone expert to help me? Siano ID 187f:0600
To: Francesco Other <francesco.other@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good to know about DVB on this chip. This is sms2270 id :-)

I think you can get more  information from module debug messages.

Try
        options smsusb debug=3
on /etc/modprobe.d.

Then reload it and try to tzap one of channels found by scan to look
for some lock.  You will have more debug messages now.

Cheers,
 - Roberto




 - Roberto


On Tue, Jan 13, 2015 at 12:35 PM, Francesco Other
<francesco.other@gmail.com> wrote:
> Hi Roberto, thanks for your fast reply.
>
> I'm from Italy, a DVB-T region. With Windows the device works fine, it
> receives all the channels from multiplexes.
> I don't know if my device has the SMS2270 chip, I know the ID,
> 187f:0600, and the link on the Terratec site:
> http://www.terratec.net/details.php?artnr=145258#.VLU5Z2SG9LY
>
> In that site there are the software and the Windows driver, if you
> install those driver you can obtain the dvb_rio.inp driver from
> system32 folder.
> I forced the DVB-T mode because without it in dmesg output I see that
> system ask for isdbt_rio.inp, but with DVB-T forced mode the system
> ask for dvb_rio.inp.
>
> I can't understand why I can't receive any channels from multiplexes,
> the signal is ok, I can see this from many software (Kaffeine, w_scan,
> scan, TvHeadend).
>
> Can you help me please?
>
> Best Regards
>
> Francesco
>
>
> 2015-01-13 16:21 GMT+01:00 Roberto Alcântara <roberto@eletronica.org>:
>> Hi Francesco,
>>
>> You are using Siano SMS2270, am I right?
>>
>> My guess you're using ISDB-T firmware to program your ic, but are you in
>> ISDB-T region? I use same firmware name here and works fine (Brazil) and it
>> seems loaded ok on your log.
>>
>> I never saw an DVB firmware available to sms2270. Your tuner is working fine
>> under Windows with provided software ?
>>
>> Cheers,
>>   - Roberto
>>
>>
>>
>>
>>
>>
>>  - Roberto
>>
>> On Tue, Jan 13, 2015 at 11:50 AM, Francesco Other
>> <francesco.other@gmail.com> wrote:
>>>
>>> Is there a gentleman that can help me with my problem? On linuxtv.org
>>> they said that someone here sure will help me.
>>>
>>> I submitted the problem here:
>>> http://www.spinics.net/lists/linux-media/msg85432.html
>>>
>>> Regards
>>>
>>> Francesco
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
