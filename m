Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60324 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab0AKEg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 23:36:57 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 11 Jan 2010 10:06:47 +0530
Subject: RE: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting ccdc drivers
 to platform driver
Message-ID: <19F8576C6E063C45BE387C64729E7394044A398230@dbde02.ent.ti.com>
References: <1260895054-13232-1-git-send-email-m-karicheri2@ti.com>
	<871vi4rv25.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162C23952@dlee06.ent.ti.com>
	<87k4vvkyo7.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162C23A3E@dlee06.ent.ti.com>
	<878wcbkx60.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162D43099@dlee06.ent.ti.com>
	<87r5q1ya2w.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162D43287@dlee06.ent.ti.com>
	<87my0pwpnk.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162D43371@dlee06.ent.ti.com>
	<19F8576C6E063C45BE387C64729E7394044A398045@dbde02.ent.ti.com>
 <87zl4oskd9.fsf@deeprootsystems.com>
In-Reply-To: <87zl4oskd9.fsf@deeprootsystems.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Kevin Hilman [mailto:khilman@deeprootsystems.com]
> Sent: Friday, January 08, 2010 8:40 PM
> To: Hiremath, Vaibhav
> Cc: Karicheri, Muralidharan; davinci-linux-open-
> source@linux.davincidsp.com; linux-media@vger.kernel.org
> Subject: Re: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting ccdc
> drivers to platform driver
> 
> "Hiremath, Vaibhav" <hvaibhav@ti.com> writes:
> 
> >>
> > [Hiremath, Vaibhav] Hi Kevin and Murali,
> >
> > Sorry for jumping into this discussion so late,
> >
> > Can we use clk_add_alias() function exported by clkdev.c file
> here?
> > With this board specific file can define aliases for all required
> > platform_data keeping CLK() entry generic.
> 
> Yes, this would be a good use case clk_add_alias()
> 
[Hiremath, Vaibhav] Thanks Kevin, actually I am already using the clk_add_alias in AM3517 which used same VPFE_Capture driver. But I was not sure whether this is acceptable or not, since nobody in the kernel is using this API.
Thanks for conforming/clarifying; I will submit the patch now for this.

Thanks,
Vaibhav

> Kevin

