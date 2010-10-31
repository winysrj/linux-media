Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:42465 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335Ab0JaBVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Oct 2010 21:21:18 -0400
Subject: Re: [PATCH] bttv driver memory corruption
From: Andy Walls <awalls@md.metrocast.net>
To: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
Cc: Laurent Birtz <laurent.birtz@usherbrooke.ca>,
	linux-media@vger.kernel.org
In-Reply-To: <20101030234045.GA15147@minime.bse>
References: <4CC5A390.9010800@usherbrooke.ca>
	 <20101030234045.GA15147@minime.bse>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 21:21:37 -0400
Message-ID: <1288488097.23860.33.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sun, 2010-10-31 at 01:40 +0200, Daniel Glöckner wrote:
> On Mon, Oct 25, 2010 at 11:34:40AM -0400, Laurent Birtz wrote:
> > I've observed that the poison was corrupted at some random pages, but
> > always in the first four bytes. The value of those bytes is 0x23232323.
> > This byte sequence often appears in kernel oops reports on my setup.


> I couldn't verify your findings by mallocing an equivalent of the
> physical memory, filling everything with 0xdeadbeef, and then
> periodically checking it didn't change while watching tv at 768x576
> in YUY2.
> 

Here are other apparent instances with bttv:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-08/2233.html
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg247084.html
http://kerneltrap.org/mailarchive/linux-kernel/2008/11/19/4214764
http://lkml.org/lkml/2006/6/2/16
http://lkml.indiana.edu/hypermail/linux/kernel/0407.0/1124.html
http://fixunix.com/kernel/323946-bug-unable-handle-kernel-paging-request-virtual-address.html


BTW, I did notice that
drivers/acpi/acpica/utglobal.c:acpi_ut_get_node_name() has a
return("####"); statement in it explicitly.  0x23232323 is "####" in
ASCII.  It could possibly be the case that anything that calls that
function could be a source of those "####" bytes.  Although the initial
patch submission comments make that seem unlikely.

Regards,
Andy

> Which video mode and resolution did you use in your tests?
> Did you try loading bttv with triton1=1 and vsfx=1?
> 
>   Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


