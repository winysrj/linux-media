Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34209 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab2FSAz0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 20:55:26 -0400
Received: by bkcji2 with SMTP id ji2so4615759bkc.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 17:55:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205260005230.13353@axis700.grange>
References: <Pine.LNX.4.64.1205260005230.13353@axis700.grange>
Date: Mon, 18 Jun 2012 21:55:25 -0300
Message-ID: <CAOMZO5DVWz0EtfkHq+pquNWyB6+kn3G2b2G-ANYi-Nmfh1uCYQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "[media] media: mx2_camera: Fix mbus format handling"
From: Fabio Estevam <festevam@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, May 25, 2012 at 7:06 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> This reverts commit d509835e32bd761a2b7b446034a273da568e5573. That commit
> breaks support for the generic pass-through mode in the driver for formats,
> not natively supported by it. Besides due to a merge conflict it also breaks
> driver compilation:
>
> drivers/media/video/mx2_camera.c: In function 'mx2_camera_set_bus_param':
> drivers/media/video/mx2_camera.c:937: error: 'pixfmt' undeclared (first use in this function)
> drivers/media/video/mx2_camera.c:937: error: (Each undeclared identifier is reported only once
> drivers/media/video/mx2_camera.c:937: error: for each function it appears in.)

Can this be applied?

It is breaking mxs_defconfig for one month now.

Thanks,

Fabio Estevam
