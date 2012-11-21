Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50230 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab2KUMKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 07:10:50 -0500
Date: Wed, 21 Nov 2012 13:10:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bill Pemberton <wfp5p@virginia.edu>
cc: gregkh@linuxfoundation.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org
Subject: Re: =?UTF-8?q?=5BPATCH=20133/493=5D=20remove=20use=20of=20=5F=5Fdevexit=5Fp?=
In-Reply-To: <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
Message-ID: <Pine.LNX.4.64.1211211307000.842@axis700.grange>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Nov 2012, Bill Pemberton wrote:

>  drivers/media/platform/sh_vou.c                          | 2 +-
>  drivers/media/platform/soc_camera/atmel-isi.c            | 2 +-
>  drivers/media/platform/soc_camera/mx2_camera.c           | 2 +-
>  drivers/media/platform/soc_camera/mx3_camera.c           | 2 +-
>  drivers/media/platform/soc_camera/pxa_camera.c           | 2 +-
>  drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 2 +-
>  drivers/media/platform/soc_camera/sh_mobile_csi2.c       | 2 +-
>  drivers/media/platform/soc_camera/soc_camera.c           | 2 +-

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
