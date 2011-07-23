Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39141 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1GWKh5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 06:37:57 -0400
Message-ID: <4E2AA481.4030103@iki.fi>
Date: Sat, 23 Jul 2011 13:37:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Guy Martin <gmsoft@tuxicoman.be>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
References: <201106070205.08118.jareguero@telefonica.net> <201107231026.57485.jareguero@telefonica.net> <4E2A97A2.6080206@iki.fi> <201107231221.10705.jareguero@telefonica.net>
In-Reply-To: <201107231221.10705.jareguero@telefonica.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2011 01:21 PM, Jose Alberto Reguero wrote:
> On Sábado, 23 de Julio de 2011 11:42:58 Antti Palosaari escribió:
>> On 07/23/2011 11:26 AM, Jose Alberto Reguero wrote:

>>> The problem is in i2c read in tda827x_probe_version. Without the fix
>>> sometimes, when changing the code the tuner is detected as  tda827xo
>>> instead of tda827xa. That is because the variable where i2c read should
>>> store the value is initialized, and sometimes it works.
>>
>> struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = I2C_M_RD,
>> 			       .buf =&data, .len = 1 };
>>
>> rc = tuner_transfer(fe,&msg, 1);
>>
>> :-( Could you read what I write. It is a little bit annoying to find out
>>
>> everything for you. You just answer every time something like it does
>> not work and I should always find out what's problem.
>>
>> As I pointed out read will never work since I2C adapter supports only
>> read done in WRITE+READ combination. Driver uses read which is single
>> READ without write.
>>
>> You should implement new read. You can look example from af9015 or other
>> drivers using tda827x
>>
>> This have been never worked thus I Cc Guy Martin who have added DVB-C
>> support for that device.
>>
>>
>> regards
>> Antti
>
> I don't understand you. I think that you don' see the fix, but the old code.
> Old code:
>
> read = i+1<   num&&   (msg[i+1].flags&   I2C_M_RD);
>
> Fix:
>
> read1 = i+1<  num&&  (msg[i+1].flags&  I2C_M_RD); for the tda10023 and tda10048
> read2 = msg[i].flags&  I2C_M_RD; for the tda827x
>
> Jose Alberto

First of all I must apologize of blaming you about that I2C adapter, 
sorry, I should going to shame now. It was me who doesn't read your 
changes as should :/

Your changes are logically OK and implements correctly single reading as 
needed. Some comments still;
* consider renaming read1 and read2 for example write_read and read
* obuf[1] contains WRITE len. your code sets that now as READ len. 
Probably it should be 0 always in single write since no bytes written.
* remove useless checks from end of the "if (foo) if (foo)";
if (read1 || read2) {
	if (read1) {
[...]
	} else if (read2)

If you store some variables at the beginning, olen, ilen, obuf, ibuf, 
you can increase i++ for write+read and rest of the code in function can 
be same (no more if read or write + read). But maybe it is safe to keep 
closer original than change such much.


regards
Antti
-- 
http://palosaari.fi/
