Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53688 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165Ab2BJP6X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 10:58:23 -0500
Received: by eaah12 with SMTP id h12so970879eaa.19
        for <linux-media@vger.kernel.org>; Fri, 10 Feb 2012 07:58:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <C85ED22A0FD4B54195E2F05309F9D3FF0731261D@CORREO.cp.local>
References: <C85ED22A0FD4B54195E2F05309F9D3FF07234D15@CORREO.cp.local>
	<Pine.LNX.4.64.1202020040500.28897@axis700.grange>
	<CAOMZO5Cfb=4fkqkmdkN6OcLAZVszxGNB8X6q4bDU_oFwnnjt6Q@mail.gmail.com>
	<CACKLOr2TMkLjhWMAxuLbjqj4Uin6mx9NeGpzZqJ8u-+f6+JX5w@mail.gmail.com>
	<C85ED22A0FD4B54195E2F05309F9D3FF0731261D@CORREO.cp.local>
Date: Fri, 10 Feb 2012 13:58:22 -0200
Message-ID: <CAOMZO5CXOL1uFt2FVRjD2H36ShUxjS=3eYm2HT4peY5V4vHjTw@mail.gmail.com>
Subject: Re: OV2640 and iMX25PDK - help needed
From: Fabio Estevam <festevam@gmail.com>
To: Fernandez Gonzalo <gfernandez@copreci.es>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	javier Martin <javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gonzalo,

On 2/10/12, Fernandez Gonzalo <gfernandez@copreci.es> wrote:

> I've been finally able to attach the ov2640 camera in the i.MX25PDK.
> I've had some problems with the clocks, but a quick dirty fix looks to
> solve this issue (I'll work on cleaner solution later).

Great to know that you are having progress.

> Now I have to send the camera stream to "somewhere". In the example
> provided by Freescale based on L2.6.31, "somewhere" is the framebuffer,
> and this is done using VIDIOC_S_FBUF and VIDIOC_OVERLAY ioctls. As these
> 2 ioctls are not currently implemented in soc_camera.c, I was wondefing
> if it exist a different preferred method to implement this
> functionality?

In order to test if you are capturing the image correctly you can
launch a Gstreamer pipeline and use filesink to save the stream to a
file.

Or you can also send it to the framebuffer, with something like:

gst-launch -v v4l2src device=/dev/video0 !\
                video/x-raw-yuv,width=320,height=240 !\
                ffmpegcolorspace ! fbdevsink

Regards,

Fabio Estevam
