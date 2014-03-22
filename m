Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:11794 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaCVPW7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Mar 2014 11:22:59 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Message-id: <532DAAD0.6060209@samsung.com>
Date: Sat, 22 Mar 2014 09:22:56 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] media: em28xx-video - change em28xx_scaler_set() to use
 em28xx_reg_len()
References: <1395435890-15100-1-git-send-email-shuah.kh@samsung.com>
 <532D82C9.6010401@googlemail.com>
In-reply-to: <532D82C9.6010401@googlemail.com>
Content-transfer-encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/22/2014 06:32 AM, Frank Sch�fer wrote:
>
> Am 21.03.2014 22:04, schrieb Shuah Khan:
>> Change em28xx_scaler_set() to use em28xx_reg_len() to get register
>> lengths for EM28XX_R30_HSCALELOW and EM28XX_R32_VSCALELOW registers,
>> instead of hard-coding the length. Moved em28xx_reg_len() definition
>> for it to be visible to em28xx_scaler_set().
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>   drivers/media/usb/em28xx/em28xx-video.c |   29 ++++++++++++++++-------------
>>   1 file changed, 16 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
>> index 19af6b3..f8a91de 100644
>> --- a/drivers/media/usb/em28xx/em28xx-video.c
>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
>> @@ -272,6 +272,18 @@ static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
>>   	}
>>   }
>>
>> +static int em28xx_reg_len(int reg)
>> +{
>> +	switch (reg) {
>> +	case EM28XX_R40_AC97LSB:
>> +	case EM28XX_R30_HSCALELOW:
>> +	case EM28XX_R32_VSCALELOW:
>> +		return 2;
>> +	default:
>> +		return 1;
>> +	}
>> +}
>> +
>>   static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
>>   {
>>   	u8 mode;
>> @@ -284,11 +296,13 @@ static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
>>
>>   		buf[0] = h;
>>   		buf[1] = h >> 8;
>> -		em28xx_write_regs(dev, EM28XX_R30_HSCALELOW, (char *)buf, 2);
>> +		em28xx_write_regs(dev, EM28XX_R30_HSCALELOW, (char *)buf,
>> +				  em28xx_reg_len(EM28XX_R30_HSCALELOW));
>>
>>   		buf[0] = v;
>>   		buf[1] = v >> 8;
>> -		em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf, 2);
>> +		em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf,
>> +				  em28xx_reg_len(EM28XX_R32_VSCALELOW));
> Hmm... registers 0x30 and 0x32 are always 2 bytes long.
> So this change would needlessly complicate the code.
>

The reason I made the change is that em28xx_reg_len() is handling these 
two registers and I thought it would be good to make it consistent with 
other writes to these registers and not hard-code the length.

I think it would help with maintenance later by avoiding hard-coding the 
length and use the existing routine that returns the length for these 
registers.

You are correct that it does add a function call in the code path. So if 
you think the trade-off isn't worth it, I am not going to argue with it :)

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
