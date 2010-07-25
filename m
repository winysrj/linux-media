Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:62115 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868Ab0GYNWP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jul 2010 09:22:15 -0400
Subject: Re: cx23885: Unknown symbol __ir_input_register
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, vvvl@onet.pl
In-Reply-To: <1280061846.2867.5.camel@localhost>
References: <Q8994360-053833478ce51cd1e8a0a45c0f796b50@pmq4.m5r2.onet.test.onet.pl>
	 <1280061846.2867.5.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Jul 2010 09:22:37 -0400
Message-ID: <1280064157.2867.15.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-07-25 at 08:44 -0400, Andy Walls wrote:
> On Sat, 2010-07-24 at 18:45 +0200, vvvl@onet.pl wrote:
> > with linux-2.6.34-gentoo-r1 and V4L/DVB repository of July 24 I get these errors:
> > cx23885: Unknown symbol __ir_input_register
> > cx23885: Unknown symbol get_rc_map
> 
> Those are IR related.
> 
> I forgot to add "IR_CORE" to the Kconfig file for the cx23885 driver,
> but the the "VIDEO_IR" selection in that Kconfig depends on "IR_CORE",
> so I think that should be OK.

Hmmm...

"select VIDEO_IR" in the cx23885 Kconfig doesn't revisit the
dependencies on "IR_CORE" and "INPUT".


Mauro,

What's the correct thing to do here?

Change it to

	"depends VIDEO_IR"

or add

	"depends IR_CORE"

or add

	"select INPUT"
	"select IR_CORE"


The first is easiet to maintain, but might have something built
in-kernel vs. module in the wrong order.

The second repeats a known dependency, expressed elsewhere, which will
have to be kept in sync (and could still get the build wrong).

The third repeats more known dependencies, expressed elsewhere, which
will have to be kept in sync, but at least the build should always have
the right components built in-kernel.


Or do I misunderstand the select & depends keywords?

Regards,
Andy

