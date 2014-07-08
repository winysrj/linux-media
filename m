Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:62737 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbaGHVjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jul 2014 17:39:15 -0400
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8E00EFHXHEVK00@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Jul 2014 17:39:14 -0400 (EDT)
Message-id: <53BC64FF.1050901@samsung.com>
Date: Tue, 08 Jul 2014 15:39:11 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
MIME-version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	"Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuah.kh@samsung.com>
Subject: Re: fix PCTV 461e tuner I2C binding
References: <53BB2E7D.30300@samsung.com> <53BB6947.2090409@iki.fi>
 <53BBF858.30408@samsung.com> <53BC3DC9.7010606@iki.fi>
In-reply-to: <53BC3DC9.7010606@iki.fi>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/2014 12:51 PM, Antti Palosaari wrote:
> On 07/08/2014 04:55 PM, Shuah Khan wrote:
>> Moikka Antti,
>>
>> On 07/07/2014 09:45 PM, Antti Palosaari wrote:
>>> Moikka Shuah
>>>
>>
>>>> Why are we unregistering i2c devices and dvb in this resume path?
>>>> Looks incorrect to me.
>>>
>>> I don't know. Original patch I send was a bit different and tuner was
>>> removed only during em28xx_dvb_fini()
>>>
>>> https://patchwork.linuxtv.org/patch/22275/
>>>
>>
>> Yes. That's what I suspected. My patch and yours got munged somehow.
>> I will send a fix in.
>
> There has been merge conflict and that is end result. None has reported
> that bug so far. Likely it is very rare users suspend/resume these
> devices as DVB suspend/resume has been largely broken always...
>

Somebody reported last week on v4l2 irc that suspend/resume not
working starting 3.15. That's what got me started on looking at
the code closely.

It should be fixed anyways. :)

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
