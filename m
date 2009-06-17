Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50463 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759636AbZFQSdb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 14:33:31 -0400
Message-ID: <4A393757.3030009@redhat.com>
Date: Wed, 17 Jun 2009 20:35:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Brian Johnson <brijohn@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Convert cpia driver to v4l2,      drop parallel port version
 support?
References: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>	<20090617065621.23515ab7@pedra.chehab.org>	<4A38CCAF.5060202@redhat.com> <20090617112802.152a6d64@pedra.chehab.org> <4A390093.5090003@redhat.com> <4A3931DC.1060003@gmail.com>
In-Reply-To: <4A3931DC.1060003@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/17/2009 08:11 PM, Brian Johnson wrote:
> Hans de Goede wrote:
>>>> sn9c102
>>>> Supports a large number of cams also supported by gspca's sonixb / sonixj driver, we're using
>>>> #ifdef .... macros to detect if both are being build at the same time to include usb-id's only
>>>> in one of the 2.
>>> Btw, it would be interesting to work with the out-of-tree microdia driver,
>>> since there are some models that are supported only by the alternative driver.
>> Ack, only one small problem, which is another reason why Luca's drivers should slowly be phased
>> out, Luca has gone closed source with his sn9cxxx driver.
>>
>> There is an out of tree driver for the new sn9c2xx models you talk about though, with active
>> developers, I've pushing them to get it into the mainline, I'll give it another try soonish.
>>
>
> Hello I'm one of the developers for the current out of tree sn9c20x driver.  What needs to be done in order
> to get the sn9c20x code into the mainline? Am i right in assuming it would be preferred to move the code into
> a sn9c20x gspca subdriver rather then include the complete out of tree driver?

Yes that would be very much prefered. Not that I believe that gspca is the
best thing ever invented or anything like that. But usb webcam drivers all have a lot in
common and gspca handles that good enough, and if we ever want to make improvements like
moving usb webcams to use videobuf, having them all as gspca sub drivers means we only
need to do it once, as for example all buffer management is done by gspca.

Also after looking at the pwc driver oops at unplug, and being reminded at the ref counting
with hotplug devices going away and locking nightmare stuff we discussed some time ago,
I'm also really glad to only have all that tricky code only once.

This will also make reviewing a lot easier as there will be no tricky buffer management
and locking, etc. to review.

 > If this is the case I can work
 > on a set of patches to implement our code as a gspca subdriver.
 >

As explained above very much: "Yes please"

> Also i have a few questions regarding submitting the patches.
>
> 1) In addition to sending them to linux-media should I CC them to anyone in particular?

I have such a cam and I'm one of the people actively working on gspca, so if you could CC
me then I'm sure to notice it and review it, and it can get merged through my mercurial
(git alike vcs) tree.

> 2) The entire patch would likely be about 70k. Should I just send one patch or split the
> thing up into several?

I would hope gspca would shrink the size somewhat :) As for one patch versus incremental
patches, as this is a whole new driver one patch will do I guess, I see little use in having
non working increments in between.

Thanks & Regards,

Hans
