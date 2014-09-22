Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4596 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaIVKDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 06:03:54 -0400
Message-ID: <541FF3F5.8070506@xs4all.nl>
Date: Mon, 22 Sep 2014 12:03:33 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: James Harper <james@ejbdigital.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: buffer delivery stops with cx23885
References: <778B08D5C7F58E4D9D9BE1DE278048B5C0B208@maxex1.maxsum.com> <541D469B.4000306@xs4all.nl> <609d00f585384d999c8e3522fe1352ee@SIXPR04MB304.apcprd04.prod.outlook.com> <541D5220.4050107@xs4all.nl> <a349a970f1d445538b52eb4d0e98ee2c@SIXPR04MB304.apcprd04.prod.outlook.com> <541D5CD0.1000207@xs4all.nl> <9cc65ceabd05475d89a92c5df04cc492@SIXPR04MB304.apcprd04.prod.outlook.com> <541D61D7.3080202@xs4all.nl> <d1c6567fa03c4e27ba5534514a762631@SIXPR04MB304.apcprd04.prod.outlook.com> <59dd9f7eb4414e3e8683e52c559a8c45@SIXPR04MB304.apcprd04.prod.outlook.com> <e0f1371641b2497f9d3e91c9605702ec@HKXPR04MB295.apcprd04.prod.outlook.com> <541FDFB4.6070201@xs4all.nl> <01776abac53640498b8fc87ac8d36fd1@HKXPR04MB295.apcprd04.prod.outlook.com> <541FF16A.9060902@xs4all.nl> <cf662cd20e9e40ad8750500fc590a833@HKXPR04MB295.apcprd04.prod.outlook.com>
In-Reply-To: <cf662cd20e9e40ad8750500fc590a833@HKXPR04MB295.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

On 09/22/2014 11:58 AM, James Harper wrote:
>>>>>
>>>>> Any hints on what I can do to figure out what layer it's stalling at?
>>>>
>>>> I have no idea. I would do a git bisect to try and narrow it down.
>>>>
>>>
>>> Problem with the bisect is that I can't be sure what version it actually
>> worked on. It certainly predates when my patch for my card was committed.
>>>
>>> I have a hunch that it might be the two tuners stomping on each other,
>> possibly in the i2c code. Sometimes recording just stops, other times I get i2c
>> errors.
>>
>> Is that two tuners in the same device, or two tuners in different devices?
>>
> 
> DViCO FusionHDTV DVB-T Dual Express2
> 
> 2 tuners on one card

Any idea if there were changes or are issues with i2c access when there are
two tuners in the same device?

That's not really my expertise but you might know something about that.

Regards,

	Hans
