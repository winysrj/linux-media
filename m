Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43920 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab0DBJqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 05:46:46 -0400
Received: by bwz1 with SMTP id 1so1400871bwz.21
        for <linux-media@vger.kernel.org>; Fri, 02 Apr 2010 02:46:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BB37A44.8020909@gmx.de>
References: <h2iaa09d86e1003310314kb5c89ff6rc0d674197db538e9@mail.gmail.com>
	 <4BB37A44.8020909@gmx.de>
Date: Fri, 2 Apr 2010 13:46:44 +0400
Message-ID: <n2zaa09d86e1004020246x98c40adevdc14d3dace97c111@mail.gmail.com>
Subject: Re: stv0903bab i2c-repeater question
From: Sergey Mironov <ierton@gmail.com>
To: Andreas Regel <andreas.regel@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/3/31 Andreas Regel <andreas.regel@gmx.de>:
> Hi Sergey,
>
> Am 31.03.2010 12:14, schrieb Sergey Mironov:
>> Hello maillist!
>> I am integrating frontend with dvb-demux driver of one device
>> called mdemux.
>>
>> The frontend includes following parts:
>> - stv0903bab demodulator
>> - stv6110a tuner
>> - lnbp21 power supply controller
>>
>> stv6110a is connected to i2c bus via stv0903's repeater.
>>
>> My question is about setting up i2c repeater frequency divider (I2CRPT
>> register).  stv0903 datasheet says that "the speed of the i2c repeater
>> obtained by
>> dividing the internal chip frequency (that is, 135 MHz)"
>>
>> budget.c driver uses value STV090x_RPTLEVEL_16 for this divider. But
>> 135*10^6/16 is still too high to be valid i2c freq.
>>
>> Please explain where I'm wrong. Does the base frequency really equals to
>> 135
>> Mhz? Thanks.
>>
>
> The frequency divider in I2CRPT controls the speed of the I2C repeater HW
> unit inside the STV0903. The I2C clock itself has the same speed as the one
> that is used to access the STV0903. The repeater basically just routes the
> signals from one bus to the other and needs a higher internal frequency to
> do that properly. That is the frequency you set up with I2CRPT.
>
> Regards
> Andreas
>

Thanks, Andreas! Of cause, different i2c bus frequencies would require
some buffer inside repeater. But there is no information about such
things.
I've checked carefully and it seems that ENARPT_LEVEL actually defines
repeater delay.

-- 
Sergey
