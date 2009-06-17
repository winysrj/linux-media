Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:3048 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZFQGaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 02:30:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: OMAP patches for linux-media
Date: Wed, 17 Jun 2009 08:30:13 +0200
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	Brijesh Jadav <brijesh.j@ti.com>,
	Chaithrika Subrahmanya <chaithrika@ti.com>,
	David Cohen <david.cohen@nokia.com>,
	Dominic Curran <dcurran@ti.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
	Felipe Balbi <felipe.balbi@nokia.com>,
	Hardik Shah <hardik.shah@ti.com>,
	Hari Nagalla <hnagalla@ti.com>, Manjunath Hadli <mrh@ti.com>,
	Mikko Hurskainen <mikko.hurskainen@nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Nishanth Menon <nm@ti.com>, R Sivaraj <sivaraj@ti.com>,
	Sandeep Paulraj <s-paulraj@ti.com>,
	Sergio Alberto Aguirre Rodriguez <saaguirre@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@nokia.com>,
	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20090616104018.44075a80@pedra.chehab.org>
In-Reply-To: <20090616104018.44075a80@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906170830.14052.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 16 June 2009 15:40:18 Mauro Carvalho Chehab wrote:
> Hi Sakari and others,
>
> I'm seeing lots of patches and discussions for OMAP and DaVinci being
> handled at the linux-media Mailing List, as part of the development
> process of the open source drivers.
>
> However, it is hard to track all those discussions and be sure what
> patches are ready for merging and what patches are just RFC.
>
> On the development model we use here, we have driver maintainers that are
> responsible to discuss about improvements on their drivers. They are
> generally the driver authors or the one that first started submitting the
> patches for that driver(s).
>
> One of the roles of the driver maintainers is to collect the patches for
> the drivers they maintain, merge on their trees, and periodically ask the
> patch merge.
>
> One fundamental concept on Kernel development is the concept of "Commit
> earlier and commit often", meaning that the better is to send small,
> incremental, and periodic patches, than wait until having everything
> done, then submit a big patch. Every time I receive a big patch I need to
> postpone its analysis and open a big window on my schedule to analyze it.
> Of course, this means to postpone it, and generally results on lots of
> comments going back to developer, that, in turn, will need to do lots of
> changes and return me back with another big patch for me to analyze
> again, resulting on a long period of time for merging it.
>
> As you, Sakari, was the first one that started merging the OMAP drivers,
> I was expecting that you would be the one that will handle the figure of
> the driver maintainer for OMAP. I even created you an account at linuxtv
> for you to create your trees there and ask me to merge from it.
>
> Unfortunately, you haven't sent me any pull requests yet along this year.
> This is concerning me a lot, since, at the end, I'll need to review big
> piles of patches and/or drivers when you decide to submit the final
> version.
>
> So, I decided to send you this email, c/c a random list of people that I
> believe are involved on the submit and/or review process of those
> patches, in the hope to better understand and to discuss what's happening
> and how can we speedup the merge process of those patches.

I have proposed this before, but I'll do it again: I'm more than happy to be 
the official person who collects and organizes the omap and davinci patches 
for you and who does the initial reviews. This is effectively already the 
case since I've been reviewing both omap and davinci patches pretty much 
from the beginning.

Both the omap2/3 display driver and the davinci drivers are now very close 
to be ready for inclusion in the kernel as my last reviews only found some 
minor things.

Part of the reason for the delays for both omap and davinci was that they 
had to be modified for v4l2_subdev, which was an absolute necessity, and 
because they simply needed quite a bit of work to make them suitable for 
inclusion in the kernel.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
