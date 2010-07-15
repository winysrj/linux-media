Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:58231 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934480Ab0GOWHh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jul 2010 18:07:37 -0400
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [PATCH 24/25] video/ivtv: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Fri, 16 Jul 2010 00:00:51 +0200
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ian Armstrong <ian@iarmst.demon.co.uk>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Steven Toth <stoth@kernellabs.com>, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201007152108.27175.PeterHuewe@gmx.de> <1279230200.7920.23.camel@morgan.silverblock.net>
In-Reply-To: <1279230200.7920.23.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007160000.52153.PeterHuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag 15 Juli 2010 23:43:20 schrieb Andy Walls:
> > ... use the PCI_VDEVICE macro, and thus improves readability.
> I have to disagree.  The patch may improve typesetting, but it degrades
> clarity and maintainability from my perspective.
> ...
> So I'm going to NAK this for ivtv, unless someone can help me understand
> any big picture benefit that I may not see from my possibly myopic
> perspective.

Hi Andy,

absolutely no problem ;) - I thing that is one of the great things about open 
source that people can have different opinions and discuss them.

Patches are proposals only, and if I spark a discussion which brings the 
development process further or from which I can learn something, I'm a lucky 
guy ;)

> PCI_ANY_ID indicates to the reader a wildcard match is being
> performed. 
Yeah, but I get absolutely no information out of the 0, 0, parameters either - 
unless I look up the function - but then I could also look up the Macro.

> BTW, I have not seen a similar patch come in my mailbox for
> cx18-driver.c.  Why propose the change for ivtv and not cx18?

That might be the case since I picked out several different locations using 
cscope (by gut instinct) - so the patchset is not comprehensive. 
There are still a lot of places that are not converted, I just picked some at 
random and stopped at 25 patches.
The reason behind this was that I almost expected some kind of controversy and 
discussion about the changes - and since I'm getting some NACKs I guess this 
was a smart move - imagine I had converted the whole kernel source just to get 
a simple NACK ;)

Thanks,
Peter











