Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38488 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZCIV3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 17:29:44 -0400
From: "Menon, Nishanth" <nm@ti.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Alexey Klimov <klimov.linux@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>
Date: Mon, 9 Mar 2009 16:29:27 -0500
Subject: RE: [PATCH 3/5] OV3640: Add driver
Message-ID: <7A436F7769CA33409C6B44B358BFFF0CFF3E86F7@dlee02.ent.ti.com>
References: <1236212613.8608.19.camel@tux.localhost>
 <A24693684029E5489D1D202277BE89442E40F7EF@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E40F7EF@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Aguirre Rodriguez, Sergio Alberto
> Sent: Monday, March 09, 2009 10:58 PM
> To: Alexey Klimov
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus;
> Tuukka.O Toivonen; Hiroshi DOYU; DongSoo(Nathaniel) Kim; MiaoStanley;
> Nagalla, Hari; Hiremath, Vaibhav; Lakhani, Amish; Menon, Nishanth
> Subject: RE: [PATCH 3/5] OV3640: Add driver
> 
> 
> > > +       /* FIXME: QXGA framerate setting forced to 15 FPS */
> > > +       if (isize == QXGA) {
<lots of i2c reg writes snip>
> > 4));
> > > +               err = ov3640_write_reg(client, OV3640_ISP_YOUT_L,
> > > +                                                       (height_l -
> > 0x04));
> >
> > The same thing here.
> 
> Agree, will fix..
I wonder if we cannot use an array and fill it up before pumping it out through i2c. something like:
struct configure_array{
	u16 reg;
	u16 val;
}
struct configure_array reg_config[]={
	{OV3640_ISP_YOUT_H, 0x0},
...
};
Then 

for (i=0;i< sizeof(reg_config)/sizeof(configure_array);i++) {
	err = reg_write(reg_config[i].reg, reg_config[i].val);
	if (err) {
		/* do something */
	}
}

Further, we have multiple sensors following CCI[1] - why not have a driver for the same, it will simplify the entire process - ov3640, mt9p012 both follow the spec at least.. dependency would be sensor -> cci dev->i2c framework.

Regards,
Nishanth Menon

Ref:
[1] MIPI CSI2 spec rev 1.0.
