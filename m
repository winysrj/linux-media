Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:52016 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab1CDWNV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2011 17:13:21 -0500
Message-ID: <4D7163FD.9030604@iki.fi>
Date: Sat, 05 Mar 2011 00:13:17 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andrew de Quincey <adq_dvb@lidskialf.net>
CC: linux-media@vger.kernel.org
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>
In-Reply-To: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Wow, thanks!

On 03/04/2011 11:37 PM, Andrew de Quincey wrote:
> Hi, this has been annoying me for some time, so this evening I fixed
> it. If you use one of the above dual tuner devices (e.g. KWorld 399U),
> you get random tuning failures and i2c errors reported in dmesg such
> as:
[...]
> Adding a "bus lock" to af9015_i2c_xfer() will not work as demod/tuner
> accesses will take multiple i2c transactions.
>
> Therefore, the following patch overrides the dvb_frontend_ops
> functions to add a per-device lock around them: only one frontend can
> now use the i2c bus at a time. Testing with the scripts above shows
> this has eliminated the errors.

This have annoyed me too, but since it does not broken functionality 
much I haven't put much effort for fixing it. I like that fix since it 
is in AF9015 driver where it logically belongs to. But it looks still 
rather complex. I see you have also considered "bus lock" to 
af9015_i2c_xfer() which could be much smaller in code size (that's I 
have tried to implement long time back).

I would like to ask if it possible to check I2C gate open / close inside 
af9015_i2c_xfer() and lock according that? Something like:

typical command sequence:
 >> FE0 open gate
 >> FE0 write reg
 >> FE0 close gate
 >> FE1 open gate
 >> FE1 read reg
 >> FE1 close gate

if (locked == YES)
   if (locked_by != caller FE)
     return error locked by other FE
   else (locked_by == caller FE)
     allow reg access
     if (gate close req)
       locked = NO
       locked_by = NONE
else (locked == NO)
   locked = YES
   locked_by = caller FE
   allow reg access

Do you see it possible?

thanks
Antti
-- 
http://palosaari.fi/
