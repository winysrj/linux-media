Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:29489 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab1ASNu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 08:50:58 -0500
Date: Wed, 19 Jan 2011 14:50:02 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mike Isely <isely@isely.net>, Jarod Wilson <jarod@wilsonet.com>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Message-ID: <20110119145002.6f94f800@endymion.delvare>
In-Reply-To: <1295444282.4317.20.camel@morgan.silverblock.net>
References: <1295205650.2400.27.camel@localhost>
	<1295234982.2407.38.camel@localhost>
	<848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com>
	<1295439718.2093.17.camel@morgan.silverblock.net>
	<alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net>
	<1295444282.4317.20.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Andy,

On Wed, 19 Jan 2011 08:38:02 -0500, Andy Walls wrote:
> As I understand it, the rules/guidelines for I2C probing are now
> something like this:
> 
> 1. I2C device driver modules (ir-kbd-i2c, lirc_zilog, etc.) should not
> do hardware probes at all.  They are to assume the bridge or platform
> drivers verified the I2C slave hardware's existence somehow.
> 
> 2. Bridge drivers (pvrusb, hdpvr, cx18, ivtv, etc.) should not ask the
> I2C subsystem to probe hardware that it knows for sure exists, or knows
> for sure does not exist.  Just add the I2C device or not.
> 
> 3. Bridge drivers should generally ask the I2C subsystem to probe for
> hardware that _may_ exist.
> 
> 4. If the default I2C subsystem hardware probe method doesn't work on a
> particular hardware unit, the bridge driver may perform its own hardware
> probe or provide a custom hardware probe method to the I2C subsystem.
> hdpvr and pvrusb2 currently do the former.

Yes, that's exactly how things are supposed to work now. And hopefully
it makes sense and helps you all write cleaner code (that was the
intent at least.)

-- 
Jean Delvare
