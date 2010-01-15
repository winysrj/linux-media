Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52327 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab0AOMBj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 07:01:39 -0500
Subject: Fix for breakage caused by kfifo backport
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 15 Jan 2010 07:00:55 -0500
Message-Id: <1263556855.3059.10.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

At 

http://linuxtv.org/hg/~awalls/cx23885-ir2

I have a change checked in to fix the v4l-dvb compilation breakage for
kernels less than 2.6.33 cause by the kfifo API change.  I have fixed
both the cx23885 and meye driver so they compile again for older
kernels.

All the changes in this repo are OK to PULL as is, even though I haven't
finished all the changes for the TeVii S470 IR  (I was planning on a
PULL request late this evening EST).  You can also just cherry pick the
one that fixes the kfifo problem if you want.

[I was unaware of the timing of the backport, but since it was stopping
me from working, I fixed it as I thought appropriate.  Please feel free
to contact me on any backport changes that have my fingerprints all over
it, with which you would like help.  I'd like to help minimize the
impact to users, testers, and developers, who may not have the bleeding
edge kernel - or at least the impact to me ;) ]


Regards,
Andy

