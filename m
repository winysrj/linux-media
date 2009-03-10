Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:65386 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZCJJD7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 05:03:59 -0400
Subject: RE: [PATCH 5/5] LDP: Add support for built-in camera
From: "stanley.miao" <stanley.miao@windriver.com>
Reply-To: stanley.miao@windriver.com
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
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
In-Reply-To: <A24693684029E5489D1D202277BE89442E40F747@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE89442E40F747@dlee02.ent.ti.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Mar 2009 17:03:41 +0800
Message-Id: <1236675821.6759.33.camel@localhost>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-03-09 at 15:24 -0500, Aguirre Rodriguez, Sergio Alberto
wrote:
> Hi,
> 
> > -----Original Message-----
> > From: stanley.miao [mailto:stanley.miao@windriver.com]
> 
> <snip>
> 
> > > +static struct i2c_board_info __initdata ldp_i2c_boardinfo_2[] = {
> > > +#if defined(CONFIG_VIDEO_OV3640) || defined(CONFIG_VIDEO_OV3640_MODULE)
> > > +	{
> > > +		I2C_BOARD_INFO("ov3640", OV3640_I2C_ADDR),
> > > +		.platform_data = &ldp_ov3640_platform_data,
> > > +	},
> > > +#endif
> > > +};
> > >
> > This new added i2c_board_info was not registered.
> > After I added this line,
> > 
> > omap_register_i2c_bus(2, 400, ldp_i2c_boardinfo_2,
> >                         ARRAY_SIZE(ldp_i2c_boardinfo_2));
> > 
> > the sensor was found. but the test still failed. A lot of error came out
> > when I run my test program.
> > 
> > <3>CSI2: ComplexIO Error IRQ 80
> > CSI2: ComplexIO Error IRQ 80
> > <3>CSI2: ComplexIO Error IRQ c2
> > CSI2: ComplexIO Error IRQ c2
> > <3>CSI2: ComplexIO Error IRQ c2
> > CSI2: ComplexIO Error IRQ c2
> > <3>CSI2: ComplexIO Error IRQ c6
> > CSI2: ComplexIO Error IRQ c6
> > <3>CSI2: ECC correction failed
> > CSI2: ECC correction failed
> > <3>CSI2: ComplexIO Error IRQ 6
> > CSI2: ComplexIO Error IRQ 6
> > <3>CSI2: ComplexIO Error IRQ 6
> > CSI2: ComplexIO Error IRQ 6
> > <3>CSI2: ComplexIO Error IRQ 6
> > CSI2: ComplexIO Error IRQ 6
> > <3>CSI2: ComplexIO Error IRQ 6
> > CSI2: ComplexIO Error IRQ 6
> > 
> 
> Oops, my mistake. Missed to add that struct there... Fixed now.
> 
> About the CSI2 errors you're receiving... Which version of LDP are you using? Which Silicon revision has (ES2.1 or ES3.0)?

ZOOM1 board(LDP3430-VG1.0.0-1), omap3430 ES2.1.

When I use your old version patch, sometimes the test succeed, sometimes
failed(no data was generated and no error). This version, always failed.

Thanks.
Stanley.

> 
> Regards,
> Sergio
> > 
> > Stanley.
