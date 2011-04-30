Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60590 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761076Ab1D3BeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 21:34:18 -0400
References: <BANLkTim7AONexeEm-E8iLQA5+TMDRUy36w@mail.gmail.com> <201104231256.25263.hverkuil@xs4all.nl> <BANLkTikneMOMVUQ07mLBZZTDYrKTJ1dfPw@mail.gmail.com> <201104260853.03817.hverkuil@xs4all.nl> <BANLkTikRtZTpDZTe93q08-WFSKRAuv29WQ@mail.gmail.com>
In-Reply-To: <BANLkTikRtZTpDZTe93q08-WFSKRAuv29WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Regression with suspend from "msp3400: convert to the new control framework"
From: Andy Walls <awalls@md.metrocast.net>
Date: Fri, 29 Apr 2011 21:34:22 -0400
To: Jesse Allen <the3dfxdude@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Message-ID: <e9c2ce41-bb46-4a6a-8ca6-b7923b799c8b@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jesse Allen <the3dfxdude@gmail.com> wrote:

>On Tue, Apr 26, 2011 at 12:53 AM, Hans Verkuil <hverkuil@xs4all.nl>
>wrote:
>>
>> OK, whatever is causing the problems is *not* msp3400 since your card
>does not
>> have one :-)
>>
>> This card uses gpio to handle audio.
>>
>>> i2c-core: driver [tuner] using legacy suspend method
>>> i2c-core: driver [tuner] using legacy resume method
>>> tuner 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
>>> tuner-simple 0-0061: creating new instance
>>> tuner-simple 0-0061: type set to 2 (Philips NTSC (FI1236,FM1236 and
>>> compatibles))
>>
>> It is more likely to be the tuner driver. But I would have expected
>to see
>> more bug reports since this is a bog-standard tuner so I have my
>doubts there
>> as well.
>>
>> Regards,
>>
>>        Hans
>>
>
>
>After today, basically I have proved that the issue only happens if
>both the radeon and the bttv drivers are both loaded at suspend. If I
>boot without radeon, but load bttv, I can suspend and resume the tv
>card just fine. If I load radeon and when going to suspend unload
>bttv, I can then resume and load bttv just fine. This behavior started
>sometime after v2.6.36. It will be hard to pin point a problem in
>either since both have problems in 2.6.37-rc, where bttv has multiple
>issues during that time frame that cause oopses, and in other places
>loading radeon causes a lockup. So I think this will take me a
>different direction now, and it would be nice to know what changed
>related to all this.
>
>Jesse
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Maybe kernel changes related to the PCI chipset used by your motherboard.

-Andy
