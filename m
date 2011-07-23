Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33503 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab1GWRre (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 13:47:34 -0400
Message-ID: <4E2B092F.5040107@iki.fi>
Date: Sat, 23 Jul 2011 20:47:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Guy Martin <gmsoft@tuxicoman.be>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
References: <201106070205.08118.jareguero@telefonica.net> <201107231221.10705.jareguero@telefonica.net> <4E2AA481.4030103@iki.fi> <201107231741.53794.jareguero@telefonica.net>
In-Reply-To: <201107231741.53794.jareguero@telefonica.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2011 06:41 PM, Jose Alberto Reguero wrote:
> On Sábado, 23 de Julio de 2011 12:37:53 Antti Palosaari escribió:
>> On 07/23/2011 01:21 PM, Jose Alberto Reguero wrote:
>>> On Sábado, 23 de Julio de 2011 11:42:58 Antti Palosaari escribió:
>>>> On 07/23/2011 11:26 AM, Jose Alberto Reguero wrote:
>>>>> The problem is in i2c read in tda827x_probe_version. Without the fix
>>>>> sometimes, when changing the code the tuner is detected as  tda827xo
>>>>> instead of tda827xa. That is because the variable where i2c read should
>>>>> store the value is initialized, and sometimes it works.
>>>>
>>>> struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = I2C_M_RD,
>>>>
>>>> 			       .buf =&data, .len = 1 };
>>>>
>>>> rc = tuner_transfer(fe,&msg, 1);
>>>>
>>>> :-( Could you read what I write. It is a little bit annoying to find out
>>>>
>>>> everything for you. You just answer every time something like it does
>>>> not work and I should always find out what's problem.
>>>>
>>>> As I pointed out read will never work since I2C adapter supports only
>>>> read done in WRITE+READ combination. Driver uses read which is single
>>>> READ without write.
>>>>
>>>> You should implement new read. You can look example from af9015 or other
>>>> drivers using tda827x
>>>>
>>>> This have been never worked thus I Cc Guy Martin who have added DVB-C
>>>> support for that device.
>>>>
>>>>
>>>> regards
>>>> Antti
>>>
>>> I don't understand you. I think that you don' see the fix, but the old
>>> code. Old code:
>>>
>>> read = i+1<    num&&    (msg[i+1].flags&    I2C_M_RD);
>>>
>>> Fix:
>>>
>>> read1 = i+1<   num&&   (msg[i+1].flags&   I2C_M_RD); for the tda10023 and
>>> tda10048 read2 = msg[i].flags&   I2C_M_RD; for the tda827x
>>>
>>> Jose Alberto
>>
>> First of all I must apologize of blaming you about that I2C adapter,
>> sorry, I should going to shame now. It was me who doesn't read your
>> changes as should :/
>>
>> Your changes are logically OK and implements correctly single reading as
>> needed. Some comments still;
>> * consider renaming read1 and read2 for example write_read and read
>> * obuf[1] contains WRITE len. your code sets that now as READ len.
>> Probably it should be 0 always in single write since no bytes written.
>> * remove useless checks from end of the "if (foo) if (foo)";
>> if (read1 || read2) {
>> 	if (read1) {
>> [...]
>> 	} else if (read2)
>>
>> If you store some variables at the beginning, olen, ilen, obuf, ibuf,
>> you can increase i++ for write+read and rest of the code in function can
>> be same (no more if read or write + read). But maybe it is safe to keep
>> closer original than change such much.
>>
>>
>> regards
>> Antti
>
> There are a second i2c read, but less important.It is in:
>
> tda827xa_set_params
>
> ............
>          buf[0] = 0xa0;
>          buf[1] = 0x40;
>          msg.len = 2;
>          rc = tuner_transfer(fe,&msg, 1);
>          if (rc<  0)
>                  goto err;
>
>          msleep(11);
>          msg.flags = I2C_M_RD;
>          rc = tuner_transfer(fe,&msg, 1);
>          if (rc<  0)
>                  goto err;
>          msg.flags = 0;
>
>          buf[1]>>= 4;
> ............
> I supposed that buf[0] is the register to read and they read the value in
> buf[1]. The code now seem to work ok but perhaps is wrong.

This one is as translated to "normal" C we usually use;
write_reg(0xa0, 0x40); // write one reg
read_regs(2); // read 2 regs

example from the sniff
  AA B0 31 05 C2 02 00 A0 40                        ª°1.Â.. @
  55 B0 31 03 C2 02 00 4A 44 08 00 00 00 71 AC EC   U°1.Â..JD....q¬ì
  AA B1 31 05 C2 02 00 30 11                        ª±1.Â..0.
  55 B1 31 03 C2 02 00 4A 44 08 00 00 00 71 AC EC   U±1.Â..JD....q¬ì


AA USB direction to device
B1 USB msg seq
31 USB cmd
05 USB data len (4+5=9, 4=hdr len, 5=data len, 9=total)
C2 I2C addr (addr << 1)
02 I2C write len
00 I2C read len
30 I2C data [0]
11 I2C data [1]

So it seems actually to write 30 11 and then read 4a 44 as reply. But if 
you read driver code it does not write "30 11" instead just reads. Maybe 
buggy I2C adap implementation or buggy tuner driver (Linux driver or 
driver where sniff taken). Try to read without write and with write and 
compare if there is any difference.


regards
Antti

-- 
http://palosaari.fi/
