Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49287 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbZHONss (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2009 09:48:48 -0400
Subject: Re: Status of cx18 drivers, mercurial vs in-kernel
From: Andy Walls <awalls@radix.net>
To: Dale Pontius <DEPontius@edgehp.net>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
In-Reply-To: <4A7F3813.3050101@edgehp.net>
References: <4A7F3813.3050101@edgehp.net>
Content-Type: text/plain
Date: Sat, 15 Aug 2009 09:46:48 -0400
Message-Id: <1250344008.4039.20.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-08-09 at 16:56 -0400, Dale Pontius wrote:
> I've been running the cx18 drivers out of mercurial since getting my
> HVR-1600 running, almost a year ago.  As I see things, the driver is
> pretty mature now, and in fact I see commits for cx18 in 2.6.31 that are
> some of the last I saw going into the "regular" driver in mercurial.
> (I'm not counting the diagnostic work that has been going on in the last
> month or two, for one particular user.)
> 
> Is it reasonable to go with the in-kernel cx18 driver when 2.6.31 goes
> stable, or is there still significant value with sticking with mercurial?

As long as 2.6.31. has the following changes, then go with 2.6.31:

1. per stream queue mutex locks changed to per quueue spinlocks, and an
outgoing message work handling thread was added

2. front end SIF audio AGC actually uses the SIF signal for setting the
SIF audio AGC

3. Sliced VBI works and can be enabled for insertion into all MPEG II PS
type streams

These were that last major fixes I can think of that made a difference
for anyone.  I'd imagine they are all in 2.6.31 by now, but I haven't
checked.

I don't know of any existing major problems with the cx18 driver itself.
The bad problems that seems to crop up now are usuaully system level
issues: a vmalloc pool that is too small, sharing an interrupt line with
another linux driver that has an interrupt handler with a poor response
time, etc.

Future changes to the cx18 driver might include:

1. MPEG Index support
2. Dual-watch audio support
3. Additional cards type or fixing up exsting broken entries 
4. Sliced VBI in an MPEG TS stream (maybe)

Regards,
Andy


> Dale Pontius


