Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1929 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbZCCWrS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 17:47:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: Re: [RFC 0/5] Sensor drivers for OMAP3430SDP and LDP camera
Date: Tue, 3 Mar 2009 23:47:19 +0100
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
References: <A24693684029E5489D1D202277BE89442E1D921F@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E1D921F@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903032347.19548.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 03 March 2009 21:44:12 Aguirre Rodriguez, Sergio Alberto wrote:
> This patch series depends on the following patches:
>
>  - "Add TWL4030 registers", posted by Tuukka Toivonen on March 2nd.
>  - "OMAP3 ISP and camera drivers" patch series, posted by Sakari Ailus on
>    March 3rd. (Please follow his instructions to pull from gitorious.org
> server)

Sergio, Sakari,

I'm feeling quite uncomfortable about this series with regards to the use of 
the v4l2-int API instead of v4l2_subdev. I know that it is on the TODO 
list, but every driver that is merged that uses v4l2-int will later mean 
extra work.

I and others have been working very hard to get the existing ioctl-based i2c 
modules converted in time for the 2.6.30 merge window. It looks like I'll 
be able to have it done in time (fingers crossed :-) ). So it is rather sad 
to see new modules that do not yet use it.

Right now the v4l2_device and v4l2_subdev framework is pretty basic and so 
the amount of work to do the conversion is still limited, but once I've 
finished my initial conversion I'll be adding lots more features, do 
cleanups, and generally improve the framework substantially. Any existing 
modules that use v4l2_device and v4l2_subdev will be updated by me. But I'm 
not going to do that for modules using v4l2-int, that will be the 
responsibility of the module's author when he converts it to v4l2_subdev. 
So the longer you wait, the more work that will be.

I *strongly* recommend that the conversion to the new framework is done 
first. I know it might delay inclusion of some drivers, but my expectation 
based on all the other conversions I've done until now is that it will 
actually simplify the drivers.

My experiences with it have been uniformly positive and it should be 
possible to use it as well with the ISP module or other logical 
sub-devices. There are lots of interesting possibilities there that you do 
not have with v4l2-int.

Best regards,

	Hans

> This has been tested with:
>  - SDP3430-VG5.0.1 with OMAP3430-ES3.1 daughter board upgrade.
>  - Camkit V3.0.1 with MT9P012 and OV3640 sensors
>  - LDP with OV3640 sensor
>
> Sergio Aguirre (5):
>   MT9P012: Add driver
>   DW9710: Add driver
>   OV3640: Add driver
>   OMAP3430SDP: Add support for Camera Kit v3
>   LDP: Add support for built-in camera
>
>  arch/arm/mach-omap2/Makefile                    |    6 +-
>  arch/arm/mach-omap2/board-3430sdp-camera.c      |  490 +++++
>  arch/arm/mach-omap2/board-3430sdp.c             |   42 +-
>  arch/arm/mach-omap2/board-ldp-camera.c          |  203 +++
>  arch/arm/mach-omap2/board-ldp.c                 |   17 +
>  arch/arm/plat-omap/include/mach/board-3430sdp.h |    1 +
>  arch/arm/plat-omap/include/mach/board-ldp.h     |    1 +
>  drivers/media/video/Kconfig                     |   31 +
>  drivers/media/video/Makefile                    |    3 +
>  drivers/media/video/dw9710.c                    |  548 ++++++
>  drivers/media/video/dw9710_priv.h               |   57 +
>  drivers/media/video/mt9p012.c                   | 1890
> +++++++++++++++++++ drivers/media/video/mt9p012_regs.h              |  
> 74 +
>  drivers/media/video/ov3640.c                    | 2202
> +++++++++++++++++++++++ drivers/media/video/ov3640_regs.h               |
>  600 ++++++
>  include/media/dw9710.h                          |   35 +
>  include/media/mt9p012.h                         |   37 +
>  include/media/ov3640.h                          |   31 +
>  18 files changed, 6265 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-3430sdp-camera.c
>  create mode 100644 arch/arm/mach-omap2/board-ldp-camera.c
>  create mode 100644 drivers/media/video/dw9710.c
>  create mode 100644 drivers/media/video/dw9710_priv.h
>  create mode 100644 drivers/media/video/mt9p012.c
>  create mode 100644 drivers/media/video/mt9p012_regs.h
>  create mode 100644 drivers/media/video/ov3640.c
>  create mode 100644 drivers/media/video/ov3640_regs.h
>  create mode 100644 include/media/dw9710.h
>  create mode 100644 include/media/mt9p012.h
>  create mode 100644 include/media/ov3640.h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
