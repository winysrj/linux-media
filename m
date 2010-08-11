Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:35564 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757423Ab0HKXLM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Aug 2010 19:11:12 -0400
Subject: Re: [linux-dvb] Looking for an analogic TV tuner card
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <201008102103.39852.henry.nicolas@tourneur.be>
References: <201008102103.39852.henry.nicolas@tourneur.be>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 19:11:49 -0400
Message-ID: <1281568309.2419.57.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, 2010-08-10 at 21:03 +0200, Tourneur Henry-Nicolas wrote:
> Hello everybody,
> 
> I'm looking for an analogic, PAL compatible, TV tuner card (PCI or PCI express) that should work out of the box
> with Linux kernel (version doesn't matter if it's stable release).
> 
> A great plus would be a card with 2 tuners, more if it exists.
> 
> Could you please give me some feedback, informations ?

Given no other information: PVR-500

The PVR-500 is PCI, has 2 analog tuners, two CX23416 MPEG encoding
engines, and is well supported by the ivtv driver.  Finding new units
with NTSC tuners will be hard, due to FCC rules in North America.  I do
not know about the availability of new units with PAL tuners, but I
suspect they may be easier to obtain.

You did not specify the userspace application you use.

Regards,
Andy

> Kind regards,
> 
> Henry-Nicolas


