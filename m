Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37216 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab3G2Tdf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 15:33:35 -0400
Message-ID: <51F6C364.105@iki.fi>
Date: Mon, 29 Jul 2013 22:32:52 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Torsten Seyffarth <t.seyffarth@gmx.de>
CC: Jan Taegert <jantaegert@gmx.net>, linux-media@vger.kernel.org,
	thomas.mair86@googlemail.com
Subject: Re: PROBLEM: dvb-usb-rtl28xxu and Terratec Cinergy TStickRC (rev3)
 - no signal on some frequencies
References: <51E927EC.5030701@gmx.net> <51E92A78.50706@iki.fi> <51E974DB.7010609@gmx.net> <51ED9F8F.10206@iki.fi> <51EFDF55.90500@iki.fi> <51F56476.1090203@gmx.de>
In-Reply-To: <51F56476.1090203@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I don't want to read any random logs. It is just like looking for a 
needle in a haystack. Waste of time.

I wrote a blog post and published my rtl2832u 
reverse-engineering/hacking scripts. Try to follow those:
http://blog.palosaari.fi/2013/07/generating-rtl2832u-driver-code.html

regards
Antti

On 07/28/2013 09:35 PM, Torsten Seyffarth wrote:
> Hello Antti,
>
> Unfortunately the patch doesn't work for me either. Would it help you if
> I send you an usb sniff with wireshark of an program search run with
> kaffeine (27 MB)?
>
> regards
> Torsten
>
>
> Am 24.07.2013 16:06, schrieb Antti Palosaari:
>> Could you test attached patch?
>>
>> It enhances reception a little bit, you should be able to receive more
>> weak signals.
>>
>> I was able to made test setup against modulator. Modulator +
>> attenuator + attenuator + TV-stick, where I got picture using Windows
>> driver at signal level -29dBm whilst on Linux -26.5dBm was needed.
>> With that patch Linux driver started performing same as Windows.
>>
>> regards
>> Antti
>>
>> On 07/23/2013 12:09 AM, Antti Palosaari wrote:
>>> On 07/19/2013 08:18 PM, Jan Taegert wrote:
>>>> Hello,
>>>>
>>>> when the culprit is the e4000 driver but the old driver from
>>>> https://github.com/valtri/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0
>>>>
>>>>
>>>> worked for me, then must be somewhere there in the driver sources a
>>>> solution for the signal issues.
>>>>
>>>> Does it make sense to look for a particular string in the sources? I
>>>> don't have any clue of coding but perhaps I can be helpful in this way.
>>>
>>> Feel free to look. Those are different drivers and you cannot compare
>>> easily. For my experience you will need huge amount of time and much
>>> luck with that approach.
>>>
>>> As I said, the easiest solution is just to took sniffs and copy&paste
>>> generated code until it starts working.
>>>
>>> regards
>>> Antti
>>>
>>>>
>>>> There are
>>>> - tuner_e4000.c
>>>> - nim_rtl2832_e4000.c
>>>>
>>>> Thanks,
>>>> Jan.
>>>>
>>>>
>>>>
>>>> Am 19.07.2013 14:00, schrieb Antti Palosaari:
>>>>> Hello
>>>>> It is e4000 driver problem. Someone should take the look what there is
>>>>> wrong. Someone sent non-working stick for me, but I wasn't able to
>>>>> reproduce issue. I used modulator to generate signal with just same
>>>>> parameters he said non-working, but it worked for me. It looks like
>>>>> e4000 driver does not perform as well as it should.
>>>>>
>>>>> Maybe I should take Windows XP and Linux, use modulator to find out
>>>>> signal condition where Windows works but Linux not, took sniffs and
>>>>> compare registers... But I am busy and help is more than welcome.
>>>>>
>>>>> regards
>>>>> Antti
>>>>
>>>
>>>
>>
>>
>


-- 
http://palosaari.fi/
