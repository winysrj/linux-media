Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4428 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZFRLlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 07:41:53 -0400
Message-ID: <45744.62.70.2.252.1245325314.squirrel@webmail.xs4all.nl>
Date: Thu, 18 Jun 2009 13:41:54 +0200 (CEST)
Subject: Re: OMAP patches for linux-media
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: sakari.ailus@maxwell.research.nokia.com, sakari.ailus@nokia.com,
	"Brijesh Jadav" <brijesh.j@ti.com>,
	"Chaithrika Subrahmanya" <chaithrika@ti.com>,
	"Cohen David.A" <david.cohen@nokia.com>,
	"Dominic Curran" <dcurran@ti.com>,
	"Valentin Eduardo" <eduardo.valentin@nokia.com>,
	"Nurkkala Eero.An" <ext-eero.nurkkala@nokia.com>,
	"Balbi Felipe" <felipe.balbi@nokia.com>,
	"Hardik Shah" <hardik.shah@ti.com>,
	"Hari Nagalla" <hnagalla@ti.com>, "Manjunath Hadli" <mrh@ti.com>,
	"Hurskainen Mikko" <mikko.hurskainen@nokia.com>,
	"Muralidharan Karicheri" <m-karicheri2@ti.com>,
	"Nishanth Menon" <nm@ti.com>, "R Sivaraj" <sivaraj@ti.com>,
	"Sandeep Paulraj" <s-paulraj@ti.com>,
	"Sergio Alberto Aguirre Rodriguez" <saaguirre@ti.com>,
	"Valkeinen Tomi" <tomi.valkeinen@nokia.com>,
	"Toivonen Tuukka.O" <tuukka.o.toivonen@nokia.com>,
	"Vaibhav Hiremath" <hvaibhav@ti.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Sakari,
>
> Em Wed, 17 Jun 2009 20:40:32 +0300
> Sakari Ailus <sakari.ailus@nokia.com> escreveu:
>
>> > So, I decided to send you this email, c/c a random list of people that
>> I
>> > believe are involved on the submit and/or review process of those
>> patches, in
>> > the hope to better understand and to discuss what's happening and how
>> can we
>> > speedup the merge process of those patches.
>>
>> There are a few reasons for apparent stalling of the development
>> process. I should have sent a status update earlier.
>>
>> The code quality of the ISP driver was originally quite low and from
>> that part it wouldn't have made much sense to repeatedly post that for
>> reviewing. It's been improving since many of the subdrivers have been
>> refactored or rewritten since I last posted the patchset. The end result
>> should be (more?) easily understood by human beings...
>
> Ok, makes sense.
>
>> Another reason for no upstream patches is that we are still depending on
>> the obsolete v4l2-int-device in the camera / sensor / lens / flash
>> driver interface. Hans' opinion was that we must switch to v4l2_subdev
>> instead with which I fully agree. However, due to our internal reasons
>> we have not been able to even start that transition process yet.
>>
>> There is no definite deadline for the v4l2_subdev transition (or even
>> its start) at the moment. I'm planning to update the patchset in
>> Gitorious, however.
>
> I also see advantages on porting it to v4l2 dev/subdev. However, I don't
> see
> much sense on holding a driver for such a long time just because an
> internal
> KABI, especially since the old v4l2-int-device is still supported, and
> provided
> that you'll do the conversion anyway.

That part is very important. The tvp514x driver went in while still using
v4l2-int-device, but the deal was that it would be converted as soon as
possible, in principle before the next kernel release. That was indeed the
case (and I'll prepare a pull request for that tomorrow), so I was OK with
it.

So if we accept other v4l2-int-device drivers, then only if we have a
solid agreement on when they will be converted to v4l2_subdev. It is very
tempting to postpone that once a driver is in, but the only way we can
have real reuse of i2c drivers is if they all use the same API.

Just my 5 cents...

Regards,

         Hans

>
> Whatever you decide, it is up to you do choose the proper snapshot where
> you
> consider the code ready for the merge submission.
>
> Just be nice with me by avoid sending me all drivers at the same time, on
> big
> pull requests ;)
>
> Cheers,
> Mauro
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

