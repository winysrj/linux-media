Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54199 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaG2Fjf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 01:39:35 -0400
Message-ID: <53D73393.6000202@gentoo.org>
Date: Tue, 29 Jul 2014 07:39:31 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: crope@iki.fi, linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8] cx231xx: Add digital support for [2040:b131] Hauppauge
 WinTV 930C-HD (model 1114xx)
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org> <1406059938-21141-7-git-send-email-zzam@gentoo.org> <20140726162718.660cf512.m.chehab@samsung.com> <53D4C72A.4010209@gentoo.org> <20140727104453.4578b353.m.chehab@samsung.com> <20140727113248.29dccc38.m.chehab@samsung.com> <20140727115911.0dde3d30.m.chehab@samsung.com> <20140727164218.3dd674e7.m.chehab@samsung.com>
In-Reply-To: <20140727164218.3dd674e7.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.07.2014 21:42, Mauro Carvalho Chehab wrote:
> Em Sun, 27 Jul 2014 11:59:11 -0300
> Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
> 
>> Em Sun, 27 Jul 2014 11:32:48 -0300
>> Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
>>
>>> Em Sun, 27 Jul 2014 10:44:53 -0300
>>> Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
>>>
>>>> Em Sun, 27 Jul 2014 11:32:26 +0200
>>>> Matthias Schwarzott <zzam@gentoo.org> escreveu:
>>>>
>>>>>
>>>>> Hi Mauro.
>>>>>
>>>>> On 26.07.2014 21:27, Mauro Carvalho Chehab wrote:
>>>>>> Tried to apply your patch series, but there's something wrong on it.
>>>>>>
>>>>>> See the enclosed logs. I suspect that you missed a patch adding the
>>>>>> proper tuner for this device.
> 
> The hole issue was due to that:
>> [  326.770414] cx231xx #0: New device Hauppauge Hauppauge Device @ 12 Mbps (2040:b131) with 4 interfaces
> 
> The root cause seems to be a bad USB cable, causing errors at USB
> detection.
> 
> Just send a patch series that avoids the driver to OOPS in such
> case.
> 

Ah, now I understand why this specific device did not work.
Nice errors that can be triggered by faulty hardware.

Regards
Matthias

