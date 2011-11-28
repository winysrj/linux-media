Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34762 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1K1Jl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 04:41:26 -0500
Received: by eaak14 with SMTP id k14so1615558eaa.19
        for <linux-media@vger.kernel.org>; Mon, 28 Nov 2011 01:41:25 -0800 (PST)
Message-ID: <4ED355A2.9090000@gmail.com>
Date: Mon, 28 Nov 2011 10:34:26 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-900 HD
References: <4ED00072.7070702@gmail.com> <CAGoCfiwHoVs0JQXchw-gA+0tZ2+1_nnj8P1qsP4XR-81iQis5g@mail.gmail.com> <4ED0EA25.1020901@gmail.com> <0ef2dae0-a014-4bcb-85c8-09c67fed156f@email.android.com>
In-Reply-To: <0ef2dae0-a014-4bcb-85c8-09c67fed156f@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/26/11 15:20, Andy Walls wrote:
> Fredrik Lingvall<fredrik.lingvall@gmail.com>  wrote:
>
>> On 11/25/11 23:14, Devin Heitmueller wrote:
>>> On Fri, Nov 25, 2011 at 3:54 PM, Fredrik Lingvall
>>> <fredrik.lingvall@gmail.com>   wrote:
>>>> Hi All,
>>>>
>>>> I have a Hauppauge HVR-900 HD with ID 2040:b138. Is this device
>> supported,
>>>> and if so, which driver and firmware do I need?
>>> Hi Frank,
>>>
>>> It's not currently supported under Linux as it uses a demodulator
>> that
>>> there is currently no driver for.  As far as I know, nobody's working
>>> on it.
>>>
>>> Regards,
>>>
>>> Devin
>>>
>> Thanks for the info Devin. I had some hope since I found this page:
>>
>>   http://forum.ubuntu-it.org/index.php/topic,423395.5/wap2.html
>>
>> The dmesg output at least shows much more than I have been able to get
>> (I use 3.2.0-rc3 from the linuxtv git rep). They seem to be able to at
>> least load firmware into the device. It's in Italian so I don't
>> understand much of what they are discussing though.
>>
>> /Fredrik
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> On that page they seem to have the unit recognized and a configuration for the analog side of the unit.  They also mention a Silabs SI2165 DVB-T/-C demodulator which is obviously not supported.
>
> Regards,
> Andy

They had a link to the code on the page:

http://misterox.altervista.org/cx231xx_drivers/newversion_cx231xx.tar.gz

I did a (quick) comparison with that code and the code that's in  
3.2.0-rc3. From what I could see it was not a quick fix to port it to 
3.2.0-rc3. I will look at it a bit more to see if I can get analog to 
work too (with 3.2.0-rc3).

/Fredrik


