Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61124 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab2BBOBo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 09:01:44 -0500
Received: by eaah12 with SMTP id h12so1073656eaa.19
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2012 06:01:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1202020040500.28897@axis700.grange>
References: <C85ED22A0FD4B54195E2F05309F9D3FF07234D15@CORREO.cp.local>
	<Pine.LNX.4.64.1202020040500.28897@axis700.grange>
Date: Thu, 2 Feb 2012 12:01:43 -0200
Message-ID: <CAOMZO5Cfb=4fkqkmdkN6OcLAZVszxGNB8X6q4bDU_oFwnnjt6Q@mail.gmail.com>
Subject: Re: OV2640 and iMX25PDK - help needed
From: Fabio Estevam <festevam@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Javier Martin <javier.martin@vista-silicon.com>
Cc: Fernandez Gonzalo <gfernandez@copreci.es>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/1/12, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hello Gonzalo
>
> On Tue, 31 Jan 2012, Fernandez Gonzalo wrote:
>
>> Hi all,
>>
>> I've been working for a while with an iMX25PDK using the BSP provided by
>> Freescale (L2.6.31). The camera driver (V4L2-int) and examples do the
>> job quite well but I need to move my design to a more recent kernel.
>> I've been extensively googling but haven't found any info/examples about
>> how to run the mx2_camera driver in the i.MX25PDK. I'm stuck at this,
>> could someone point me in the right direction? Thank you in advance...
>
> i.MX25PDK is supported in the mainline kernel
> (arch/arm/mach-imx/mach-mx25_3ds.c), but it doesn't attach any cameras.
> Unfortunately, I also don't currently see any i.MX2x platforms in the
> mainline with cameras, so, you have to begin by looking at
> arch/arm/plat-mxc/include/mach/mx2_cam.h, at
> arch/arm/plat-mxc/devices/platform-mx2-camera.c for the
> imx27_add_mx2_camera() function and maybe some i.MX3x or i.MX1 examples.

Javier has been doing a lot of work on mx2-camera lately.

Javier,

Is mach-imx27_visstrim_m10 board connected to a CMOS camera? Do you
have patches for adding camera support to mach-imx27_visstrim_m10?

Thanks,

Fabio Estevm
