Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.sikkerhed.org ([78.109.215.82]:47528 "EHLO
	mail.sikkerhed.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab0G0TnW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 15:43:22 -0400
Message-ID: <4C4F36D5.1050809@iversen-net.dk>
Date: Tue, 27 Jul 2010 21:43:17 +0200
From: Christian Iversen <chrivers@iversen-net.dk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: Unknown CX23885 device
References: <4C4F31A7.8060609@iversen-net.dk> <AANLkTinqS6pWDf4cEsFz6_KFW2r1Yq-BPMzb0uewF_O_@mail.gmail.com>
In-Reply-To: <AANLkTinqS6pWDf4cEsFz6_KFW2r1Yq-BPMzb0uewF_O_@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2010-07-27 21:37, Alex Deucher wrote:
> On Tue, Jul 27, 2010 at 3:21 PM, Christian Iversen
> <chrivers@iversen-net.dk>  wrote:
>> (please CC, I'm not subscribed yet)
>>
>> Hey Linux-DVB people
>>
>> I'm trying to make an as-of-yet unsupported CX23885 device work in Linux.
>>
>> I've tested that the device is not supported using the newest snapshot
>> of the DVB drivers. They did support a bunch of extra devices compared
>> to the standard ubuntu driver, but to no avail.
>>
>> This is what I know about the device:
>>
>> ### physical description ###
>>
>> The device is a small mini-PCIe device currently installed in my
>> Thinkpad T61p notebook. It did not originate there, but I managed to fit it
>> in.
>
> How are you attaching the video/audio/antenna/etc. input to the pcie
> card?  I don't imagine the card is much use without external
> connectors.

For now, I'm using a wifi-antenna lead to connect it. I think that 
should at least work as a proof-of-concept. Even if I can't tune in any 
channels, I should still be able to control the card, which I can't 
right now.

When/if it has a chance of working, I'm planning to mod my laptop to fit 
an antenna lead, properly mounted.

Any suggestions for proceeding?

-- 
Med venlig hilsen
Christian Iversen
