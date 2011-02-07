Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1BGQAS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 11:00:18 -0500
Message-ID: <4D501704.6060504@redhat.com>
Date: Mon, 07 Feb 2011 14:00:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: matti.j.aaltonen@nokia.com
CC: ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
	alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Subject: Re: WL1273 FM Radio driver...
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>	 <4D4FDED0.7070008@redhat.com>	 <20110207120234.GE10564@opensource.wolfsonmicro.com>	 <4D4FEA03.7090109@redhat.com>	 <20110207131045.GG10564@opensource.wolfsonmicro.com>	 <4D4FF821.4010701@redhat.com>	 <20110207135225.GJ10564@opensource.wolfsonmicro.com> <1297088242.15320.62.camel@masi.mnp.nokia.com>
In-Reply-To: <1297088242.15320.62.camel@masi.mnp.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-02-2011 12:17, Matti J. Aaltonen escreveu:
> On Mon, 2011-02-07 at 13:52 +0000, ext Mark Brown wrote:
>> On Mon, Feb 07, 2011 at 11:48:17AM -0200, Mauro Carvalho Chehab wrote:
>>> Em 07-02-2011 11:10, Mark Brown escreveu:
>>
>>>> There is an audio driver for this chip and it is using those functions.
>>
>>> Where are the other drivers that depend on it?
>>
>> Nothing's been merged yet to my knowledge, Matti can comment on any
>> incoming boards which will use it (rx51?).
> 
> Yes, nothing's been merged yet. There are only dependencies between the
> parts of this driver... I cannot comment on upcoming boards, I just hope
> we could agree on a sensible structure for this thing.

We don't need any brand names or specific details, but it would be good to 
have an overview, in general lines, about the architecture, in order to help 
you to map how this would fit. In particular, the architecturre of 
things that are tightly coupled and can't be splitted by some bus abstraction.

Mauro.
