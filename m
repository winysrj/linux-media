Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbbBTKYW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 05:24:22 -0500
Message-ID: <54E70B52.9040708@suse.cz>
Date: Fri, 20 Feb 2015 11:24:18 +0100
From: Michal Marek <mmarek@suse.cz>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
	Antti Palosaari <crope@iki.fi>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] [kbuild] Add and use IS_REACHABLE macro
References: <6116702.rrbrOqQ26P@wuerfel> <14254005.QkaJhTuY5H@wuerfel> <54E5FBEA.1000005@suse.cz> <5822078.VORY4BTfEj@wuerfel>
In-Reply-To: <5822078.VORY4BTfEj@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-02-20 10:29, Arnd Bergmann wrote:
> On Thursday 19 February 2015 16:06:18 Michal Marek wrote:
>>> We have similar problems in other areas
>>> of the kernel. In theory, we could enforce the VIDEO_TUNER driver to
>>> be modular here by adding lots of dependencies to it:
>>>
>>> config VIDEO_TUNER
>>>       tristate
>>>       depends on MEDIA_TUNER_TEA5761 || !MEDIA_TUNER_TEA5761
>>>       depends on MEDIA_TUNER_TEA5767 || !MEDIA_TUNER_TEA5767
>>>       depends on MEDIA_TUNER_MSI001  || !MEDIA_TUNER_MSI001
>>
>> Nah, that's even uglier. I suggest to merge your IS_REACHABLE patch.
>>
> 
> Ok, can I take this as an ack from your side to merge the
> include/linux/kconfig.h part of the patch through the linux-media
> tree?

Yes. If you want

Acked-by: Michal Marek <mmarek@suse.cz> [kconfig]


> I thought about splitting up the patch into two, but that would
> just make merging it harder because we'd still have the dependency.

Agreed, no need to pedantically split patches just for the sake of it.

Michal
