Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50398 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZGVLzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 07:55:21 -0400
Date: Wed, 22 Jul 2009 08:54:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter =?ISO-8859-1?B?SPx3ZQ==?= <PeterHuewe@gmx.de>,
	kernel-janitors@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
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
Message-ID: <20090722085436.6ebd43c1@pedra.chehab.org>
In-Reply-To: <alpine.LNX.2.00.0907221138520.11648@wotan.suse.de>
References: <200907170100.02816.PeterHuewe@gmx.de>
	<200907221136.30036.PeterHuewe@gmx.de>
	<alpine.LNX.2.00.0907221138520.11648@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 22 Jul 2009 11:40:08 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> escreveu:

> On Wed, 22 Jul 2009, Peter Hüwe wrote:
> 
> > > Trivial patch which adds the __init and __exit macros to the 
> > > module_init / module_exit functions to several files in 
> > > drivers/media/video/cx88/
> > >
> > > linux version 2.6.31-rc3 - linus git tree
> > >
> > > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > any updates on this patch?

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > If my minor fixes bug you too much please give me a hint how I can improve my 
> > patches.
> 
> Well the minor issue is that when you send trivial patches to 
> trivial@kernel.org and also to all the involved maintainers, I am waiting 
> for them to apply them into their trees and only if this doesn't happen 
> after some time (I check regularly, but not very frequently), I apply to 
> trivial queue.

Jiri,

Are you applying it via trivial tree, or do you prefer if I apply this patch at
linux-media one?

-- 

Cheers,
Mauro
