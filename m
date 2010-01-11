Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40315 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab0AKGZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 01:25:38 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"tony@atomide.com" <tony@atomide.com>
Date: Mon, 11 Jan 2010 11:55:30 +0530
Subject: RE: [PATCH 0/2] OMAP3: Add V4L2 display driver support
Message-ID: <19F8576C6E063C45BE387C64729E7394044A3982B3@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1262616129-23373-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1262616129-23373-1-git-send-email-hvaibhav@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Hiremath, Vaibhav
> Sent: Monday, January 04, 2010 8:12 PM
> To: linux-media@vger.kernel.org
> Cc: linux-omap@vger.kernel.org; hverkuil@xs4all.nl;
> tony@atomide.com; Hiremath, Vaibhav
> Subject: [PATCH 0/2] OMAP3: Add V4L2 display driver support
> 
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> This series of patch-set adds support for V4L2 display driver
> ontop of DSS2 framework.
> 
> Please note that this patch is dependent on patch which add
> "ti-media" directory (submitted earlier to this patch series)
> 
> Vaibhav Hiremath (2):
>   OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top of DSS2
>   OMAP2/3: Add V4L2 DSS driver support in device.c
> 
>  arch/arm/plat-omap/devices.c                |   29 +
>  drivers/media/video/ti-media/Kconfig        |   10 +
>  drivers/media/video/ti-media/Makefile       |    4 +
>  drivers/media/video/ti-media/omap_vout.c    | 2654
> +++++++++++++++++++++++++++
>  drivers/media/video/ti-media/omap_voutdef.h |  148 ++
>  drivers/media/video/ti-media/omap_voutlib.c |  258 +++
>  drivers/media/video/ti-media/omap_voutlib.h |   34 +
>  7 files changed, 3137 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/ti-media/omap_vout.c
>  create mode 100644 drivers/media/video/ti-media/omap_voutdef.h
>  create mode 100644 drivers/media/video/ti-media/omap_voutlib.c
>  create mode 100644 drivers/media/video/ti-media/omap_voutlib.h
[Hiremath, Vaibhav] Hans and others,

Since we do not have any comments on this, can we merge this patch series?

Thanks,
Vaibhav

