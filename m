Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:64426 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZLSSaj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2009 13:30:39 -0500
Date: Sat, 19 Dec 2009 10:30:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
Subject: Re: linux-next: Tree for December 19 (media/mantis)
Message-Id: <20091219103045.32e1b971.randy.dunlap@oracle.com>
In-Reply-To: <1a297b360912190911v77b8519dtd5a93556a8693dd9@mail.gmail.com>
References: <20091219110457.d6c5de1f.sfr@canb.auug.org.au>
	<20091218191859.ca78c2f1.randy.dunlap@oracle.com>
	<1a297b360912190911v77b8519dtd5a93556a8693dd9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 19 Dec 2009 21:11:50 +0400 Manu Abraham wrote:

> On Sat, Dec 19, 2009 at 7:18 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Sat, 19 Dec 2009 11:04:57 +1100 Stephen Rothwell wrote:
> >
> >> Hi all,
> >>
> >> I said:
> >> > News:  there will be no linux-next releases until at least Dec 24 and,
> >> > more likely, Dec 29.  Have a Merry Christmas and take a break.  :-)
> >>
> >> Well, I decided I had time for one more so it will be based in -rc1).
> >>
> >> This one has not had the build testing *between* merges, but has had all
> >> the normal build testing at the end.  Since the latter testing showed no
> >> problems, this just means that there may be more unbisectable points in
> >> the tree (but that is unlikely).
> >
> >
> >
> > ERROR: "ir_input_register" [drivers/media/dvb/mantis/mantis_core.ko] undefined!
> > ERROR: "ir_input_unregister" [drivers/media/dvb/mantis/mantis_core.ko] undefined!
> > ERROR: "ir_input_init" [drivers/media/dvb/mantis/mantis_core.ko] undefined!
> > ERROR: "input_free_device" [drivers/media/dvb/mantis/mantis_core.ko] undefined!
> > ERROR: "input_allocate_device" [drivers/media/dvb/mantis/mantis_core.ko] undefined!
> >
> >
> >
> > CONFIG_INPUT=n
> 
> Attached patch to fix the issue.
> 
> Fix Input dependency for Mantis
> 
> From: Manu Abraham <abraham.manu@gmail.com>
> Signed-off-by: Manu Abraham <manu@linuxtv.org>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

---
~Randy
