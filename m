Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0UNFukE023293
	for <video4linux-list@redhat.com>; Fri, 30 Jan 2009 18:15:56 -0500
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0UNFdHW008665
	for <video4linux-list@redhat.com>; Fri, 30 Jan 2009 18:15:39 -0500
From: "Curran, Dominic" <dcurran@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>, linux-omap
	<linux-omap@vger.kernel.org>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Fri, 30 Jan 2009 17:15:32 -0600
Message-ID: <96DA7A230D3B2F42BA3EF203A7A1B3B5012A594C32@dlee07.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403FA790201@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "greg.hofer@hp.com" <greg.hofer@hp.com>
Subject: RE: [OMAPZOOM][PATCH 5/6] ZOOM2: Rename the zoom2 i2c struct.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



> -----Original Message-----
> From: Hiremath, Vaibhav
> Sent: Thursday, January 29, 2009 9:52 PM
> To: Curran, Dominic; linux-omap; video4linux-list@redhat.com
> Cc: greg.hofer@hp.com
> Subject: RE: [OMAPZOOM][PATCH 5/6] ZOOM2: Rename the zoom2 i2c struct.
>
>
>
> Thanks,
> Vaibhav Hiremath
>
> > -----Original Message-----
> > From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-
> > bounces@redhat.com] On Behalf Of Curran, Dominic
> > Sent: Friday, January 30, 2009 6:24 AM
> > To: linux-omap; video4linux-list@redhat.com
> > Cc: greg.hofer@hp.com
> > Subject: [OMAPZOOM][PATCH 5/6] ZOOM2: Rename the zoom2 i2c struct.
> >
> > From: Dominic Curran <dcurran@ti.com>
> > Subject: [OMAPZOOM][PATCH 5/6] ZOOM2: Rename the zoom2 i2c struct.
> >
> > Rename i2c structures to something sensible.
> > This patch is not specific for imx046 sensor.
> > Do this in preparation for i2c changes for imx046 sensor.
> >
> > Signed-off-by: Greg Hofer <greg.hofer@hp.com>
> > Signed-off-by: Dominic Curran <dcurran@ti.com>
> > ---
> >  arch/arm/mach-omap2/board-zoom2.c |   14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > Index: omapzoom04/arch/arm/mach-omap2/board-zoom2.c
> > ===================================================================
> > --- omapzoom04.orig/arch/arm/mach-omap2/board-zoom2.c
> > +++ omapzoom04/arch/arm/mach-omap2/board-zoom2.c
> > @@ -472,7 +472,7 @@ static struct twl4030_platform_data ldp_
> >     .keypad         = &ldp_kp_twl4030_data,
> >  };
> >
> > -static struct i2c_board_info __initdata ldp_i2c_boardinfo[] = {
> > +static struct i2c_board_info __initdata zoom2_i2c_bus1_info[] = {
> [Hiremath, Vaibhav] I think zoom2_i2c1_info should be sufficient, since
> i2c1,2,3 itself indicates bus.


I also didn't take this.
As a 'newbie' I was a little confused what this structure was about when I first came across it, and having the word 'bus' there would have helped me.

Again, I will reconsider if you feel it's a big issue.

Thanks
dom


>
> >     {
> >             I2C_BOARD_INFO("twl4030", 0x48),
> >             .flags = I2C_CLIENT_WAKE,
> > @@ -507,7 +507,7 @@ static struct synaptics_i2c_rmi_platform
> >     .power          = &synaptics_power,
> >  };
> >
> > -static struct i2c_board_info __initdata ldp3430_i2c_board_info[] =
> > {
> > +static struct i2c_board_info __initdata zoom2_i2c_bus2_info[] = {
> >     {
> >             I2C_BOARD_INFO(SYNAPTICS_I2C_RMI_NAME,
> > SYNAPTICS_I2C_ADDR),
> >             .platform_data = &ldp3430_synaptics_platform_data,
> > @@ -518,12 +518,12 @@ static struct i2c_board_info __initdata
> >
> >  static int __init omap_i2c_init(void)
> >  {
> > -   omap_register_i2c_bus(1, 2600, ldp_i2c_boardinfo,
> > -                   ARRAY_SIZE(ldp_i2c_boardinfo));
> > +   omap_register_i2c_bus(1, 2600, zoom2_i2c_bus1_info,
> > +                   ARRAY_SIZE(zoom2_i2c_bus1_info));
> >  #ifdef CONFIG_TOUCHSCREEN_SYNAPTICS
> > -   ldp3430_i2c_board_info[0].irq =
> > OMAP_GPIO_IRQ(OMAP_SYNAPTICS_GPIO);
> > -   omap_register_i2c_bus(2, 100, ldp3430_i2c_board_info,
> > -                   ARRAY_SIZE(ldp3430_i2c_board_info));
> > +   zoom2_i2c_bus2_info[0].irq =
> > OMAP_GPIO_IRQ(OMAP_SYNAPTICS_GPIO);
> > +   omap_register_i2c_bus(2, 100, zoom2_i2c_bus2_info,
> > +                   ARRAY_SIZE(zoom2_i2c_bus2_info));
> >  #endif
> >     omap_register_i2c_bus(3, 400, NULL, 0);
> >     return 0;
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-
> > request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
