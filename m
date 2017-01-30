Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60444
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752289AbdA3RvN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 12:51:13 -0500
Date: Mon, 30 Jan 2017 15:51:01 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.11] Various fixes & enhancements
Message-ID: <20170130155054.49b64e02@vento.lan>
In-Reply-To: <d7d97219-9bfd-0ed0-f273-78251c62b84a@xs4all.nl>
References: <d7d97219-9bfd-0ed0-f273-78251c62b84a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 9 Jan 2017 12:22:23 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:
> 
>   [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v4.11a
> 
> for you to fetch changes up to f77fb0d794484029f83605f05bfcd3ef25dab98f:
> 
>   staging/media/s5p-cec/exynos_hdmi_cecctrl.c Fixed blank line before closing brace '}' (2017-01-09 12:07:39 +0100)
> 
> ----------------------------------------------------------------
> Baruch Siach (2):
>       ov2659: remove NOP assignment
>       adv7170: drop redundant ret local
> 
> Colin Ian King (4):
>       dvb-frontends: fix spelling mistake on cx24123_pll_calcutate
>       cobalt: fix spelling mistake: "Celcius" -> "Celsius"
>       b2c2: fix spelling mistake: "Contunuity" -> "Continuity"
>       gp8psk: fix spelling mistake: "firmare" -> "firmware"
> 
> Corentin Labbe (2):
>       media: s5p-cec: Remove unneeded linux/miscdevice.h include
>       media: s5p-cec: Remove references to non-existent PLAT_S5P symbol
> 
> Hans Verkuil (1):
>       gen-errors.rst: document EIO
> 
> Jean-Christophe Trotin (2):
>       st-hva: encoding summary at instance release
>       st-hva: add debug file system

I didn't merge those; the first one adds an unconditional debug printk
without a good reason. The second one sounds ok, but it depends on
the first patch.

> 
> Lars-Peter Clausen (1):
>       adv7604: Initialize drive strength to default when using DT
> 
> Nicolas Iooss (1):
>       am437x-vpfe: always assign bpp variable
> 
> Scott Matheina (2):
>       staging:media:s5p-cec:exynos_hdmi_cecctrl.c Fixed Alignment should match open parenthesis
>       staging/media/s5p-cec/exynos_hdmi_cecctrl.c Fixed blank line before closing brace '}'
> 
> Soren Brinkmann (1):
>       vivid: Enable 4k resolution for webcam capture device

Merged the remained patches.

Thanks!
Mauro

> 
>  Documentation/media/uapi/gen-errors.rst             |  10 +-
>  drivers/media/dvb-frontends/cx24123.c               |   2 +-
>  drivers/media/i2c/adv7170.c                         |   5 +-
>  drivers/media/i2c/adv7604.c                         |   3 +
>  drivers/media/i2c/ov2659.c                          |   1 -
>  drivers/media/pci/b2c2/flexcop-pci.c                |   2 +-
>  drivers/media/pci/cobalt/cobalt-cpld.c              |   4 +-
>  drivers/media/platform/Kconfig                      |  11 ++
>  drivers/media/platform/am437x/am437x-vpfe.c         |   2 +-
>  drivers/media/platform/sti/hva/Makefile             |   1 +
>  drivers/media/platform/sti/hva/hva-debugfs.c        | 422 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/platform/sti/hva/hva-h264.c           |   6 +
>  drivers/media/platform/sti/hva/hva-hw.c             |  48 ++++++
>  drivers/media/platform/sti/hva/hva-hw.h             |   3 +
>  drivers/media/platform/sti/hva/hva-mem.c            |   5 +-
>  drivers/media/platform/sti/hva/hva-v4l2.c           |  78 +++++++--
>  drivers/media/platform/sti/hva/hva.h                |  96 ++++++++++-
>  drivers/media/platform/vivid/vivid-vid-cap.c        |   5 +-
>  drivers/media/usb/dvb-usb/gp8psk.c                  |   2 +-
>  drivers/staging/media/s5p-cec/Kconfig               |   2 +-
>  drivers/staging/media/s5p-cec/exynos_hdmi_cec.h     |   1 -
>  drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c |   5 +-
>  22 files changed, 683 insertions(+), 31 deletions(-)
>  create mode 100644 drivers/media/platform/sti/hva/hva-debugfs.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Thanks,
Mauro
