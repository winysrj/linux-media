Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52590 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab2HTIGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 04:06:42 -0400
Date: Mon, 20 Aug 2012 10:06:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: sh_mobile_csi2.c confusion
In-Reply-To: <201208200955.54411.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1208201005350.3852@axis700.grange>
References: <201208200955.54411.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Mauro

On Mon, 20 Aug 2012, Hans Verkuil wrote:

> Hi Mauro, Guennadi,
> 
> The daily build fails with:
> 
> make[4]: *** No rule to make target `drivers/media/platform/sh_mobile_csi2.c',
> needed by `drivers/media/platform/sh_mobile_csi2.o'.  Stop.
> 
> Further investigation shows that the sh_mobile_csi2.o make rule is in
> drivers/media/platform/Makefile, while the actual source is in
> drivers/media/i2c/soc_camera/sh_mobile_csi2.c.
> 
> That can't be right. As far as I can tell sh_mobile_csi2.c should be moved to
> drivers/media/platform as it doesn't belong in i2c/soc_camera.
> 
> Guennadi, can you confirm? Mauro, can you move it to the right place?

Definitely, the sh-mobile CSI-2 driver has nothing to do with I2C. It's a 
platform driver for an SoC built-in IP.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
