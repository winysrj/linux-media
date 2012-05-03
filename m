Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39564 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895Ab2ECWYv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 18:24:51 -0400
Message-ID: <b6bbbd5c85706263fd0ee60e424cd579.squirrel@webmail.kapsi.fi>
In-Reply-To: <201205031704.12467.pboettcher@kernellabs.com>
References: <4FA29427.4080603@iki.fi>
    <201205031704.12467.pboettcher@kernellabs.com>
Date: Fri, 4 May 2012 01:24:49 +0300
From: "Antti Palosaari" <crope@iki.fi>
To: "Patrick Boettcher" <pboettcher@kernellabs.com>
Cc: "Antti Palosaari" <crope@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Re: DVB USB issues we has currently
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

to 3.5.2012 18:04 Patrick Boettcher kirjoitti:
> On Thursday 03 May 2012 16:20:23 Antti Palosaari wrote:
>> Hello,
>> Here we are, that's the first part I am going to fix as a GSoC
>> project. Work is planned to start after two weeks but better to
>> discuss beforehand.
>>
>> And wish-list is now open!
>>
>> I see two big DVB USB issues including multiple small issues;
>>
>> 1)
>> Current static structure is too limited as devices are more dynamics
>> nowadays. Driver should be able to probe/read from eeprom device
>> configuration.
>>
>> Fixing all of those means rather much work - I think new version of
>> DVB USB is needed.
>
> I'm looking forward to see RFCs about proposals for additions to dvb-
> usb's structure. Especially the ugly device-usb-id-referencing.

RFC is  scheduled to first working week. Before that I can list all issues
I am aware and I am planning to fix. Good starting point of looking
problems is AF9015 driver and some other that reads device configuration
from eeprom and sets config struct values.

> What do you mean by "new version"?

I think it is so much changes that are very hard to do for existing
dvb-usb as all individual dvb-usb drivers must be changed. But that will
became clear after all changes are clear and RFC is approved.

Earlier I have mentioned for example availability of priv/state for first
callbacks.

I would like to list all all device properties, which are same for
chipset, and which are only for one device model (for example remote
keytable).

> Also adding support for hybrid (analog+dvb-devices) is missing. Mike
> Krufky did some work somewhere which looked promising but was never
> merged.

That was one feature what I was also thinking. But I think I don't have
any such device currently - at least I have no own experience. So let's
see.

Also static limit for amount of individual devices in the config struct is
something I would like to fix. Now it is over 10 device models, but as we
have devices more than 10 it is needed to add multiple configurations.
IIRC AF9015 has 3 currently.

But I am now on weekend trip. I will list issues more detailed in next week.

regards
Antti

