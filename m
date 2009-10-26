Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49922 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZJZQaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 12:30:04 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Alexey Klimov <klimov.linux@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>
Date: Mon, 26 Oct 2009 21:59:59 +0530
Subject: RE: [PATCH 4/4] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver
 on 	top of DSS2
Message-ID: <19F8576C6E063C45BE387C64729E73940436E5F53D@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
	 <1255688540-6454-1-git-send-email-hvaibhav@ti.com>
 <208cbae30910180207y2463334av7cb93aee6bd03b7a@mail.gmail.com>
In-Reply-To: <208cbae30910180207y2463334av7cb93aee6bd03b7a@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Alexey Klimov [mailto:klimov.linux@gmail.com]
> Sent: Sunday, October 18, 2009 2:38 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; Jadav, Brijesh R; Shah, Hardik
> Subject: Re: [PATCH 4/4] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2
> driver on top of DSS2
> 
> Hello,
> 
> On Fri, Oct 16, 2009 at 2:22 PM,  <hvaibhav@ti.com> wrote:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > Features Supported -
> >        1. Provides V4L2 user interface for the video pipelines of
> DSS
> >        2. Basic streaming working on LCD, DVI and TV.
> >        3. Works on latest DSS2 library from Tomi
> >        4. Support for various pixel formats like YUV, UYVY, RGB32,
> RGB24,
> >        RGB565
> >        5. Supports Alpha blending.
> >        6. Supports Color keying both source and destination.
> >        7. Supports rotation.
> >        8. Supports cropping.
> >        9. Supports Background color setting.
> >
> > TODO:
> >        1. Remove allocation of max buffer and rely on bootargs.
> >
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> > ---
> >  arch/arm/plat-omap/devices.c            |   29 +
> >  drivers/media/video/Kconfig             |    2 +
> >  drivers/media/video/Makefile            |    2 +
> >  drivers/media/video/omap/Kconfig        |   10 +
> >  drivers/media/video/omap/Makefile       |    3 +
> >  drivers/media/video/omap/omap_vout.c    | 2625
> +++++++++++++++++++++++++++++++
> >  drivers/media/video/omap/omap_voutdef.h |  148 ++
> >  drivers/media/video/omap/omap_voutlib.c |  258 +++
> >  drivers/media/video/omap/omap_voutlib.h |   34 +
> >  9 files changed, 3111 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/video/omap/Kconfig
> >  create mode 100644 drivers/media/video/omap/Makefile
> >  create mode 100644 drivers/media/video/omap/omap_vout.c
> >  create mode 100644 drivers/media/video/omap/omap_voutdef.h
> >  create mode 100644 drivers/media/video/omap/omap_voutlib.c
> >  create mode 100644 drivers/media/video/omap/omap_voutlib.h
> >

<snip>...

Thanks for these comments. How did I missed this, especially mutex/spinlock related comments (probably I will have to slap myself for this).

Thanks,
Vaibhav 
>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> --
> Best regards, Klimov Alexey

