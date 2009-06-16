Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbZFPQOF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 12:14:05 -0400
Date: Tue, 16 Jun 2009 13:13:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Subrahmanya, Chaithrika" <chaithrika@ti.com>,
	David Cohen <david.cohen@nokia.com>,
	"Curran, Dominic" <dcurran@ti.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
	Felipe Balbi <felipe.balbi@nokia.com>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"Nagalla, Hari" <hnagalla@ti.com>, "Hadli, Manjunath" <mrh@ti.com>,
	Mikko Hurskainen <mikko.hurskainen@nokia.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Menon, Nishanth" <nm@ti.com>, "R, Sivaraj" <sivaraj@ti.com>,
	"Paulraj, Sandeep" <s-paulraj@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@nokia.com>,
	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: OMAP patches for linux-media
Message-ID: <20090616131354.0eee04b4@pedra.chehab.org>
In-Reply-To: <A24693684029E5489D1D202277BE8944405D0032@dlee02.ent.ti.com>
References: <20090616104018.44075a80@pedra.chehab.org>
	<A24693684029E5489D1D202277BE8944405D0032@dlee02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Jun 2009 09:24:14 -0500
"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com> escreveu:

> Hi Mauro,
> 
> We are currently going through an internal debugging process on new found issues while testing the driver on a proprietary HW/SW platform.
> 
> As there is priority for us to find stability in this platforms, we had to put aside a bit the maintenance of the shared patches.

Ok.
> 
> One maybe important news is that I'll be creating a new tree soon to host current OMAP3 and future OMAP4 camera drivers for upstream from TI perspective. My main task will be to maintain this tree in TI, and take care of upstreaming and fixing patches for acceptance by both linux-omap and linux-media lists.

That's good news! I think there are still some OMAP 2 RFC patches that weren't
applied. Are you also handling those?

> Some of the known to-dos are:
> - v4l2_subdev conversion
> - Regulator framework usage
> - ISP registration as a memory to memory device.
> 
> I hope to resume this task soon, and keep in touch with the community on the latest version of patches. I'll let you know when the next version is ready for merge.

Ok, thanks.

> Thanks for your concern and time on this.
> 
> Regards,
> Sergio



Cheers,
Mauro
