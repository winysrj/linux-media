Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:47165 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbZI3BfV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2009 21:35:21 -0400
Subject: What is the near term future for kfifo?
From: Andy Walls <awalls@radix.net>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <1254096732.22211.9.camel@morgan.walls.org>
References: <1254023141.6346.46.camel@palomino.walls.org>
	 <4ABF6BA9.8000906@gmail.com> <1254060600.3152.20.camel@palomino.walls.org>
	 <4ABF99B6.5090200@kernellabs.com>
	 <1254075277.3554.8.camel@morgan.walls.org>
	 <1254081645.3554.15.camel@morgan.walls.org>
	 <1254096732.22211.9.camel@morgan.walls.org>
Content-Type: text/plain
Date: Tue, 29 Sep 2009 21:38:09 -0400
Message-Id: <1254274689.5510.20.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LKML,

What's the status of the recently proposed kfifo changes?

This change set of mine, for implementing IR receiver support for the
CX23888 chip:

On Sun, 2009-09-27 at 20:12 -0400, Andy Walls wrote:
> Mauro,
> 
> Please pull from http://linuxtv.org/hg/~awalls/cx23888-ir-part2
> 
> for the following 5 changesets:
> 
> 01/05: v4l2-subdev: Add v4l2_subdev_ir_ops and IR notify defines for v4l2_device
> http://linuxtv.org/hg/~awalls/cx23888-ir-part2?cmd=changeset;node=8cbb951bbb9f
> 
> 02/05: cx23885: Complete CX23888 IR subdev implementation for Rx & almost for Tx
> http://linuxtv.org/hg/~awalls/cx23888-ir-part2?cmd=changeset;node=a2d8d3d88c6d
> 
> 03/05: cx23885: Add integrated IR subdevice interrupt and notification handling
> http://linuxtv.org/hg/~awalls/cx23888-ir-part2?cmd=changeset;node=1eb199665dbc
> 
> 04/05: ir-functions: Export ir_rc5_decode() for use by the cx23885 module
> http://linuxtv.org/hg/~awalls/cx23888-ir-part2?cmd=changeset;node=55a1e2e8128f
> 
> 05/05: cx23885: Add IR input keypress handling and enable for the HVR-1850
> http://linuxtv.org/hg/~awalls/cx23888-ir-part2?cmd=changeset;node=b05a093688a2


relies on the current implementation

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=include/linux/kfifo.h;h=ad6bdf5a5970c5fdbceb6b5c440a196b7a620b22;hb=HEAD

that still requires a spinlock.  Fortunately, I happen to need a
spinlock.


I'd like this changeset to move forward, and I don't want to have a
problem with unfortuante timing of any kfifo changes.

Should I plan to

1. leave my code alone and use the current kfifo API,
2. update my use of kfifo to the new proposal I saw on the LKML
recently, or
3.  just write my own fifo implementation and port to the new kfifo
later?


Regards,
Andy

