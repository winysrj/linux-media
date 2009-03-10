Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33533 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZCJIIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 04:08:41 -0400
From: "Menon, Nishanth" <nm@ti.com>
To: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
CC: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Doyu Hiroshi (Nokia-D/Helsinki)" <hiroshi.doyu@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>
Date: Tue, 10 Mar 2009 03:08:26 -0500
Subject: RE: [PATCH 3/5] OV3640: Add driver
Message-ID: <7A436F7769CA33409C6B44B358BFFF0CFF48F3F6@dlee02.ent.ti.com>
References: <1236212613.8608.19.camel@tux.localhost>
 <A24693684029E5489D1D202277BE89442E40F7EF@dlee02.ent.ti.com>
 <7A436F7769CA33409C6B44B358BFFF0CFF3E86F7@dlee02.ent.ti.com>
 <200903100929.50049.tuukka.o.toivonen@nokia.com>
In-Reply-To: <200903100929.50049.tuukka.o.toivonen@nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Tuukka.O Toivonen [mailto:tuukka.o.toivonen@nokia.com]
> Sent: Tuesday, March 10, 2009 9:30 AM
> To: Menon, Nishanth
> Cc: Aguirre Rodriguez, Sergio Alberto; Alexey Klimov; linux-
> media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus; Doyu
> Hiroshi (Nokia-D/Helsinki); DongSoo(Nathaniel) Kim; MiaoStanley; Nagalla,
> Hari; Hiremath, Vaibhav; Lakhani, Amish
> Subject: Re: [PATCH 3/5] OV3640: Add driver
> 
> On Monday 09 March 2009 23:29:27 ext Menon, Nishanth wrote:
> > Further, we have multiple sensors following CCI[1] - why not have a
> driver
> > for the same, it will simplify the entire process - ov3640, mt9p012 both
> > follow the spec at least.. dependency would be sensor -> cci dev->i2c
> > framework.
> 
> Sakari has written smiaregs.c pretty much exactly for this
> purpose. You should check it out.
Yes, smiaregs probably has a few more functionality than pure reg access APIs. Comparing CCI as defined in CCP2 spec and CSI2 spec, CCP2 spec says - register addressing could be 8 or 16, but the data size is 8 bit. In the case of CSI2, the data size could be 8, 16, 32 or 64 bytes.. we could say that CSI2's CCI is kind of a superset of CCI as defined by CCP2 spec.
Might be a good idea to split the cci access out of smia_regs.c and make it a little more generic so that devices not caring for smia register set organization but using MIPI type access could also use it.

Regards,
Nishanth Menon
Ref:
[1] MIPI CSI2 revision 1.0
[2] SMIA CCP2 spec rev 1.0
