Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969Ab2ESTAr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 15:00:47 -0400
Message-ID: <4FB7EECF.1000402@redhat.com>
Date: Sat, 19 May 2012 21:04:47 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: RFC: V4L2 API and radio devices with multiple tuners
References: <4FB7E489.10803@redhat.com> <201205192030.53616.linux@rainbow-software.org>
In-Reply-To: <201205192030.53616.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/19/2012 08:30 PM, Ondrej Zary wrote:
> On Saturday 19 May 2012 20:20:57 Hans de Goede wrote:
>> Hi Hans et all,
>>
>> Currently the V4L2 API does not allow for radio devices with more then 1
>> tuner, which is a bit of a historical oversight, since many radio devices
>> have 2 tuners/demodulators 1 for FM and one for AM. Trying to model this as
>> 1 tuner really does not work well, as they have 2 completely separate
>> frequency bands they handle, as well as different properties (the FM part
>> usually is stereo capable, the AM part is not).
>>
>> It is important to realize here that usually the AM/FM tuners are part
>> of 1 chip, and often have only 1 frequency register which is used in
>> both AM/FM modes. IOW it more or less is one tuner, but with 2 modes,
>> and from a V4L2 API pov these modes are best modeled as 2 tuners.
>> This is at least true for the radio-cadet card and the tea575x,
>> which are the only 2 AM capable radio devices we currently know about.
>
> When working on tea575x driver, I thought that it would be nice to implement
> AM. But found that none of my cards with TEA575x has implemented the AM part.

I have a tea5757 device which does implement the AM part, the Griffin radioSHARK,
and I'm working on a driver for it now, including some mods to the existing
tea575x driver, this is one of the reasons I CC-ed you on this RFC.

If you would like to get a radioSHARK yourself, you can get one here:
http://www.ebay.com/itm/Griffin-RadioShark-PC-MAC-AM-FM-Desktop-Radio-/140547171120?pt=LH_DefaultDomain_0&hash=item20b943a330

Do you have any comments on my proposal how to deal with these
devices API wise?

> The components required to receive AM radio (according to the chip datasheet)
> are missing.

Right I already expected that my WIP patch to add AM support to the tea575x driver
adds a has_am boolean and only makes AM available if that is set.

I hope to post a set of tea575x patches this evening, most are non controversial
so unless someone (ie you) yells stop I'm going to include them in my next pull
request to Mauro for 3.5 (which will hopefully happen tomorrow).

Unless some quick consensus can be reached on how to deal with the radio
device with dual mode tuner API issue I'll leave out the AM patch from
my pullreq.

Thanks & Regards,

Hans

