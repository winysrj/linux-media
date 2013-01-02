Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:40683 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3ABM0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 07:26:54 -0500
Received: by mail-we0-f180.google.com with SMTP id t57so6476091wey.25
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 04:26:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CbGz_OW6tx1gAGDrhrS4Mp4f4UrdvLVFS+sh4UVTG46A@mail.gmail.com>
References: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
	<1351599395-16833-2-git-send-email-javier.martin@vista-silicon.com>
	<CAOMZO5C0yvvXs38B4zt46zsjphif-tg=FoEjBeoLx7iQUut62Q@mail.gmail.com>
	<Pine.LNX.4.64.1210301327090.29432@axis700.grange>
	<CACKLOr0r2w-=f=PUU-s7x302Jvp3urBZcRQa3pjArZYx0BSjtg@mail.gmail.com>
	<Pine.LNX.4.64.1210301547300.29432@axis700.grange>
	<CAOMZO5CbGz_OW6tx1gAGDrhrS4Mp4f4UrdvLVFS+sh4UVTG46A@mail.gmail.com>
Date: Wed, 2 Jan 2013 13:18:52 +0100
Message-ID: <CACKLOr1sn8E8qGJm1KriEEzPtFOH+2JXdpywY7o4yXe4vWQp2Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] media: mx2_camera: Remove i.mx25 support.
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, fabio.estevam@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio, Guennadi,
sorry for the long delay but I've been out of the office for a month
and without internet access.

On 27 November 2012 14:05, Fabio Estevam <festevam@gmail.com> wrote:
> I just added the camera support to mach-mx25_3ds.c (which I will
> submit it soon to arm kernel list) and it works fine:
>
> soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
> mx2-camera imx25-camera.0: Camera driver attached to camera 0
> ov2640 0-0030: ov2640 Product ID 26:42 Manufacturer ID 7f:a2
> i2c i2c-0: OV2640 Probed
> mx2-camera imx25-camera.0: Camera driver detached from camera 0
> mx2-camera imx25-camera.0: MX2 Camera (CSI) driver probed, clock
> frequency: 22166666
>
> Could we please keep the mx25 support?

That's great. Did you need to change anything in the mx2 camera driver
for mx25 to work? Have you already submitted the patches?

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
