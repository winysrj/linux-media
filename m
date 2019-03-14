Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FB1C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B78F921855
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfCNIUR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:20:17 -0400
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:40278 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726606AbfCNIUR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 04:20:17 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 4Lb0hpyCdLMwI4Lb3hHn1h; Thu, 14 Mar 2019 09:20:15 +0100
Subject: Re: [PATCH 00/14] Add support for FM radio in hcill and kill TI_ST
To:     Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181221011752.25627-1-sre@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4f47f7f2-3abb-856c-4db5-675caf8057c7@xs4all.nl>
Date:   Thu, 14 Mar 2019 09:20:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20181221011752.25627-1-sre@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMRW9aN+U9an55TXNhV/UcZ6i+hxGAHn8vFCRsf5MZfZkcgeuIBOZJ3jTrv3EG5ikv3BmIEOc0X6vkblYQAjWCZv6el2QyAFVuo0m2xXDYUQLAJsRyTY
 JZ0cAAezjwWCQeO7iBYHRYU/lyWIo+hsmk/OncWzICuw6HYoauF9Iq3i69Zl09PetaUG7HBdCt8yoG/Y+C1KQNt4l64kQIMxfyGi1YO4gWnm7XfT/7LqO+84
 tpBfgQqzICN/gvCKiMeV3kr4KH48m51RDNttBaOyCgxlQWbHS99/C1WmvciVh0Xd32uvhSwJczZ8grEP9GD/ASazHDry9+bQI2y/tXjUudwaqiYnzAR4b2ND
 1qeoohTiZVBjdHguaZNKYRCf6Ng3nDXaF/rZnJ644vUsF2kdsLHH3Ac1WVIhBFb+Nv1158kfKzh48k0zwVaHczgdfQh66p9T71PtH1L6GEHLUAha65Bue0LG
 IK7hLdmwpyMFAeF/F2ae4dmUcf3Cc5G3iTHUJQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sebastian,

On 12/21/18 2:17 AM, Sebastian Reichel wrote:
> Hi,
> 
> This moves all remaining users of the legacy TI_ST driver to hcill (patches
> 1-3). Then patches 4-7 convert wl128x-radio driver to a standard platform
> device driver with support for multiple instances. Patch 7 will result in
> (userless) TI_ST driver no longer supporting radio at runtime. Patch 8-11 do
> some cleanups in the wl128x-radio driver. Finally patch 12 removes the TI_ST
> specific parts from wl128x-radio and adds the required infrastructure to use it
> with the serdev hcill driver instead. The remaining patches 13 and 14 remove
> the old TI_ST code.
> 
> The new code has been tested on the Motorola Droid 4. For testing the audio
> should be configured to route Ext to Speaker or Headphone. Then you need to
> plug headphone, since its cable is used as antenna. For testing there is a
> 'radio' utility packages in Debian. When you start the utility you need to
> specify a frequency, since initial get_frequency returns an error:

What is the status of this series?

Based on some of the replies (from Adam Ford in particular) it appears that
this isn't ready to be merged, so is a v2 planned?

Regards,

	Hans

> 
> $ radio -f 100.0
> 
> Merry Christmas!
> 
> -- Sebastian
> 
> Sebastian Reichel (14):
>   ARM: dts: LogicPD Torpedo: Add WiLink UART node
>   ARM: dts: IGEP: Add WiLink UART node
>   ARM: OMAP2+: pdata-quirks: drop TI_ST/KIM support
>   media: wl128x-radio: remove module version
>   media: wl128x-radio: remove global radio_disconnected
>   media: wl128x-radio: remove global radio_dev
>   media: wl128x-radio: convert to platform device
>   media: wl128x-radio: use device managed memory allocation
>   media: wl128x-radio: load firmware from ti-connectivity/
>   media: wl128x-radio: simplify fmc_prepare/fmc_release
>   media: wl128x-radio: fix skb debug printing
>   media: wl128x-radio: move from TI_ST to hci_ll driver
>   Bluetooth: btwilink: drop superseded driver
>   misc: ti-st: Drop superseded driver
> 
>  .../boot/dts/logicpd-torpedo-37xx-devkit.dts  |   8 +
>  arch/arm/boot/dts/omap3-igep0020-rev-f.dts    |   8 +
>  arch/arm/boot/dts/omap3-igep0030-rev-g.dts    |   8 +
>  arch/arm/mach-omap2/pdata-quirks.c            |  52 -
>  drivers/bluetooth/Kconfig                     |  11 -
>  drivers/bluetooth/Makefile                    |   1 -
>  drivers/bluetooth/btwilink.c                  | 350 -------
>  drivers/bluetooth/hci_ll.c                    | 115 ++-
>  drivers/media/radio/wl128x/Kconfig            |   2 +-
>  drivers/media/radio/wl128x/fmdrv.h            |   5 +-
>  drivers/media/radio/wl128x/fmdrv_common.c     | 211 ++--
>  drivers/media/radio/wl128x/fmdrv_common.h     |   4 +-
>  drivers/media/radio/wl128x/fmdrv_v4l2.c       |  55 +-
>  drivers/media/radio/wl128x/fmdrv_v4l2.h       |   2 +-
>  drivers/misc/Kconfig                          |   1 -
>  drivers/misc/Makefile                         |   1 -
>  drivers/misc/ti-st/Kconfig                    |  18 -
>  drivers/misc/ti-st/Makefile                   |   6 -
>  drivers/misc/ti-st/st_core.c                  | 922 ------------------
>  drivers/misc/ti-st/st_kim.c                   | 868 -----------------
>  drivers/misc/ti-st/st_ll.c                    | 169 ----
>  include/linux/ti_wilink_st.h                  | 337 +------
>  22 files changed, 213 insertions(+), 2941 deletions(-)
>  delete mode 100644 drivers/bluetooth/btwilink.c
>  delete mode 100644 drivers/misc/ti-st/Kconfig
>  delete mode 100644 drivers/misc/ti-st/Makefile
>  delete mode 100644 drivers/misc/ti-st/st_core.c
>  delete mode 100644 drivers/misc/ti-st/st_kim.c
>  delete mode 100644 drivers/misc/ti-st/st_ll.c
> 

