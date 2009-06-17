Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:30979 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbZFQRlL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 13:41:11 -0400
Message-ID: <4A392A90.2060509@nokia.com>
Date: Wed, 17 Jun 2009 20:40:32 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
Reply-To: sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Brijesh Jadav <brijesh.j@ti.com>,
	Chaithrika Subrahmanya <chaithrika@ti.com>,
	"Cohen David.A (Nokia-D/Helsinki)" <david.cohen@nokia.com>,
	Dominic Curran <dcurran@ti.com>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
	Hardik Shah <hardik.shah@ti.com>,
	Hari Nagalla <hnagalla@ti.com>, Manjunath Hadli <mrh@ti.com>,
	"Hurskainen Mikko (Nokia-D/Helsinki)" <mikko.hurskainen@nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Nishanth Menon <nm@ti.com>, R Sivaraj <sivaraj@ti.com>,
	Sandeep Paulraj <s-paulraj@ti.com>,
	Sergio Alberto Aguirre Rodriguez <saaguirre@ti.com>,
	"Valkeinen Tomi (Nokia-D/Helsinki)" <Tomi.Valkeinen@nokia.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: OMAP patches for linux-media
References: <20090616104018.44075a80@pedra.chehab.org>
In-Reply-To: <20090616104018.44075a80@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Hi Sakari and others,

Hi, Mauro!

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

There are a few reasons for apparent stalling of the development 
process. I should have sent a status update earlier.

The code quality of the ISP driver was originally quite low and from 
that part it wouldn't have made much sense to repeatedly post that for 
reviewing. It's been improving since many of the subdrivers have been 
refactored or rewritten since I last posted the patchset. The end result 
should be (more?) easily understood by human beings...

Another reason for no upstream patches is that we are still depending on 
the obsolete v4l2-int-device in the camera / sensor / lens / flash 
driver interface. Hans' opinion was that we must switch to v4l2_subdev 
instead with which I fully agree. However, due to our internal reasons 
we have not been able to even start that transition process yet.

There is no definite deadline for the v4l2_subdev transition (or even 
its start) at the moment. I'm planning to update the patchset in 
Gitorious, however.

Best regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
