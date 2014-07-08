Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49403 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbaGHSv7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 14:51:59 -0400
Message-ID: <53BC3DC9.7010606@iki.fi>
Date: Tue, 08 Jul 2014 21:51:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: shuah.kh@samsung.com,
	"Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: fix PCTV 461e tuner I2C binding
References: <53BB2E7D.30300@samsung.com> <53BB6947.2090409@iki.fi> <53BBF858.30408@samsung.com>
In-Reply-To: <53BBF858.30408@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/2014 04:55 PM, Shuah Khan wrote:
> Moikka Antti,
>
> On 07/07/2014 09:45 PM, Antti Palosaari wrote:
>> Moikka Shuah
>>
>
>>> Why are we unregistering i2c devices and dvb in this resume path?
>>> Looks incorrect to me.
>>
>> I don't know. Original patch I send was a bit different and tuner was
>> removed only during em28xx_dvb_fini()
>>
>> https://patchwork.linuxtv.org/patch/22275/
>>
>
> Yes. That's what I suspected. My patch and yours got munged somehow.
> I will send a fix in.

There has been merge conflict and that is end result. None has reported 
that bug so far. Likely it is very rare users suspend/resume these 
devices as DVB suspend/resume has been largely broken always...

> btw: thanks for teaching me how to say hello in Finnish

:=)

regards
Antti

-- 
http://palosaari.fi/
