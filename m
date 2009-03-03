Return-path: <linux-media-owner@vger.kernel.org>
Received: from n5b.bullet.sp1.yahoo.com ([69.147.64.186]:31422 "HELO
	n5b.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754434AbZCCX6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 18:58:07 -0500
From: David Brownell <david-b@pacbell.net>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: Re: [RFC 0/5] Sensor drivers for OMAP3430SDP and LDP camera
Date: Tue, 3 Mar 2009 15:56:21 -0800
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
References: <A24693684029E5489D1D202277BE89442E1D92A4@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E1D92A4@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903031556.22034.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 03 March 2009, Aguirre Rodriguez, Sergio Alberto wrote:
> 
> > This patch series depends on the following patches:
> > 
> >  - "Add TWL4030 registers", posted by Tuukka Toivonen on March 2nd.
> 
> http://marc.info/?l=linux-omap&m=123597520231668&w=2

I'd much rather see these drivers just use the regulator
framework to switch any sensor power rails on/off.

As with the V4L2 interface changes, the twl4030 regulator
support will be in mainline for the 2.6.30 kernels.

- Dave
 

