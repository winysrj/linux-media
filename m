Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37875 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbdLNLGS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 06:06:18 -0500
Date: Thu, 14 Dec 2017 09:06:12 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>
Subject: Re: [GIT PULL FOR v4.16] staging/media: add NVIDIA Tegra video
 decoder driver
Message-ID: <20171214090612.14aa5696@vento.lan>
In-Reply-To: <27cd85c2-4e27-707d-6b94-bfad274d1806@xs4all.nl>
References: <27cd85c2-4e27-707d-6b94-bfad274d1806@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 Dec 2017 16:28:40 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> This adds a new NVIDIA Tegra video decoder driver. It is depending on the
> request API work since it is a stateless codec, so for now park this in staging.
> 
> The dts patches should go through nvidia's tree.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 330dada5957e3ca0c8811b14c45e3ac42c694651:
> 
>   media: dvb_frontend: fix return error code (2017-12-12 07:50:14 -0500)
> 
> are available in the Git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git tegradec
> 
> for you to fetch changes up to c3c530f45e48b33a2cc49cdeec246d255a5ca7db:
> 
>   staging: media: Introduce NVIDIA Tegra video decoder driver (2017-12-12 16:06:06 +0100)
> 
> ----------------------------------------------------------------
> Dmitry Osipenko (2):
>       media: dt: bindings: Add binding for NVIDIA Tegra Video Decoder Engine
>       staging: media: Introduce NVIDIA Tegra video decoder driver

Ok, clearly, there are some things that are not OK on the driver,
otherwise, it won't be merging at staging. Yet, there warnings
there that should be considered before moving it out of staging:


CHECK: Macro argument reuse '__data' - possible side-effects?
#142: FILE: drivers/staging/media/tegra-vde/tegra-vde.c:38:
+#define VDE_WR(__data, __addr)				\
+do {							\
+	dev_dbg(vde->miscdev.parent,			\
+		"%s: %d: 0x%08X => " #__addr ")\n",	\
+		__func__, __LINE__, (u32)(__data));	\
+	writel_relaxed(__data, __addr);			\
+} while (0)

CHECK: struct mutex definition without comment
#177: FILE: drivers/staging/media/tegra-vde/tegra-vde.c:73:
+	struct mutex lock;

WARNING: memory barrier without comment
#475: FILE: drivers/staging/media/tegra-vde/tegra-vde.c:371:
+	wmb();

WARNING: quoted string split across lines
#649: FILE: drivers/staging/media/tegra-vde/tegra-vde.c:545:
+		dev_err(dev, "Too small dmabuf size %zu @0x%lX, "
+			     "should be at least %d\n",

CHECK: Lines should not end with a '('
#969: FILE: drivers/staging/media/tegra-vde/tegra-vde.c:865:
+	timeout = wait_for_completion_interruptible_timeout(

WARNING: quoted string split across lines
#977: FILE: drivers/staging/media/tegra-vde/tegra-vde.c:873:
+		dev_err(dev, "Decoding failed: "
+				"read 0x%X bytes, %u macroblocks parsed\n",

CHECK: Prefer using the BIT macro
#1339: FILE: drivers/staging/media/tegra-vde/uapi.h:16:
+#define FLAG_B_FRAME		(1 << 0)

CHECK: Prefer using the BIT macro
#1340: FILE: drivers/staging/media/tegra-vde/uapi.h:17:
+#define FLAG_REFERENCE		(1 << 1)

WARNING: __packed is preferred over __attribute__((packed))
#1355: FILE: drivers/staging/media/tegra-vde/uapi.h:32:
+} __attribute__((packed));

WARNING: __packed is preferred over __attribute__((packed))
#1387: FILE: drivers/staging/media/tegra-vde/uapi.h:64:
+} __attribute__((packed));


> 
>  Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt |   55 +++
>  MAINTAINERS                                                  |    9 +
>  drivers/staging/media/Kconfig                                |    2 +
>  drivers/staging/media/Makefile                               |    1 +
>  drivers/staging/media/tegra-vde/Kconfig                      |    7 +
>  drivers/staging/media/tegra-vde/Makefile                     |    1 +
>  drivers/staging/media/tegra-vde/TODO                         |    4 +
>  drivers/staging/media/tegra-vde/tegra-vde.c                  | 1213 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/staging/media/tegra-vde/uapi.h                       |   78 +++
>  9 files changed, 1370 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt
>  create mode 100644 drivers/staging/media/tegra-vde/Kconfig
>  create mode 100644 drivers/staging/media/tegra-vde/Makefile
>  create mode 100644 drivers/staging/media/tegra-vde/TODO
>  create mode 100644 drivers/staging/media/tegra-vde/tegra-vde.c
>  create mode 100644 drivers/staging/media/tegra-vde/uapi.h



Thanks,
Mauro
