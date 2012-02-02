Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42655 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab2BBOhc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 09:37:32 -0500
Received: by wgbdt10 with SMTP id dt10so2646684wgb.1
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2012 06:37:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5Cfb=4fkqkmdkN6OcLAZVszxGNB8X6q4bDU_oFwnnjt6Q@mail.gmail.com>
References: <C85ED22A0FD4B54195E2F05309F9D3FF07234D15@CORREO.cp.local>
	<Pine.LNX.4.64.1202020040500.28897@axis700.grange>
	<CAOMZO5Cfb=4fkqkmdkN6OcLAZVszxGNB8X6q4bDU_oFwnnjt6Q@mail.gmail.com>
Date: Thu, 2 Feb 2012 15:37:31 +0100
Message-ID: <CACKLOr2TMkLjhWMAxuLbjqj4Uin6mx9NeGpzZqJ8u-+f6+JX5w@mail.gmail.com>
Subject: Re: OV2640 and iMX25PDK - help needed
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Fernandez Gonzalo <gfernandez@copreci.es>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 2 February 2012 15:01, Fabio Estevam <festevam@gmail.com> wrote:
> On 2/1/12, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>> Hello Gonzalo
>>
>> On Tue, 31 Jan 2012, Fernandez Gonzalo wrote:
>>
>>> Hi all,
>>>
>>> I've been working for a while with an iMX25PDK using the BSP provided by
>>> Freescale (L2.6.31). The camera driver (V4L2-int) and examples do the
>>> job quite well but I need to move my design to a more recent kernel.
>>> I've been extensively googling but haven't found any info/examples about
>>> how to run the mx2_camera driver in the i.MX25PDK. I'm stuck at this,
>>> could someone point me in the right direction? Thank you in advance...
>>
>> i.MX25PDK is supported in the mainline kernel
>> (arch/arm/mach-imx/mach-mx25_3ds.c), but it doesn't attach any cameras.
>> Unfortunately, I also don't currently see any i.MX2x platforms in the
>> mainline with cameras, so, you have to begin by looking at
>> arch/arm/plat-mxc/include/mach/mx2_cam.h, at
>> arch/arm/plat-mxc/devices/platform-mx2-camera.c for the
>> imx27_add_mx2_camera() function and maybe some i.MX3x or i.MX1 examples.
>
> Javier has been doing a lot of work on mx2-camera lately.
>
> Javier,
>
> Is mach-imx27_visstrim_m10 board connected to a CMOS camera? Do you
> have patches for adding camera support to mach-imx27_visstrim_m10?

visstrim_m10 is connected to a tvp5150 but it uses the same interface
as a CMOS sensor. Let me find some time to send a patch that I have
pending in my queue. Then it can be used by Gonzalo as a reference.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
