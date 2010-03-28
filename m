Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53778 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755337Ab0C1XIV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 19:08:21 -0400
Subject: Re: What would be a good time to move subdev drivers to a subdev
 directory?
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
In-Reply-To: <201003281803.22405.hverkuil@xs4all.nl>
References: <201003281224.17678.hverkuil@xs4all.nl>
	 <4BAF77F7.3070205@redhat.com>  <201003281803.22405.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sun, 28 Mar 2010 19:08:23 -0400
Message-Id: <1269817703.21755.12.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-03-28 at 18:03 +0200, Hans Verkuil wrote:
> On Sunday 28 March 2010 17:38:31 Mauro Carvalho Chehab wrote:
> > Hans Verkuil wrote:

> > So, let's get some feedback from developers about this again. Whatever decided,
> > we should clearly document the used criteria, to avoid having drivers misplaced.
> 
> 1) Reusable subdev drivers go into the subdev directory.

OK by me.

I will note the cx25840 module is used stand-alone and by the cx23885
and cx231xx drivers as an integrated A/V core.  However the integrated
core is internally I2C connected so it's fairly loosely coupled.  I
don't see a problem with the cx25840 module being pushed into a subdev
directory.


> 2) Subdev drivers that are tightly coupled to a bridge or platform driver go
> into the subdirectory containing that bridge or platform driver.

Ack.


> Rule 1 applies to roughly 50 subdev drivers.
> 
> I wonder if for rule 2 we should require that subdev drivers would go into a
> <bridge driver>/subdev directory. It would help in keeping track of what is what,
> but this may be overkill.

NAK.  That is overkill.



BTW, here are some exceptional cases to ponder:

Where does the cx2341x module go?  It is common code used by ivtv, cx18,
and cx23885 (and probably cx88), but it is not a subdevice.  

Also some code in cx23885/cx23888-ir.c could be broken out and shared
between the cx25840, cx18, and cx231xx modules since it is the same IR
hardware (mostly), but connected to the bridge chip differently.  Where
would that go?

Regards,
Andy

