Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbZGVJkL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 05:40:11 -0400
Date: Wed, 22 Jul 2009 11:40:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
Cc: kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Frederic CAND <frederic.cand@anevia.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@linuxtv.org>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Oleg Roitburd <oroitburd@gmail.com>,
	Yang Hongyang <yanghy@cn.fujitsu.com>,
	Jelle Foks <jelle@foks.us>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media/video/cx88: adding __init/__exit macros to cx88
 drivers
In-Reply-To: <200907221136.30036.PeterHuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.0907221138520.11648@wotan.suse.de>
References: <200907170100.02816.PeterHuewe@gmx.de> <200907221136.30036.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1656527655-1248255610=:11648"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1656527655-1248255610=:11648
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 22 Jul 2009, Peter Hüwe wrote:

> > Trivial patch which adds the __init and __exit macros to the 
> > module_init / module_exit functions to several files in 
> > drivers/media/video/cx88/
> >
> > linux version 2.6.31-rc3 - linus git tree
> >
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> any updates on this patch?
> 
> If my minor fixes bug you too much please give me a hint how I can improve my 
> patches.

Well the minor issue is that when you send trivial patches to 
trivial@kernel.org and also to all the involved maintainers, I am waiting 
for them to apply them into their trees and only if this doesn't happen 
after some time (I check regularly, but not very frequently), I apply to 
trivial queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs
--168427776-1656527655-1248255610=:11648--
