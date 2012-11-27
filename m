Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41538 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2K0NFj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 08:05:39 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so12370736oag.19
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2012 05:05:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1210301547300.29432@axis700.grange>
References: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
	<1351599395-16833-2-git-send-email-javier.martin@vista-silicon.com>
	<CAOMZO5C0yvvXs38B4zt46zsjphif-tg=FoEjBeoLx7iQUut62Q@mail.gmail.com>
	<Pine.LNX.4.64.1210301327090.29432@axis700.grange>
	<CACKLOr0r2w-=f=PUU-s7x302Jvp3urBZcRQa3pjArZYx0BSjtg@mail.gmail.com>
	<Pine.LNX.4.64.1210301547300.29432@axis700.grange>
Date: Tue, 27 Nov 2012 11:05:38 -0200
Message-ID: <CAOMZO5CbGz_OW6tx1gAGDrhrS4Mp4f4UrdvLVFS+sh4UVTG46A@mail.gmail.com>
Subject: Re: [PATCH 1/4] media: mx2_camera: Remove i.mx25 support.
From: Fabio Estevam <festevam@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, fabio.estevam@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi/Javier,

On Tue, Oct 30, 2012 at 12:57 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:

> Fabio, I wasn't in favour of removing mx25 support initially and I still
> don't quite fancy it, but the delta is getting too large. If we remove it
> now you still have the git history, so, you'll be able to restore the
> latest state before removal. OTOH, it would be easier for me to review a
> 50-line fix patch, than a 400-line revert-and-fix patch, so, this has an
> adbantage too.

Sorry for the delay.

I just added the camera support to mach-mx25_3ds.c (which I will
submit it soon to arm kernel list) and it works fine:

soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
mx2-camera imx25-camera.0: Camera driver attached to camera 0
ov2640 0-0030: ov2640 Product ID 26:42 Manufacturer ID 7f:a2
i2c i2c-0: OV2640 Probed
mx2-camera imx25-camera.0: Camera driver detached from camera 0
mx2-camera imx25-camera.0: MX2 Camera (CSI) driver probed, clock
frequency: 22166666

Could we please keep the mx25 support?

Thanks,

Fabio Estevam
