Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:19070 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996Ab0G2BZm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 21:25:42 -0400
Subject: Re: cx23885: Unknown symbol __ir_input_register
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, vvvl@onet.pl
In-Reply-To: <4C4C7AAF.6010902@redhat.com>
References: <Q8994360-053833478ce51cd1e8a0a45c0f796b50@pmq4.m5r2.onet.test.onet.pl>
	 <1280061846.2867.5.camel@localhost> <1280064157.2867.15.camel@localhost>
	 <4C4C7AAF.6010902@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 21:26:06 -0400
Message-ID: <1280366766.2392.19.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-07-25 at 14:55 -0300, Mauro Carvalho Chehab wrote:
> Em 25-07-2010 10:22, Andy Walls escreveu:
> > On Sun, 2010-07-25 at 08:44 -0400, Andy Walls wrote:
> >> On Sat, 2010-07-24 at 18:45 +0200, vvvl@onet.pl wrote:

 
> > Or do I misunderstand the select & depends keywords?
> 
> IMHO, we need to re-work at the IR dependencies. The better is to not use
> "select". The proper solution seems to re-work on the existing drivers to allow
> them to work with IR disabled via Kconfig.
> 
> So, if IR support were compiled, it will enable the *-input. Otherwise, the driver
> will keep compiling, but without IR.

Ack.  That's the smart thing to do.  I'll try to work on that when I
finally get IR Tx ironed out.

Regards,
Andy

> Cheers,
> Mauro.


