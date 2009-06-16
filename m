Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52312 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZFPOYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 10:24:42 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@nokia.com>
CC: "Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Subrahmanya, Chaithrika" <chaithrika@ti.com>,
	David Cohen <david.cohen@nokia.com>,
	"Curran, Dominic" <dcurran@ti.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
	Felipe Balbi <felipe.balbi@nokia.com>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"Nagalla, Hari" <hnagalla@ti.com>, "Hadli, Manjunath" <mrh@ti.com>,
	Mikko Hurskainen <mikko.hurskainen@nokia.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Menon, Nishanth" <nm@ti.com>, "R, Sivaraj" <sivaraj@ti.com>,
	"Paulraj, Sandeep" <s-paulraj@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@nokia.com>,
	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 16 Jun 2009 09:24:14 -0500
Subject: RE: OMAP patches for linux-media
Message-ID: <A24693684029E5489D1D202277BE8944405D0032@dlee02.ent.ti.com>
References: <20090616104018.44075a80@pedra.chehab.org>
In-Reply-To: <20090616104018.44075a80@pedra.chehab.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: Mauro Carvalho Chehab [mchehab@infradead.org]
> Sent: Tuesday, June 16, 2009 8:40 AM
> To: Sakari Ailus
> Cc: Jadav, Brijesh R; Subrahmanya, Chaithrika; David Cohen; Curran, Dominic; Eduardo Valentin; Eero Nurkkala; Felipe Balbi; Shah, Hardik; Nagalla, Hari; Hadli, Manjunath; Mikko Hurskainen; Karicheri, Muralidharan; Menon, Nishanth; R, Sivaraj; Paulraj, Sandeep; Aguirre Rodriguez, Sergio Alberto; Tomi Valkeinen; Tuukka Toivonen; Hiremath, Vaibhav; Hans Verkuil; Linux Media Mailing List
> Subject: OMAP patches for linux-media
> 
> Hi Sakari and others,
> 
> I'm seeing lots of patches and discussions for OMAP and DaVinci being handled
> at the linux-media Mailing List, as part of the development process of the open
> source drivers.
> 
> However, it is hard to track all those discussions and be sure what patches are
> ready for merging and what patches are just RFC.
> 
> On the development model we use here, we have driver maintainers that are
> responsible to discuss about improvements on their drivers. They are generally
> the driver authors or the one that first started submitting the patches for
> that driver(s).
> 
> One of the roles of the driver maintainers is to collect the patches for the
> drivers they maintain, merge on their trees, and periodically ask the patch
> merge.
> 
> One fundamental concept on Kernel development is the concept of "Commit earlier
> and commit often", meaning that the better is to send small, incremental, and
> periodic patches, than wait until having everything done, then submit a big
> patch. Every time I receive a big patch I need to postpone its analysis and
> open a big window on my schedule to analyze it. Of course, this means to
> postpone it, and generally results on lots of comments going back to developer,
> that, in turn, will need to do lots of changes and return me back with another
> big patch for me to analyze again, resulting on a long period of time for
> merging it.
> 
> As you, Sakari, was the first one that started merging the OMAP drivers, I was
> expecting that you would be the one that will handle the figure of the driver
> maintainer for OMAP. I even created you an account at linuxtv for you to create
> your trees there and ask me to merge from it.
> 
> Unfortunately, you haven't sent me any pull requests yet along this year. This
> is concerning me a lot, since, at the end, I'll need to review big piles of
> patches and/or drivers when you decide to submit the final version.
> 
> So, I decided to send you this email, c/c a random list of people that I
> believe are involved on the submit and/or review process of those patches, in
> the hope to better understand and to discuss what's happening and how can we
> speedup the merge process of those patches.

Hi Mauro,

We are currently going through an internal debugging process on new found issues while testing the driver on a proprietary HW/SW platform.

As there is priority for us to find stability in this platforms, we had to put aside a bit the maintenance of the shared patches.

One maybe important news is that I'll be creating a new tree soon to host current OMAP3 and future OMAP4 camera drivers for upstream from TI perspective. My main task will be to maintain this tree in TI, and take care of upstreaming and fixing patches for acceptance by both linux-omap and linux-media lists.

Some of the known to-dos are:
- v4l2_subdev conversion
- Regulator framework usage
- ISP registration as a memory to memory device.

I hope to resume this task soon, and keep in touch with the community on the latest version of patches. I'll let you know when the next version is ready for merge.

Thanks for your concern and time on this.

Regards,
Sergio
> 
> 
> 
> Cheers,
> Mauro
> 
> 