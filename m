Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC152C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89512208E7
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:38:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89512208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbeLGMib (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:38:31 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:55681 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725994AbeLGMib (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 07:38:31 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VFOjg6XfxgJOKVFOmgYqmy; Fri, 07 Dec 2018 13:38:29 +0100
Subject: Re: [PATCH v9 01/13] media: staging/imx: refactor imx media device
 probe
To:     Rui Miguel Silva <rui.silva@linaro.org>,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20181122151834.6194-1-rui.silva@linaro.org>
 <20181122151834.6194-2-rui.silva@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b0fffeef-439b-e3a7-67d1-900a7ea1664f@xs4all.nl>
Date:   Fri, 7 Dec 2018 13:38:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181122151834.6194-2-rui.silva@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOkOCDbGrkJcNQ5t6Qr0+YNVcfoJR+glL69JDueyzhCgnXyxsW9ZRMWBGZ+BARKwa4mrMsCcFXJX7kndgSBhHLRTKjrAclFhhedWdYFetdKbilrPRF57
 n3iu20Ee3VB4oOf/fX8oH70mPE+xGUq/Y/dVM5btfnv6rHLccwmWVEvF6VTasvmO3CCF10aMhlf0VZ16J5+vprnvr/J8HOcq9Aj/1k+llv6cMkwBSNF3yk7E
 waSofGAvNnIk6wgjK3gHUCHm25SfctveEodAsK1zVsU+vPOm8ixhThgCOJAaZvUqlDSc7YoI4cGx8rku0wToZaKUZi8DdvWmQQiQxfjPNC0IsK6mJ6U3XK3Y
 9ecrusrQp4WAEk4KbMZX9xls7zn/LDk4zQMJ7dpRKFMRl1rPPsWoBRPpHFEWlglIg9UN+AjHtDtkkEN26lT8BnotGiIupQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 11/22/2018 04:18 PM, Rui Miguel Silva wrote:
> Refactor and move media device initialization code to a new common
> module, so it can be used by other devices, this will allow for example
> a near to introduce imx7 CSI driver, to use this media device.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  drivers/staging/media/imx/Makefile            |   1 +
>  .../staging/media/imx/imx-media-dev-common.c  | 102 ++++++++++++++++++
>  drivers/staging/media/imx/imx-media-dev.c     |  88 ++++-----------
>  drivers/staging/media/imx/imx-media-of.c      |   6 +-
>  drivers/staging/media/imx/imx-media.h         |  15 +++
>  5 files changed, 141 insertions(+), 71 deletions(-)
>  create mode 100644 drivers/staging/media/imx/imx-media-dev-common.c
> 
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
> index 698a4210316e..a30b3033f9a3 100644
> --- a/drivers/staging/media/imx/Makefile
> +++ b/drivers/staging/media/imx/Makefile
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  imx-media-objs := imx-media-dev.o imx-media-internal-sd.o imx-media-of.o
> +imx-media-objs += imx-media-dev-common.o
>  imx-media-common-objs := imx-media-utils.o imx-media-fim.o
>  imx-media-ic-objs := imx-ic-common.o imx-ic-prp.o imx-ic-prpencvf.o
>  
> diff --git a/drivers/staging/media/imx/imx-media-dev-common.c b/drivers/staging/media/imx/imx-media-dev-common.c
> new file mode 100644
> index 000000000000..55fe94fb72f2
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-dev-common.c
> @@ -0,0 +1,102 @@
> +// SPDX-License-Identifier: GPL

This is an invalid SPDX license identifier. You probably want to use GPL-2.0.

This happens in more patches, please check!

Regards,

	Hans

