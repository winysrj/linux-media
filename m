Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.copreci.es ([194.30.93.3]:62152 "EHLO srvdmz.cp.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754601Ab2BJPnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 10:43:13 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: OV2640 and iMX25PDK - help needed
Date: Fri, 10 Feb 2012 16:38:50 +0100
Message-ID: <C85ED22A0FD4B54195E2F05309F9D3FF0731261D@CORREO.cp.local>
References: <C85ED22A0FD4B54195E2F05309F9D3FF07234D15@CORREO.cp.local><Pine.LNX.4.64.1202020040500.28897@axis700.grange><CAOMZO5Cfb=4fkqkmdkN6OcLAZVszxGNB8X6q4bDU_oFwnnjt6Q@mail.gmail.com> <CACKLOr2TMkLjhWMAxuLbjqj4Uin6mx9NeGpzZqJ8u-+f6+JX5w@mail.gmail.com>
From: "Fernandez Gonzalo" <gfernandez@copreci.es>
To: <linux-media@vger.kernel.org>
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"javier Martin" <javier.martin@vista-silicon.com>,
	"Fabio Estevam" <festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,

>Hi,
>
>On 2 February 2012 15:01, Fabio Estevam <festevam@gmail.com> wrote:
>> On 2/1/12, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>>> Hello Gonzalo
>>>
>>> On Tue, 31 Jan 2012, Fernandez Gonzalo wrote:
>>>
>>>> Hi all,
>>>>
>>>> I've been working for a while with an iMX25PDK using the BSP
provided by
>>>> Freescale (L2.6.31). The camera driver (V4L2-int) and examples do
the
>>>> job quite well but I need to move my design to a more recent
kernel.
>>>> I've been extensively googling but haven't found any info/examples
about
>>>> how to run the mx2_camera driver in the i.MX25PDK. I'm stuck at
this,
>>>> could someone point me in the right direction? Thank you in
advance...
>>>
>>> i.MX25PDK is supported in the mainline kernel
>>> (arch/arm/mach-imx/mach-mx25_3ds.c), but it doesn't attach any
cameras.
>>> Unfortunately, I also don't currently see any i.MX2x platforms in
the
>>> mainline with cameras, so, you have to begin by looking at
>>> arch/arm/plat-mxc/include/mach/mx2_cam.h, at
>>> arch/arm/plat-mxc/devices/platform-mx2-camera.c for the
>>> imx27_add_mx2_camera() function and maybe some i.MX3x or i.MX1
examples.
>>
>> Javier has been doing a lot of work on mx2-camera lately.
>>
>> Javier,
>>
>> Is mach-imx27_visstrim_m10 board connected to a CMOS camera? Do you
>> have patches for adding camera support to mach-imx27_visstrim_m10?
>
>visstrim_m10 is connected to a tvp5150 but it uses the same interface
>as a CMOS sensor. Let me find some time to send a patch that I have
>pending in my queue. Then it can be used by Gonzalo as a reference.
>
>Regards.
>-- 
>Javier Martin
>Vista Silicon S.L.
>CDTUC - FASE C - Oficina S-345
>Avda de los Castros s/n
>39005- Santander. Cantabria. Spain
>+34 942 25 32 60
>www.vista-silicon.com

I've been finally able to attach the ov2640 camera in the i.MX25PDK.
I've had some problems with the clocks, but a quick dirty fix looks to
solve this issue (I'll work on cleaner solution later).

Now I have to send the camera stream to "somewhere". In the example
provided by Freescale based on L2.6.31, "somewhere" is the framebuffer,
and this is done using VIDIOC_S_FBUF and VIDIOC_OVERLAY ioctls. As these
2 ioctls are not currently implemented in soc_camera.c, I was wondefing
if it exist a different preferred method to implement this
functionality?

Regards,
Gonzalo. 
