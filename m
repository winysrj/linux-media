Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:57187 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1CJP4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 10:56:53 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: javier Martin <javier.martin@vista-silicon.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Thu, 10 Mar 2011 21:26:45 +0530
Subject: RE: mt9p031 support for Beagleboard.
Message-ID: <19F8576C6E063C45BE387C64729E739404E1F52A93@dbde02.ent.ti.com>
References: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739404E1F52A8C@dbde02.ent.ti.com>
 <AANLkTi=bkL-LsLn_bJR8DOvJLRu-N+zrmqESiZ0bs=n7@mail.gmail.com>
In-Reply-To: <AANLkTi=bkL-LsLn_bJR8DOvJLRu-N+zrmqESiZ0bs=n7@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: javier Martin [mailto:javier.martin@vista-silicon.com]
> Sent: Thursday, March 10, 2011 9:23 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; Guennadi Liakhovetski
> Subject: Re: mt9p031 support for Beagleboard.
> 
> > [Hiremath, Vaibhav] Martin,
> >
> > All above driver files are not applicable for AM/DM37x ISP camera module,
> you should be looking at driver/media/video/omap3isp/
> >
> Hi,
> Which git repository are you referring to? Because, in last stable
> version there is no such folder:
> http://lxr.linux.no/#linux+v2.6.37.3/drivers/media/video
> 
[Hiremath, Vaibhav] Sorry, probably I should have clarified in last mail itself, 
The media-controller patches are still on their way to main-line, for all latest patches you can refer to the laurent's repository for this -

http://git.linuxtv.org/pinchartl/media.git

Thanks,
Vaibhav

> --
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com
