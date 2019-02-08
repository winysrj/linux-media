Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F9CC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B2F72147C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfBHIwZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:52:25 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:56098 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727127AbfBHIwZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 03:52:25 -0500
Received: from [IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a] ([IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id s1tVgykkCBDyIs1tXgLacA; Fri, 08 Feb 2019 09:52:23 +0100
Subject: Re: [PATCH 0/4] Move SoC camera to staging, depend on BROKEN
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3079bea8-cc6a-58f9-ebda-01aac27caeb7@xs4all.nl>
Date:   Fri, 8 Feb 2019 09:52:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfLyUsFMNsoxQxypdkCqaYzUVIdidBk/nY3VKWNR4gBpTWVwCzwGGdk2Vi1pcxGlbqZbzAe3Zgd1WO3TZjtGgVrqKTVa8peHAULbFeLmOV5K/PQh6YdGP
 ldWUIJbaVGRwLMbCR/MtXHruXKww+JZAu6Dsdml3ccPaSqWQ397wvvg/5jGYKYUr4Tru+KI1FDIOzgDFds4p16805wvauWxoSH6wuqWS0Qvc6MG35xt3myWI
 CnLxNlJQCp26S8nusB8dIn+nT058YOorgaDDTQJNxs3ewto87hPigxFY74jxBIP914zDEhIk1xKgj9gLYHYWcw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/8/19 9:41 AM, Sakari Ailus wrote:
> Hi all,
> 
> This series moves the SoC camera framework and the remaining drivers under
> the staging tree and makes them depend on BROKEN.
> 
> The files could be later removed.

For this series:

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks!

	Hans

> 
> Sakari Ailus (4):
>   soc_camera: Move to the staging tree
>   soc_camera: Move the imx074 under soc_camera directory
>   soc_camera: Move the mt9t031 under soc_camera directory
>   soc_camera: Depend on BROKEN
> 
>  drivers/media/i2c/Kconfig                           |  8 --------
>  drivers/media/i2c/Makefile                          |  1 -
>  drivers/media/platform/Kconfig                      |  1 -
>  drivers/media/platform/Makefile                     |  2 --
>  drivers/media/platform/soc_camera/Kconfig           |  8 --------
>  drivers/media/platform/soc_camera/Makefile          |  1 -
>  drivers/staging/media/Kconfig                       |  6 ++----
>  drivers/staging/media/Makefile                      |  3 +--
>  drivers/staging/media/imx074/Kconfig                |  5 -----
>  drivers/staging/media/imx074/Makefile               |  1 -
>  drivers/staging/media/imx074/TODO                   |  5 -----
>  .../{media/i2c => staging/media}/soc_camera/Kconfig | 21 +++++++++++++++++++++
>  .../i2c => staging/media}/soc_camera/Makefile       |  3 +++
>  .../staging/media/{imx074 => soc_camera}/imx074.c   |  0
>  .../staging/media/{mt9t031 => soc_camera}/mt9t031.c |  0
>  .../media}/soc_camera/soc_camera.c                  |  0
>  .../media}/soc_camera/soc_mediabus.c                |  0
>  .../i2c => staging/media}/soc_camera/soc_mt9v022.c  |  0
>  .../i2c => staging/media}/soc_camera/soc_ov5642.c   |  0
>  .../i2c => staging/media}/soc_camera/soc_ov9740.c   |  0
>  20 files changed, 27 insertions(+), 38 deletions(-)
>  delete mode 100644 drivers/media/platform/soc_camera/Kconfig
>  delete mode 100644 drivers/media/platform/soc_camera/Makefile
>  delete mode 100644 drivers/staging/media/imx074/Kconfig
>  delete mode 100644 drivers/staging/media/imx074/Makefile
>  delete mode 100644 drivers/staging/media/imx074/TODO
>  rename drivers/{media/i2c => staging/media}/soc_camera/Kconfig (57%)
>  rename drivers/{media/i2c => staging/media}/soc_camera/Makefile (55%)
>  rename drivers/staging/media/{imx074 => soc_camera}/imx074.c (100%)
>  rename drivers/staging/media/{mt9t031 => soc_camera}/mt9t031.c (100%)
>  rename drivers/{media/platform => staging/media}/soc_camera/soc_camera.c (100%)
>  rename drivers/{media/platform => staging/media}/soc_camera/soc_mediabus.c (100%)
>  rename drivers/{media/i2c => staging/media}/soc_camera/soc_mt9v022.c (100%)
>  rename drivers/{media/i2c => staging/media}/soc_camera/soc_ov5642.c (100%)
>  rename drivers/{media/i2c => staging/media}/soc_camera/soc_ov9740.c (100%)
> 

