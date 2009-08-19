Return-path: <linux-media-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:33822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbZHSVhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 17:37:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: suspend tree build warnings
Date: Wed, 19 Aug 2009 23:38:03 +0200
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	pm list <linux-pm@lists.linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <20090819172419.2cf53008.sfr@canb.auug.org.au>
In-Reply-To: <20090819172419.2cf53008.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908192338.03910.rjw@sisk.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 19 August 2009, Stephen Rothwell wrote:
> Hi Rafael,

Hi,

> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> drivers/media/dvb/frontends/dib7000p.c: In function ‘dib7000p_i2c_enumeration’:
> drivers/media/dvb/frontends/dib7000p.c:1315: warning: the frame size of 2256 bytes is larger than 2048 bytes
> drivers/media/dvb/frontends/dib3000mc.c: In function ‘dib3000mc_i2c_enumeration’:
> drivers/media/dvb/frontends/dib3000mc.c:853: warning: the frame size of 2160 bytes is larger than 2048 bytes
> 
> Introduced by commit 99307958cc9c1b0b2e0dad4bbefdafaf9ac5a681 ("PM:
> Introduce core framework for run-time PM of I/O devices (rev. 17)").

Well.

This commit increases the size of struct device quite a bit and both of the
drivers above create a "state" object on the stack that contains struct device
among other things.

I think they should allocate these objects using kmalloc() and I don't know
what I can do about this, really.  Maybe except for modifying the drivers to
use kmalloc().

Thanks,
Rafael
