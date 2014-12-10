Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39866 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaLJK7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 05:59:43 -0500
Message-id: <54882789.2010700@samsung.com>
Date: Wed, 10 Dec 2014 11:59:21 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, robh+dt@kernel.org,
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
 <54804840.4030202@samsung.com> <54881A1F.2080607@samsung.com>
In-reply-to: <54881A1F.2080607@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/12/14 11:02, Jacek Anaszewski wrote:
>>>> +Optional properties:
>>>> >>> +- maxim,fleds : Array of current outputs in order: fled1, fled2.

s/current outputs/LED current regulator outputs used/ ?

>>>> >>> +    Note: both current outputs can be connected to a single led

s/led/LED ? And there seem to be other similar occurrences that would
need to be put in upper case.

>>>> >>> +    Possible values:
>>>> >>> +        MAX77693_LED_FLED_UNUSED - the output is left disconnected,
>>>> >>> +        MAX77693_LED_FLED_USED - a diode is connected to the output.

As noted below, I would simply use 0/1 for these.

>>> >>
>>> >> As you have a LED sub-nodes for each LED already, isn't this redundant?
>> >
>> > Well, it seems so :)
>
> I agreed here recklessly. This property allows to describe the
> situation when one LED is connected to both outputs. Single sub-node
> can describe two type of designs: one LED connected to a single
> output or one LED connected to both outputs. Therefore additional
> property is needed to assess what is the actual case.

How about renaming  "maxim,fleds" to "maxim,active-outputs" ?
And simply using 0 and 1 to indicate if one is used or not, rather
than defining macros for these true/false values ?

--
Regards,
Sylwester
