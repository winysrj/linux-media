Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33477 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbZGVXoo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 19:44:44 -0400
Date: Thu, 23 Jul 2009 01:44:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
	kernel-janitors@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
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
In-Reply-To: <20090722085436.6ebd43c1@pedra.chehab.org>
Message-ID: <alpine.LNX.2.00.0907230144090.11648@wotan.suse.de>
References: <200907170100.02816.PeterHuewe@gmx.de> <200907221136.30036.PeterHuewe@gmx.de> <alpine.LNX.2.00.0907221138520.11648@wotan.suse.de> <20090722085436.6ebd43c1@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Jul 2009, Mauro Carvalho Chehab wrote:

> > > > Trivial patch which adds the __init and __exit macros to the 
> > > > module_init / module_exit functions to several files in 
> > > > drivers/media/video/cx88/
> > > >
> > > > linux version 2.6.31-rc3 - linus git tree
> > > >
> > > > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > > any updates on this patch?
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Thanks a lot Mauro, I have queued the patch in trivial tree.

-- 
Jiri Kosina
SUSE Labs
