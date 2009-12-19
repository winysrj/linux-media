Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:41605 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZLSDTb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 22:19:31 -0500
Date: Fri, 18 Dec 2009 19:18:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 19 (media/mantis)
Message-Id: <20091218191859.ca78c2f1.randy.dunlap@oracle.com>
In-Reply-To: <20091219110457.d6c5de1f.sfr@canb.auug.org.au>
References: <20091219110457.d6c5de1f.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 19 Dec 2009 11:04:57 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> I said:
> > News:  there will be no linux-next releases until at least Dec 24 and,
> > more likely, Dec 29.  Have a Merry Christmas and take a break.  :-)
> 
> Well, I decided I had time for one more so it will be based in -rc1).
> 
> This one has not had the build testing *between* merges, but has had all
> the normal build testing at the end.  Since the latter testing showed no
> problems, this just means that there may be more unbisectable points in
> the tree (but that is unlikely).



ERROR: "ir_input_register" [drivers/media/dvb/mantis/mantis_core.ko] undefined!
ERROR: "ir_input_unregister" [drivers/media/dvb/mantis/mantis_core.ko] undefined!
ERROR: "ir_input_init" [drivers/media/dvb/mantis/mantis_core.ko] undefined!
ERROR: "input_free_device" [drivers/media/dvb/mantis/mantis_core.ko] undefined!
ERROR: "input_allocate_device" [drivers/media/dvb/mantis/mantis_core.ko] undefined!



CONFIG_INPUT=n


---
~Randy
