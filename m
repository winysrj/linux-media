Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:43385 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab3LCRCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 12:02:51 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX8008TFQ0QU520@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 12:02:50 -0500 (EST)
Date: Tue, 03 Dec 2013 15:02:43 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 01/18] v4l: omap4iss: Add support for OMAP4 camera
 interface - Core
Message-id: <20131203150243.33a00f58.m.chehab@samsung.com>
In-reply-to: <1383523603-3907-2-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1383523603-3907-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  4 Nov 2013 01:06:26 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> 
> This adds a very simplistic driver to utilize the CSI2A interface inside
> the ISS subsystem in OMAP4, and dump the data to memory.
> 
> Check Documentation/video4linux/omap4_camera.txt for details.
> 
> This commit adds the driver core, registers definitions and
> documentation.
> 
> Signed-off-by: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> 
> [Port the driver to v3.12-rc3, including the following changes
> - Don't include plat/ headers
> - Don't use cpu_is_omap44xx() macro
> - Don't depend on EXPERIMENTAL
> - Fix s_crop operation prototype
> - Update link_notify prototype
> - Rename media_entity_remote_source to media_entity_remote_pad]
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/video4linux/omap4_camera.txt |   60 ++
>  drivers/staging/media/omap4iss/iss.c       | 1477 ++++++++++++++++++++++++++++
>  drivers/staging/media/omap4iss/iss.h       |  153 +++
>  drivers/staging/media/omap4iss/iss_regs.h  |  883 +++++++++++++++++
>  include/media/omap4iss.h                   |   65 ++
>  5 files changed, 2638 insertions(+)
>  create mode 100644 Documentation/video4linux/omap4_camera.txt
>  create mode 100644 drivers/staging/media/omap4iss/iss.c
>  create mode 100644 drivers/staging/media/omap4iss/iss.h
>  create mode 100644 drivers/staging/media/omap4iss/iss_regs.h
>  create mode 100644 include/media/omap4iss.h
> 

...

> +	/*
> +	 * atomic_set() doesn't include memory barrier on ARM platform for SMP
> +	 * scenario. We'll call it here to avoid race conditions.
> +	 */
> +	atomic_set(stopping, 1);
> +	smp_wmb();

Hmm... if atomic_set() is broken on ARM, you should be fixing its
implementation, and not adding any hacks like the above on all places
where atomic ops are needed.

-- 

Cheers,
Mauro
