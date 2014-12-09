Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12702 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbaLIONd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Dec 2014 09:13:33 -0500
Message-id: <54870389.7070203@samsung.com>
Date: Tue, 09 Dec 2014 15:13:29 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim
 max77693
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
 <20141204100706.GP14746@valkosipuli.retiisi.org.uk>
 <54804840.4030202@samsung.com>
 <20141209140927.GL15559@valkosipuli.retiisi.org.uk>
In-reply-to: <20141209140927.GL15559@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 12/09/2014 03:09 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Thu, Dec 04, 2014 at 12:40:48PM +0100, Jacek Anaszewski wrote:
>>>> +			the flash/torch.
>>>> +- maxim,trigger : Array of flags indicating which trigger can activate given led
>>>> +	in order: fled1, fled2.
>>>> +	Possible flag values (can be combined):
>>>> +		MAX77693_LED_TRIG_FLASHEN - FLASHEN pin of the chip,
>>>> +		MAX77693_LED_TRIG_TORCHEN - TORCHEN pin of the chip,
>>>> +		MAX77693_LED_TRIG_SOFTWARE - software via I2C command.
>>>
>>> Is there a need to prevent strobing using a certain method? Just wondering.
>>
>> In some cases it could be convenient to prevent some options through
>> device tree.
>
> Do you have that need now?
>
> If not, I'd propose to postpone this and add it only if there ever is one.
>

No, I don't. So let's postpone it.

Best Regards,
Jacek Anaszewski
