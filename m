Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47920 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbZCDXwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 18:52:38 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: David Brownell <david-b@pacbell.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Date: Wed, 4 Mar 2009 17:52:19 -0600
Subject: RE: [RFC 0/5] Sensor drivers for OMAP3430SDP and LDP camera
Message-ID: <A24693684029E5489D1D202277BE89442E296F97@dlee02.ent.ti.com>
In-Reply-To: <200903031556.22034.david-b@pacbell.net>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: David Brownell [mailto:david-b@pacbell.net]
> Sent: Tuesday, March 03, 2009 5:56 PM
> To: Aguirre Rodriguez, Sergio Alberto
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus;
> Tuukka.O Toivonen; Hiroshi DOYU; DongSoo(Nathaniel) Kim; MiaoStanley;
> Nagalla, Hari; Hiremath, Vaibhav; Lakhani, Amish; Menon, Nishanth
> Subject: Re: [RFC 0/5] Sensor drivers for OMAP3430SDP and LDP camera
> 
> On Tuesday 03 March 2009, Aguirre Rodriguez, Sergio Alberto wrote:
> >
> > > This patch series depends on the following patches:
> > >
> > >  - "Add TWL4030 registers", posted by Tuukka Toivonen on March 2nd.
> >
> > http://marc.info/?l=linux-omap&m=123597520231668&w=2
> 
> I'd much rather see these drivers just use the regulator
> framework to switch any sensor power rails on/off.

Hi,

Sounds interesting.

Is there any documentation on how to use this?

> 
> As with the V4L2 interface changes, the twl4030 regulator
> support will be in mainline for the 2.6.30 kernels.
> 
> - Dave
> 
> 

