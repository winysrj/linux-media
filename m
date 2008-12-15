Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBFH30QC003521
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 12:03:00 -0500
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBFH2llh008582
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 12:02:47 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Tony Lindgren <tony@atomide.com>
Date: Mon, 15 Dec 2008 11:02:35 -0600
Message-ID: <A24693684029E5489D1D202277BE894415F3DAEB@dlee02.ent.ti.com>
In-Reply-To: <20081215162338.GS10664@atomide.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
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

> From: Tony Lindgren [mailto:tony@atomide.com]
> * Aguirre Rodriguez, Sergio Alberto <saaguirre@ti.com> [081211 12:44]:
> > +	case V4L2_POWER_OFF:
> > +		/* Power Down Sequence */
> > +#ifdef CONFIG_TWL4030_CORE
> > +		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> > +				VAUX_DEV_GRP_NONE, TWL4030_VAUX2_DEV_GRP);
> > +#else
> > +#error "no power companion board defined!"
> > +#endif
> 
> These checks look unecessary. How about just handle it with Kconfig?
> 
[Aguirre, Sergio] But how? Don't you think that if I do that, I'll tighten the sensor driver to this board only?


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
