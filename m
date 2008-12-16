Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGJmqpk015743
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 14:48:52 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBGJmc4j005181
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 14:48:38 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>, Tony Lindgren
	<tony@atomide.com>
Date: Tue, 16 Dec 2008 13:48:28 -0600
Message-ID: <A24693684029E5489D1D202277BE894415F3E752@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894415F3E741@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: RE: [REVIEW PATCH 14/14] OMAP34XX: CAM: Add Sensors Support
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

> > From: Tony Lindgren [mailto:tony@atomide.com]
> > * Aguirre Rodriguez, Sergio Alberto <saaguirre@ti.com> [081215 09:02]:
> > > > From: Tony Lindgren [mailto:tony@atomide.com]
> > > > * Aguirre Rodriguez, Sergio Alberto <saaguirre@ti.com> [081211
> 12:44]:
> > > > > +	case V4L2_POWER_OFF:
> > > > > +		/* Power Down Sequence */
> > > > > +#ifdef CONFIG_TWL4030_CORE
> > > > > +		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> > > > > +				VAUX_DEV_GRP_NONE, TWL4030_VAUX2_DEV_GRP);
> > > > > +#else
> > > > > +#error "no power companion board defined!"
> > > > > +#endif
> > > >
> > > > These checks look unecessary. How about just handle it with Kconfig?
> > > >
> > > [Aguirre, Sergio] But how? Don't you think that if I do that, I'll
> > tighten the sensor driver to this board only?
> > >
> >
> > See what we've done with arch/arm/mach-omap2/mmc-twl4030.c for example
> > in linux-omap tree.
> [Aguirre, Sergio] Hmm, I'm a bit confused here. Can you help me clarify?
> 
> I see that you're adding mmc-twl4030 compilation in Makefile for every
> board that supports it and adding twl4030_mmc_init() call to the
> corresponding board init function. I see that you're also conditioning
> almost all code inside mmc-twl4030.c with "if
> defined(CONFIG_TWL4030_CORE)" compiler check.
> 
> Can you help me see how is this different to what I'm doing?
> 
[Aguirre, Sergio] Or maybe you meant to condition all sensors support with "#if defined(CONFIG_TWL4030_CORE)" check, without returning error on else case?


> > The twl and mmc patches are on their way to the mainline
> > kernel too hopfully this merge window.
> >
> > Regards,
> >
> > Tony
> 
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
