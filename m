Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:27846 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751939AbcIUGa3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 02:30:29 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] platform: pxa_camera: add VIDEO_V4L2 dependency
References: <20160919124655.1466734-1-arnd@arndb.de>
Date: Wed, 21 Sep 2016 08:30:24 +0200
In-Reply-To: <20160919124655.1466734-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 19 Sep 2016 14:46:30 +0200")
Message-ID: <874m59epdr.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> Moving the pxa_camera driver from soc_camera lots the implied
> VIDEO_V4L2 Kconfig dependency, and building the driver without
> V4L2 results in a kernel that cannot link:
>
> drivers/media/platform/pxa_camera.o: In function `pxa_camera_remove':
> pxa_camera.c:(.text.pxa_camera_remove+0x10): undefined reference to `v4l2_clk_unregister'
> pxa_camera.c:(.text.pxa_camera_remove+0x18): undefined reference to `v4l2_device_unregister'
> drivers/media/platform/pxa_camera.o: In function `pxa_camera_probe':
> pxa_camera.c:(.text.pxa_camera_probe+0x458): undefined reference to `v4l2_of_parse_endpoint'
> drivers/media/v4l2-core/videobuf2-core.o: In function `__enqueue_in_driver':
> drivers/media/v4l2-core/videobuf2-core.o: In function `vb2_core_streamon':
> videobuf2-core.c:(.text.vb2_core_streamon+0x1b4): undefined reference to `v4l_vb2q_enable_media_source'
> drivers/media/v4l2-core/videobuf2-v4l2.o: In function `vb2_ioctl_reqbufs':
> videobuf2-v4l2.c:(.text.vb2_ioctl_reqbufs+0xc): undefined reference to `video_devdata'
>
> This adds back an explicit dependency.
That looks right to me.

Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
