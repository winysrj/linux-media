Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56529 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562AbZFQMFd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 08:05:33 -0400
Received: by bwz9 with SMTP id 9so257077bwz.37
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 05:05:35 -0700 (PDT)
Message-ID: <4A38DA79.70707@gmail.com>
Date: Wed, 17 Jun 2009 13:58:49 +0200
From: Jan Nikitenko <jan.nikitenko@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Antti Palosaari <crope@iki.fi>,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] zl10353 and qt1010: fix stack corruption bug
References: <4A28CEAD.9000000@gmail.com>	<4A293B89.30502@iki.fi>	<c4bc83220906091539x51ec2931i9260e36363784728@mail.gmail.com>	<4A2EFA23.6020602@iki.fi>	<4A2F50E0.8030404@gmail.com> <20090616155937.3f5d869d@pedra.chehab.org>
In-Reply-To: <20090616155937.3f5d869d@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em Wed, 10 Jun 2009 08:21:20 +0200
> Jan Nikitenko <jan.nikitenko@gmail.com> escreveu:
> 
>> This patch fixes stack corruption bug present in dump_regs function of zl10353 
>> and qt1010 drivers:
>> the buffer buf is one byte smaller than required - there is 4 chars
>> for address prefix, 16*3 chars for dump of 16 eeprom bytes per line
>> and 1 byte for zero ending the string required, i.e. 53 bytes, but
>> only 52 were provided.
>> The one byte missing in stack based buffer buf can cause stack corruption 
>> possibly leading to kernel oops, as discovered originally with af9015 driver.
>>
>> Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>
>>
>> ---
>>
>> Antti Palosaari wrote:
>>  > On 06/10/2009 01:39 AM, Jan Nikitenko wrote:
>>  >> Solved with "[PATCH] af9015: fix stack corruption bug".
>>  >
>>  > This error leads to the zl10353.c and there it was copied to qt1010.c
>>  > and af9015.c.
>>  >
>> Antti, thanks for pointing out that the same problem was also in zl10353.c and 
>> qt1010.c. Include your Sign-off-by, please.
>>
>> Best regards,
>> Jan
>>
>>   linux/drivers/media/common/tuners/qt1010.c  |    2 +-
>>   linux/drivers/media/dvb/frontends/zl10353.c |    2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff -r cff06234b725 linux/drivers/media/common/tuners/qt1010.c
>> --- a/linux/drivers/media/common/tuners/qt1010.c	Sun May 31 23:07:01 2009 +0300
>> +++ b/linux/drivers/media/common/tuners/qt1010.c	Wed Jun 10 07:37:51 2009 +0200
>> @@ -65,7 +65,7 @@
>>   /* dump all registers */
>>   static void qt1010_dump_regs(struct qt1010_priv *priv)
>>   {
>> -	char buf[52], buf2[4];
>> +	char buf[4+3*16+1], buf2[4];
> 
> CodingStyle is incorrect. It should be buf[4 + 3 * 16 + 1].

right.

> 
> 
>>   	u8 reg, val;
>>
>>   	for (reg = 0; ; reg++) {
>> diff -r cff06234b725 linux/drivers/media/dvb/frontends/zl10353.c
>> --- a/linux/drivers/media/dvb/frontends/zl10353.c	Sun May 31 23:07:01 2009 +0300
>> +++ b/linux/drivers/media/dvb/frontends/zl10353.c	Wed Jun 10 07:37:51 2009 +0200
>> @@ -102,7 +102,7 @@
>>   static void zl10353_dump_regs(struct dvb_frontend *fe)
>>   {
>>   	struct zl10353_state *state = fe->demodulator_priv;
>> -	char buf[52], buf2[4];
>> +	char buf[4+3*16+1], buf2[4];
> 
> Same CodingStyle issue here.

agreed.

> 
>>   	int ret;
>>   	u8 reg;
>>
> 
> Without having actually looking at the source code, would it be possible to
> change the logic in order to use something else instead of a magic number for
> buf size - e. g. using sizeof(something) ?

I am not sure if that's possible - the buffer is used for sprintf in a loop to 
store text representation of registers dump, before printk-ing it.

We could put there a comment, suggesting that 4 bytes are required for address 
prefix of form "00: ", then 16 strings of form "00 " (3 bytes each) and one byte 
for zero to terminate the string.

Or we could use sizeof, like this:
    char buf[sizeof("00: ") - 1 + 16 * (sizeof("00 ") - 1) + 1]
or
    char buf[sizeof("00: 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f ")]
but it is not very readable in my opinion either.

Maybe the best way would be to avoid the need for temporal buffer completely by 
directly using printk in a loop, that is only the first printk with KERN_DEBUG, 
followed by sequence of printk with registers dump and final printk with end of 
line (but isn't a printk without KERN_ facility coding style problem as well?).

I am not sure, what approach is the best - I just wanted to fix a bug, which did 
not allow to use my af9015 based tuner on mips platform. After that, Antti 
pointed out, that the same code with the same bug is also in other two sources, 
so I send the same fix for them as well...

Best regards,
Jan
