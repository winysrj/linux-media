Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:43731 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750797Ab0FCPhO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 11:37:14 -0400
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-media@vger.kernel.org>; Thu, 3 Jun 2010 08:37:12 -0700
Date: Thu, 3 Jun 2010 08:37:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH-V1 1/2] Davinci: Create seperate Kconfig file for
 davinci devices
Message-Id: <20100603083712.836dc89e.rdunlap@xenotime.net>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044E6D3278@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
	<1275547321-31406-2-git-send-email-hvaibhav@ti.com>
	<20100603082643.83293005.rdunlap@xenotime.net>
	<19F8576C6E063C45BE387C64729E7394044E6D3278@dbde02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 3 Jun 2010 21:03:27 +0530 Hiremath, Vaibhav wrote:

> 
> > -----Original Message-----
> > From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> > Sent: Thursday, June 03, 2010 8:57 PM
> > To: Hiremath, Vaibhav
> > Cc: linux-media@vger.kernel.org; mchehab@redhat.com; Karicheri,
> > Muralidharan; linux-omap@vger.kernel.org
> > Subject: Re: [PATCH-V1 1/2] Davinci: Create seperate Kconfig file for
> > davinci devices
> > 
> > On Thu,  3 Jun 2010 12:12:00 +0530 hvaibhav@ti.com wrote:
> > 
> > > From: Vaibhav Hiremath <hvaibhav@ti.com>
> > >
> > > Currently VPFE Capture driver and DM6446 CCDC driver is being
> > > reused for AM3517. So this patch is preparing the Kconfig/makefile
> > > for re-use of such IP's.
> > 
> > Hi,
> > What are "IP's"?
> > 
> [Hiremath, Vaibhav] Actually we have various DM series devices and IP's from it are being re-used for some of the OMAP/AM/DM devices as well. We do have some AM18x/AM17x parts which are coming to list in the near future which will again re-use drivers from here.

Since you didn't answer the question:

So IP's are Intellectual Property logic blocks?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
