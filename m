Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bcode.com ([150.101.204.108]:49260 "EHLO mail.bcode.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750817AbZFOBBv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 21:01:51 -0400
Date: Mon, 15 Jun 2009 11:01:52 +1000
From: Erik de Castro Lopo <erik@bcode.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Erik de Castro Lopo <Erik@bcode.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: GPL code for Omnivision USB video camera available.
Message-Id: <20090615110152.4c577be7.erik@bcode.com>
In-Reply-To: <4A335F5A.1010305@redhat.com>
References: <20090612110228.3f7e42ab.erik@bcode.com>
	<4A31FB0A.8030104@redhat.com>
	<20090613104524.781027d8.erik@bcode.com>
	<4A335F5A.1010305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 13 Jun 2009 18:12:10 +1000
Hans de Goede <hdegoede@redhat.com> wrote:

> Getting ovfx2 support into the mainline kernel sounds like a good idea!
> 
> I'm not such a big fan of merging the driver as is though, as it does 
> its own buffer management (and ioctl handling, usb interrupt handling, 
> locking, etc).

I understand completely.

> For adding the ovfx2 driver, you could start by copying ov519.c, which
> already has setup and control code fro most ov sensors and then rewrite
> the bridge part to be ovfx2 code, then later we can try to move the 
> sensor code to a shared c file for the ov519 and ovfx2 driver, depending
> on how much you needed to change the sensor code. Or you could add
> support for the ovfx2 to the ov519 driver.
> 
> Note I've recently being doing quite a bit of work on the ov519 driver,
> adding support for the ov511 and ov518 and adding more controls. I'll
> make a mercurial tree available with my latest code in it asap.

Ok, there's the rub. I am simply way too busy at the moment to push this
through myself.

I was hoping I could contract someone to take the existing code and
massage it into shape ready for merging. I would prefer it if that
someone was already a V4L hacker, but if I can't find anyone with
pre-existing V4L experience I'll find someone local with general
Linux kernel/driver experience.

Cheers,
Erik
-- 
=======================
erik de castro lopo
senior design engineer

bCODE
level 2, 2a glen street
milsons point
sydney nsw 2061
australia

tel +61 (0)2 9954 4411
fax +61 (0)2 9954 4422
www.bcode.com
