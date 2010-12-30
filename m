Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:39292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab0L3P3r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 10:29:47 -0500
Message-ID: <4D1CA565.4080204@redhat.com>
Date: Thu, 30 Dec 2010 13:29:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] ivtv-i2c: Fix two wanrings
References: <20101230130041.71357141@gaivota> <201012301621.21746.hverkuil@xs4all.nl>
In-Reply-To: <201012301621.21746.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 30-12-2010 13:21, Hans Verkuil escreveu:
> On Thursday, December 30, 2010 16:00:41 Mauro Carvalho Chehab wrote:
>> Fix two gcc warnings:
>>
>> drivers/media/video/ivtv/ivtv-i2c.c:170: warning: cast from pointer to integer of different size
>> drivers/media/video/ivtv/ivtv-i2c.c:171: warning: cast from pointer to integer of different size
>> $ gcc --version
>> gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-48)
>>
>> They seem bogus, but, as the original code also has problems with
>> LE/BE, just change its implementation to be clear.
> 
> Definitely not bogus:

Yes, it is not bogus.
> 
> unsigned char keybuf[4];
> 
> ..
> 
> *ir_key = (u32) keybuf;
> 
> Here keybuf == &keybuf[0]. So you put the address of keybuf in *ir_key. Which is
> indeed of a different size in the case of a 64-bit architecture.
> 
> What you probably meant to do is:
> 
> *ir_key = *(u32 *)keybuf;

Yes, but this would lead into BE/LE issues.
> 
> Note that the code in your patch assumes that keybuf is in big-endian order. I assume
> that's what it should be?

Based on the way lirc_i2c was printing the data, this seems to be the most coherent way.
We'll only know for sure after testing the remote with the hardware.

> 
> Regards,
> 
> 	Hans
> 
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
>> index 2bed430..e103b8f 100644
>> --- a/drivers/media/video/ivtv/ivtv-i2c.c
>> +++ b/drivers/media/video/ivtv/ivtv-i2c.c
>> @@ -167,8 +167,8 @@ static int get_key_adaptec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>>  	keybuf[2] &= 0x7f;
>>  	keybuf[3] |= 0x80;
>>  
>> -	*ir_key = (u32) keybuf;
>> -	*ir_raw = (u32) keybuf;
>> +	*ir_key = keybuf[3] | keybuf[2] << 8 | keybuf[1] << 16 |keybuf[0] << 24;
>> +	*ir_raw = *ir_key;
>>  
>>  	return 1;
>>  }
>>
> 

