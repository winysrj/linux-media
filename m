Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59357 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab0AHJHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 04:07:06 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 8 Jan 2010 14:36:09 +0530
Subject: RE: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting ccdc drivers
	to platform driver
Message-ID: <19F8576C6E063C45BE387C64729E7394044A398045@dbde02.ent.ti.com>
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
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40162D43371@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: davinci-linux-open-source-bounces@linux.davincidsp.com
> [mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On
> Behalf Of Karicheri, Muralidharan
> Sent: Friday, January 08, 2010 4:55 AM
> To: Kevin Hilman
> Cc: davinci-linux-open-source@linux.davincidsp.com; linux-
> media@vger.kernel.org
> Subject: RE: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting ccdc
> drivers to platform driver
> 
> Arch patches are not usually merged in Hans tree.
> 
[Hiremath, Vaibhav] Hi Kevin and Murali,

Sorry for jumping into this discussion so late, 

Can we use clk_add_alias() function exported by clkdev.c file here? With this board specific file can define aliases for all required platform_data keeping CLK() entry generic.

Thanks,
Vaibhav

> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> phone: 301-407-9583
> email: m-karicheri2@ti.com
> 
> >-----Original Message-----
> >From: Kevin Hilman [mailto:khilman@deeprootsystems.com]
> >Sent: Thursday, January 07, 2010 4:50 PM
> >To: Karicheri, Muralidharan
> >Cc: linux-media@vger.kernel.org; hverkuil@xs4all.nl; davinci-linux-
> open-
> >source@linux.davincidsp.com
> >Subject: Re: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting
> ccdc
> >drivers to platform driver
> >
> >"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:
> >
> >> Can I remove it through a separate patch? This patch is already
> merged in
> >Hans tree.
> >
> >Hmm, arch patches should not be merged yet as I have not ack'd
> them.
> >
> >Kevin
> >
> >
> >>>-----Original Message-----
> >>>From: Kevin Hilman [mailto:khilman@deeprootsystems.com]
> >>>Sent: Thursday, January 07, 2010 2:44 PM
> >>>To: Karicheri, Muralidharan
> >>>Cc: linux-media@vger.kernel.org; hverkuil@xs4all.nl; davinci-
> linux-open-
> >>>source@linux.davincidsp.com
> >>>Subject: Re: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting
> ccdc
> >>>drivers to platform driver
> >>>
> >>>"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:
> >>>
> >>>> Kevin,
> >>>>
> >>>>>
> >>>>>OK, I'm not extremely familar with the whole video architecture
> here,
> >>>>>but are all of these drivers expected to be doing clk_get() and
> >>>>>clk_enable()?
> >>>>>
> >>>>
> >>>> [MK]Many IPs on DaVinci VPFE would require vpss master clock.
> So
> >>>> it is better to do the way I have done in my patch. So it is
> expected
> >>>> that clk_get, clk_enable etc are called from other drivers as
> well.
> >>>
> >>>OK, then you are expecting to add clkdev nodes for the other
> devices
> >>>as well.  That's ok.
> >>>
> >>>However, you still haven't answered my original question.
> AFAICT,
> >>>there are no users of the clkdev nodes "vpss_master" and
> "vpss_slave".
> >>>Why not remove those and replace them with your new nodes instead
> of
> >>>leaving them and adding new ones?
> >>>
> >>>Kevin
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-
> source
