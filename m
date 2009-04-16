Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:57188 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZDPDpp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 23:45:45 -0400
Received: by qw-out-2122.google.com with SMTP id 8so262405qwh.37
        for <linux-media@vger.kernel.org>; Wed, 15 Apr 2009 20:45:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904151358070.4729@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	 <Pine.LNX.4.64.0904151358070.4729@axis700.grange>
Date: Thu, 16 Apr 2009 11:39:09 +0800
Message-ID: <f17812d70904152039u1c5c1350j2732b6e75554e477@mail.gmail.com>
Subject: Re: [PATCH 1/5] soc-camera: add a free_bus method to struct
	soc_camera_link
From: Eric Miao <eric.y.miao@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 15, 2009 at 8:17 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Currently pcm990 camera bus-width management functions request a GPIO and never
> free it again. With this approach the GPIO extender driver cannot be unloaded
> once camera drivers have been loaded, also unloading theb i2c-pxa bus driver
> produces errors, because the GPIO extender driver cannot unregister properly.
> Another problem is, that if camera drivers are once loaded before the GPIO
> extender driver, the platform code marks the GPIO unavailable and only a reboot
> helps to recover. Adding an explicit free_bus method and using it in mt9m001
> and mt9v022 drivers fixes these problems.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> Eric, need your ack for the arch/arm/mach-pxa part. Sascha's wouldn't hurt
> either:-)
>

Yes, the mach-pxa/ part looks OK to me.

Acked-by: Eric Miao <eric.miao@marvell.com>
