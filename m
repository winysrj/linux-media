Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38961 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab2K2CPp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 21:15:45 -0500
Message-ID: <50B6C530.4010701@iki.fi>
Date: Thu, 29 Nov 2012 04:15:12 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net>
In-Reply-To: <50B6C2DF.4020509@pyther.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/29/2012 04:05 AM, Matthew Gyurgyik wrote:
> On 11/28/2012 05:55 PM, Antti Palosaari wrote:
>>
>> Very, very, good pics and sniffs!!
>>
>>
>> From the sniff you could see I2C addresses
>> 50 (a0 >> 1) eeprom
>> 0e (1c >> 1) demod
>> 60 (c0 >> 1) tuner
>>
>>
>> EM2874, USB-bridge, clocked at 12MHz, crystal on other side of PCB.
>> There is also 32k serial eeprom for EM2874. This large serial eeprom
>> means (very likely) it uses custom firmware which is downloaded from
>> the eeprom.
>>
>> LGDT3305, demodulator, clocked at 25MHz. Serial TS used between EM2874
>> and LGDT3305.
>>
>> TDA18271HDC2 is tuner, clocked at 16MHz. Traditional IF used between
>> tuner and demod.
>>
>> IR receiver is near antenna, which is a little bit long wires to
>> connect to the EM2874, looks weird but no harm.
>>
>>
>> Main GPIO sequence is that one:
>> 000255: 000006 ms 000990 ms c0 00 00 00 80 00 01 00 <<< ff
>> 000256: 000004 ms 000994 ms 40 00 00 00 80 00 01 00 >>> fe
>> 000257: 000006 ms 001000 ms c0 00 00 00 80 00 01 00 <<< fe
>> 000258: 000004 ms 001004 ms 40 00 00 00 80 00 01 00 >>> be
>> 000259: 000139 ms 001143 ms c0 00 00 00 80 00 01 00 <<< be
>> 000260: 000005 ms 001148 ms 40 00 00 00 80 00 01 00 >>> fe
>>
>> There is some more GPIOs later, just test with trial and error to find
>> out all GPIOs.
>>
>> Making that device working should be quite easy! There is a little
>> change for proprietary firmware for EM2874 which does some nasty
>> things, but that is very very unlikely.
>>
>> regards
>> Antti
>
> Thanks for the information. That is way over my head. Is there same
> basic reading someone could recommend so I can start to understand the
> basics of all this?
>
> In the mean time, I'm willing to do any testing necessary.
>

Maybe I could give hour or two for that if you could make tests I ask?

If someone else would like to hack with it, I am very happy too. Frank?

regards
Antti


-- 
http://palosaari.fi/
