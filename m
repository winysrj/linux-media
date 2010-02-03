Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:47008 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932943Ab0BCVHc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 16:07:32 -0500
Message-ID: <4B69E575.5010201@arcor.de>
Date: Wed, 03 Feb 2010 22:07:01 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 14/15] - zl10353
References: <4B673790.3030706@arcor.de> <4B675B19.3080705@redhat.com>	 <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com>	 <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com>	 <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de>	 <4B69D8CC.2030008@arcor.de> <4B69DEDA.3020200@arcor.de> <829197381002031249w5542bccfpccfa8554e7c6b280@mail.gmail.com>
In-Reply-To: <829197381002031249w5542bccfpccfa8554e7c6b280@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 03.02.2010 21:49, schrieb Devin Heitmueller:
> On Wed, Feb 3, 2010 at 3:38 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
>   
>> signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>>
>> --- a/drivers/media/dvb/frontends/zl10353.h
>> +++ b/drivers/media/dvb/frontends/zl10353.h
>> @@ -45,6 +45,8 @@ struct zl10353_config
>>        /* clock control registers (0x51-0x54) */
>>        u8 clock_ctl_1;  /* default: 0x46 */
>>        u8 pll_0;        /* default: 0x15 */
>> +
>> +       int tm6000:1;
>>  };
>>     
> Why is this being submitted as its own patch?  It is code that is not
> used by *anything*.  If you really did require a new field in the
> zl10353 config, that field should be added in the same patch as
> whatever requires it.
>
> Devin
>
>   
Actually doesn't work zl10353 with tm6010, it have a little different
between a few registers, so I think that I use it.

for example:
zl10353 use 0x64 , but not mine (0x63)
register 0x5f is 0x17 not 0x13
register 0x5e is 0x40 not 0x00 for auto
and tuner go is 0x70 not 0x71

the other register are ok. I have no idea how I can set it.


-- 
Stefan Ringel <stefan.ringel@arcor.de>

