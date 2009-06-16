Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42081 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbZFPNka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 09:40:30 -0400
Date: Tue, 16 Jun 2009 10:40:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sakari Ailus <sakari.ailus@nokia.com>
Cc: Brijesh Jadav <brijesh.j@ti.com>,
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
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: OMAP patches for linux-media
Message-ID: <20090616104018.44075a80@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari and others,

I'm seeing lots of patches and discussions for OMAP and DaVinci being handled
at the linux-media Mailing List, as part of the development process of the open
source drivers.

However, it is hard to track all those discussions and be sure what patches are
ready for merging and what patches are just RFC.

On the development model we use here, we have driver maintainers that are
responsible to discuss about improvements on their drivers. They are generally
the driver authors or the one that first started submitting the patches for
that driver(s). 

One of the roles of the driver maintainers is to collect the patches for the
drivers they maintain, merge on their trees, and periodically ask the patch
merge. 

One fundamental concept on Kernel development is the concept of "Commit earlier
and commit often", meaning that the better is to send small, incremental, and
periodic patches, than wait until having everything done, then submit a big
patch. Every time I receive a big patch I need to postpone its analysis and
open a big window on my schedule to analyze it. Of course, this means to
postpone it, and generally results on lots of comments going back to developer,
that, in turn, will need to do lots of changes and return me back with another
big patch for me to analyze again, resulting on a long period of time for
merging it.

As you, Sakari, was the first one that started merging the OMAP drivers, I was
expecting that you would be the one that will handle the figure of the driver
maintainer for OMAP. I even created you an account at linuxtv for you to create
your trees there and ask me to merge from it.

Unfortunately, you haven't sent me any pull requests yet along this year. This
is concerning me a lot, since, at the end, I'll need to review big piles of
patches and/or drivers when you decide to submit the final version.

So, I decided to send you this email, c/c a random list of people that I
believe are involved on the submit and/or review process of those patches, in
the hope to better understand and to discuss what's happening and how can we
speedup the merge process of those patches.



Cheers,
Mauro
