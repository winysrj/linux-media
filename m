Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbZDEO4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 10:56:19 -0400
Date: Sun, 5 Apr 2009 11:55:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alan Nisota <alannisota@gmail.com>
Cc: Patrick Boettcher <patrick.boettcher@desy.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Remove support for Genpix-CW3K (damages hardware)
Message-ID: <20090405115539.61d7b600@pedra.chehab.org>
In-Reply-To: <49D3C815.6000004@gmail.com>
References: <49D2338C.7040703@gmail.com>
	<alpine.LRH.1.10.0904010934590.21921@pub4.ifh.de>
	<49D3C815.6000004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Wed, 01 Apr 2009 13:01:25 -0700
Alan Nisota <alannisota@gmail.com> wrote:

> Patrick Boettcher wrote:
> > Hi Alan,
> >
> > Don't you think it is enough to put a Kconfig option to activate the 
> > USB-IDs (by default: off) rather than throwing everything away?
> >
> We could, but honestly, there are likely few people using this device 
> who don't have to patch their kernel anyway, and it is a trivial patch 
> to apply.  There have been 4 incarnations of the CW3K as the 
> manufacturer has tried to actively make it not work in Linux (and users 
> have found ways around that for each subsequent revision).  When I 
> created the patch, I was not aware that the developer would take this 
> stance.  Only the 1st batch of devices works with the existing code, and 
> I'm not aware of any way to detect the device version. 
> 
> Given the manufacturer's stance and the potential to unknowingly damage 
> the device (I've been informed that the manufacturer has stated that use 
> of the Linux drivers with the CW3K will void any manufacturer's 
> warranty), I would rather remove support for this piece of hardware 
> outright.  I believe the manufacturer still supports the 8PSK->USB and 
> Skywalker1 versions of the hardware on Linux (plus a new Skywalker2 
> which requires a kernel patch to enable).

We shouldn't drop support for a device just because the manufacturer doesn't
want it to be supported. If it really damages the hardware or violates the
warranty, then we can print a warning message clearly stating that the vendor
refuses to collaborate, briefly explaining the issues and recommending the user
to replace the device to some other from a vendor-friendly at dmesg, but keep
allowing they to use it, with some force option for people that wants to take
the risk.

This is just my 2 cents.

Cheers,
Mauro
