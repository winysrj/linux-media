Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46210 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab0FCPdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jun 2010 11:33:43 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Thu, 3 Jun 2010 21:03:27 +0530
Subject: RE: [PATCH-V1 1/2] Davinci: Create seperate Kconfig file for
 davinci devices
Message-ID: <19F8576C6E063C45BE387C64729E7394044E6D3278@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
	<1275547321-31406-2-git-send-email-hvaibhav@ti.com>
 <20100603082643.83293005.rdunlap@xenotime.net>
In-Reply-To: <20100603082643.83293005.rdunlap@xenotime.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> Sent: Thursday, June 03, 2010 8:57 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; mchehab@redhat.com; Karicheri,
> Muralidharan; linux-omap@vger.kernel.org
> Subject: Re: [PATCH-V1 1/2] Davinci: Create seperate Kconfig file for
> davinci devices
> 
> On Thu,  3 Jun 2010 12:12:00 +0530 hvaibhav@ti.com wrote:
> 
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > Currently VPFE Capture driver and DM6446 CCDC driver is being
> > reused for AM3517. So this patch is preparing the Kconfig/makefile
> > for re-use of such IP's.
> 
> Hi,
> What are "IP's"?
> 
[Hiremath, Vaibhav] Actually we have various DM series devices and IP's from it are being re-used for some of the OMAP/AM/DM devices as well. We do have some AM18x/AM17x parts which are coming to list in the near future which will again re-use drivers from here.

Thanks,
Vaibhav

> thanks,
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
