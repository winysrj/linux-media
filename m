Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C10C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 18:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E7912173C
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 18:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546884702;
	bh=ItUGUWWCr1tLBz4Jvrr61KcEabKI/UEcnR/KTtS32Mk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=H1lENC8RIEnOr3wBCKRXNyfxR+3d9NrWesMPoFyqfzs+OC1LcDTQ4LHW3Uoc9EeSD
	 VGvToUgSX078P+IwjuPlEz9XzsYf8iLUepy8tVaCTDlXPrLzqjhD0JuOPu53k2aDqj
	 hDoU0zjJXcWyz0WMajMO67W2LXiUEHj+nyNYOge8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfAGSLl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 13:11:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:45784 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727675AbfAGSLk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 13:11:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RjyrhmjtzcNwpjXXKAkBMXAOkHUqVMmgQgPW3RtTy+s=; b=DJf1q0U7nYm5jWgPHYbDI6Npsc
        fcy4QlKe3YvgDkRd7WAMmIocc5T9w99kV14isIY6HCYeAwZsLU60bb0IIjCndt/GQLrp61XH19snt
        GTY/X5Cf/ZWY6WdU52o6z6BiULZBBchZUWwfLbPmuvYFnOXmnd12sA+qHUyb3UMfdgLwUfc8lC18L
        BUHn5AckP2rVZWJ9sbEQCisoR2RRBH6hv4N7QMBcQmRBaOD8ULKnuvPnkIVRsHrgQ6avMW9fwoFRs
        vC/gKFY872aCwUs8lpchauPhP8xfLxAW8nNsNJSrsLP7ZXe2z5CJTnfD9linoMVio4kxA84PjmwOr
        ou4B+VQA==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggZNC-0006BW-AB; Mon, 07 Jan 2019 18:11:38 +0000
Date:   Mon, 7 Jan 2019 16:11:34 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     sakari.ailus@iki.fi
Cc:     linux-media@vger.kernel.org,
        Bingbu Cao <bingbu.cao@linux.intel.com>
Subject: Re: [GIT PULL v4 for 4.21] META_OUTPUT buffer type and the ipu3
 staging driver
Message-ID: <20190107161134.1d0d9f73@coco.lan>
In-Reply-To: <20190107160107.7dd9af05@coco.lan>
References: <20181213120340.2oakeelp2b5w7zzq@valkosipuli.retiisi.org.uk>
        <20190107160107.7dd9af05@coco.lan>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Mon, 7 Jan 2019 16:01:07 -0200
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> Hi Sakari/Bingbu,
> 
> Em Thu, 13 Dec 2018 14:03:40 +0200
> sakari.ailus@iki.fi escreveu:
> 
> > Hi Mauro,
> > 
> > Here's the ipu3 staging driver plus the META_OUTPUT buffer type needed to
> > pass the parameters for the device. If you think this there's still time to
> > get this to 4.21, then please pull. The non-staging patches have been
> > around for more than half a year and they're relatively simple.  
> 
> I'm now getting a lot of new warnings when building it:
> 
> drivers/staging/media/ipu3/ipu3-dmamap.c:drivers/staging/media/ipu3/ipu3-dmamap.c:97:6:  warning: symbol 'ipu3_dmamap_alloc' was not declared. Should it be static?
> drivers/staging/media/ipu3/ipu3-dmamap.c:drivers/staging/media/ipu3/ipu3-dmamap.c:166:6:  warning: symbol 'ipu3_dmamap_unmap' was not declared. Should it be static?
> drivers/staging/media/ipu3/ipu3-dmamap.c:drivers/staging/media/ipu3/ipu3-dmamap.c:184:6:  warning: symbol 'ipu3_dmamap_free' was not declared. Should it be static?
> drivers/staging/media/ipu3/ipu3-dmamap.c:drivers/staging/media/ipu3/ipu3-dmamap.c:204:5:  warning: symbol 'ipu3_dmamap_map_sg' was not declared. Should it be static?
> drivers/staging/media/ipu3/ipu3-dmamap.c:drivers/staging/media/ipu3/ipu3-dmamap.c:251:5:  warning: symbol 'ipu3_dmamap_init' was not declared. Should it be static?
> drivers/staging/media/ipu3/ipu3-dmamap.c:drivers/staging/media/ipu3/ipu3-dmamap.c:266:6:  warning: symbol 'ipu3_dmamap_exit' was not declared. Should it be static?
> In file included from drivers/staging/media/ipu3/ipu3-abi.h:7,
>                  from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3.h:14,
>                  from drivers/staging/media/ipu3/ipu3-css-pool.c:6:
> drivers/staging/media/ipu3/include/intel-ipu3.h:2481:35: warning: 'awb_fr' offset 36756 in 'struct ipu3_uapi_acc_param' isn't aligned to 32 [-Wpacked-not-aligned]
>   struct ipu3_uapi_awb_fr_config_s awb_fr;
>                                    ^~~~~~
> In file included from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3.h:14,
>                  from drivers/staging/media/ipu3/ipu3-css-pool.c:6:
> drivers/staging/media/ipu3/ipu3-abi.h:1250:1: warning: alignment 1 of 'struct imgu_abi_awb_fr_config' is less than 32 [-Wpacked-not-aligned]
>  } __packed;
>  ^
> drivers/staging/media/ipu3/ipu3-mmu.c:247: warning: Function parameter or member 'pgsize_bitmap' not described in 'ipu3_mmu_pgsize'
> drivers/staging/media/ipu3/ipu3-mmu.c:247: warning: Function parameter or member 'addr_merge' not described in 'ipu3_mmu_pgsize'
> drivers/staging/media/ipu3/ipu3-mmu.c:247: warning: Function parameter or member 'size' not described in 'ipu3_mmu_pgsize'
> drivers/staging/media/ipu3/ipu3-mmu.c:452: warning: Function parameter or member 'parent' not described in 'ipu3_mmu_init'
> drivers/staging/media/ipu3/ipu3-mmu.c:528: warning: Function parameter or member 'info' not described in 'ipu3_mmu_exit'
> drivers/staging/media/ipu3/ipu3-mmu.c:528: warning: Excess function parameter 'mmu' description in 'ipu3_mmu_exit'
> In file included from drivers/staging/media/ipu3/ipu3-abi.h:7,
>                  from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3-css-fw.c:9:
> drivers/staging/media/ipu3/include/intel-ipu3.h:2481:35: warning: 'awb_fr' offset 36756 in 'struct ipu3_uapi_acc_param' isn't aligned to 32 [-Wpacked-not-aligned]
>   struct ipu3_uapi_awb_fr_config_s awb_fr;
>                                    ^~~~~~
> In file included from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3-css-fw.c:9:
> drivers/staging/media/ipu3/ipu3-abi.h:1250:1: warning: alignment 1 of 'struct imgu_abi_awb_fr_config' is less than 32 [-Wpacked-not-aligned]
>  } __packed;
>  ^
> drivers/staging/media/ipu3/ipu3-css-fw.c: In function 'ipu3_css_fw_init':
> drivers/staging/media/ipu3/ipu3-css-fw.c:203:39: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>     if (bi->info.isp.output_formats[j] < 0 ||
>                                        ^
> drivers/staging/media/ipu3/ipu3-css-fw.c:208:35: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>     if (bi->info.isp.vf_formats[j] < 0 ||
>                                    ^
> drivers/staging/media/ipu3/ipu3-css.c: drivers/staging/media/ipu3/ipu3-css.c:1831 ipu3_css_fmt_try() warn: unsigned 'css->pipes[pipe].bindex' is never less than zero.
> In file included from drivers/staging/media/ipu3/ipu3-abi.h:7,
>                  from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3.h:14,
>                  from drivers/staging/media/ipu3/ipu3-dmamap.c:12:
> drivers/staging/media/ipu3/include/intel-ipu3.h:2481:35: warning: 'awb_fr' offset 36756 in 'struct ipu3_uapi_acc_param' isn't aligned to 32 [-Wpacked-not-aligned]
>   struct ipu3_uapi_awb_fr_config_s awb_fr;
>                                    ^~~~~~
> In file included from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3.h:14,
>                  from drivers/staging/media/ipu3/ipu3-dmamap.c:12:
> drivers/staging/media/ipu3/ipu3-abi.h:1250:1: warning: alignment 1 of 'struct imgu_abi_awb_fr_config' is less than 32 [-Wpacked-not-aligned]
>  } __packed;
>  ^
> drivers/staging/media/ipu3/ipu3-dmamap.c:97:7: warning: no previous prototype for 'ipu3_dmamap_alloc' [-Wmissing-prototypes]
>  void *ipu3_dmamap_alloc(struct imgu_device *imgu, struct ipu3_css_map *map,
>        ^~~~~~~~~~~~~~~~~
> drivers/staging/media/ipu3/ipu3-dmamap.c:166:6: warning: no previous prototype for 'ipu3_dmamap_unmap' [-Wmissing-prototypes]
>  void ipu3_dmamap_unmap(struct imgu_device *imgu, struct ipu3_css_map *map)
>       ^~~~~~~~~~~~~~~~~
> drivers/staging/media/ipu3/ipu3-dmamap.c:184:6: warning: no previous prototype for 'ipu3_dmamap_free' [-Wmissing-prototypes]
>  void ipu3_dmamap_free(struct imgu_device *imgu, struct ipu3_css_map *map)
>       ^~~~~~~~~~~~~~~~
> drivers/staging/media/ipu3/ipu3-dmamap.c:204:5: warning: no previous prototype for 'ipu3_dmamap_map_sg' [-Wmissing-prototypes]
>  int ipu3_dmamap_map_sg(struct imgu_device *imgu, struct scatterlist *sglist,
>      ^~~~~~~~~~~~~~~~~~
> drivers/staging/media/ipu3/ipu3-dmamap.c:251:5: warning: no previous prototype for 'ipu3_dmamap_init' [-Wmissing-prototypes]
>  int ipu3_dmamap_init(struct imgu_device *imgu)
>      ^~~~~~~~~~~~~~~~
> drivers/staging/media/ipu3/ipu3-dmamap.c:266:6: warning: no previous prototype for 'ipu3_dmamap_exit' [-Wmissing-prototypes]
>  void ipu3_dmamap_exit(struct imgu_device *imgu)
>       ^~~~~~~~~~~~~~~~
> In file included from drivers/staging/media/ipu3/ipu3-abi.h:7,
>                  from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3-css.c:7:
> drivers/staging/media/ipu3/include/intel-ipu3.h:2481:35: warning: 'awb_fr' offset 36756 in 'struct ipu3_uapi_acc_param' isn't aligned to 32 [-Wpacked-not-aligned]
>   struct ipu3_uapi_awb_fr_config_s awb_fr;
>                                    ^~~~~~
> In file included from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3-css.c:7:
> drivers/staging/media/ipu3/ipu3-abi.h:1250:1: warning: alignment 1 of 'struct imgu_abi_awb_fr_config' is less than 32 [-Wpacked-not-aligned]
>  } __packed;
>  ^
> drivers/staging/media/ipu3/ipu3-css.c: In function 'ipu3_css_fmt_try':
> drivers/staging/media/ipu3/ipu3-css.c:1831:30: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>   if (css->pipes[pipe].bindex < 0) {
>                               ^
> In file included from drivers/staging/media/ipu3/ipu3-abi.h:7,
>                  from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3.h:14,
>                  from drivers/staging/media/ipu3/ipu3.c:15:
> drivers/staging/media/ipu3/include/intel-ipu3.h:2481:35: warning: 'awb_fr' offset 36756 in 'struct ipu3_uapi_acc_param' isn't aligned to 32 [-Wpacked-not-aligned]
>   struct ipu3_uapi_awb_fr_config_s awb_fr;
>                                    ^~~~~~
> In file included from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3.h:14,
>                  from drivers/staging/media/ipu3/ipu3.c:15:
> drivers/staging/media/ipu3/ipu3-abi.h:1250:1: warning: alignment 1 of 'struct imgu_abi_awb_fr_config' is less than 32 [-Wpacked-not-aligned]
>  } __packed;
>  ^
> In file included from drivers/staging/media/ipu3/ipu3-abi.h:7,
>                  from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3.h:14,
>                  from drivers/staging/media/ipu3/ipu3-v4l2.c:10:
> drivers/staging/media/ipu3/include/intel-ipu3.h:2481:35: warning: 'awb_fr' offset 36756 in 'struct ipu3_uapi_acc_param' isn't aligned to 32 [-Wpacked-not-aligned]
>   struct ipu3_uapi_awb_fr_config_s awb_fr;
>                                    ^~~~~~
> In file included from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3.h:14,
>                  from drivers/staging/media/ipu3/ipu3-v4l2.c:10:
> drivers/staging/media/ipu3/ipu3-abi.h:1250:1: warning: alignment 1 of 'struct imgu_abi_awb_fr_config' is less than 32 [-Wpacked-not-aligned]
>  } __packed;
>  ^
> drivers/staging/media/ipu3/ipu3-css-params.c:drivers/staging/media/ipu3/ipu3-css-params.c:1947:5:  warning: symbol 'ipu3_css_cfg_acc' was not declared. Should it be static?
> drivers/staging/media/ipu3/ipu3-css-params.c:drivers/staging/media/ipu3/ipu3-css-params.c:2725:5:  warning: symbol 'ipu3_css_cfg_vmem0' was not declared. Should it be static?
> drivers/staging/media/ipu3/ipu3-css-params.c:drivers/staging/media/ipu3/ipu3-css-params.c:2804:5:  warning: symbol 'ipu3_css_cfg_dmem0' was not declared. Should it be static?
> drivers/staging/media/ipu3/ipu3-css-params.c:drivers/staging/media/ipu3/ipu3-css-params.c:2856:6:  warning: symbol 'ipu3_css_cfg_gdc_table' was not declared. Should it be static?
> In file included from drivers/staging/media/ipu3/ipu3-abi.h:7,
>                  from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3-css-params.c:6:
> drivers/staging/media/ipu3/include/intel-ipu3.h:2481:35: warning: 'awb_fr' offset 36756 in 'struct ipu3_uapi_acc_param' isn't aligned to 32 [-Wpacked-not-aligned]
>   struct ipu3_uapi_awb_fr_config_s awb_fr;
>                                    ^~~~~~
> In file included from drivers/staging/media/ipu3/ipu3-css.h:10,
>                  from drivers/staging/media/ipu3/ipu3-css-params.c:6:
> drivers/staging/media/ipu3/ipu3-abi.h:1250:1: warning: alignment 1 of 'struct imgu_abi_awb_fr_config' is less than 32 [-Wpacked-not-aligned]
>  } __packed;
>  ^
> drivers/staging/media/ipu3/ipu3-css-params.c:1947:5: warning: no previous prototype for 'ipu3_css_cfg_acc' [-Wmissing-prototypes]
>  int ipu3_css_cfg_acc(struct ipu3_css *css, unsigned int pipe,
>      ^~~~~~~~~~~~~~~~
> drivers/staging/media/ipu3/ipu3-css-params.c:2725:5: warning: no previous prototype for 'ipu3_css_cfg_vmem0' [-Wmissing-prototypes]
>  int ipu3_css_cfg_vmem0(struct ipu3_css *css, unsigned int pipe,
>      ^~~~~~~~~~~~~~~~~~
> drivers/staging/media/ipu3/ipu3-css-params.c:2804:5: warning: no previous prototype for 'ipu3_css_cfg_dmem0' [-Wmissing-prototypes]
>  int ipu3_css_cfg_dmem0(struct ipu3_css *css, unsigned int pipe,
>      ^~~~~~~~~~~~~~~~~~
> drivers/staging/media/ipu3/ipu3-css-params.c:2856:6: warning: no previous prototype for 'ipu3_css_cfg_gdc_table' [-Wmissing-prototypes]
>  void ipu3_css_cfg_gdc_table(struct imgu_abi_gdc_warp_param *gdc,
>       ^~~~~~~~~~~~~~~~~~~~~~
> In file included from drivers/staging/media/ipu3/ipu3-abi.h:7,
>                  from drivers/staging/media/ipu3/ipu3-tables.h:7,
>                  from drivers/staging/media/ipu3/ipu3-tables.c:4:
> drivers/staging/media/ipu3/include/intel-ipu3.h:2481:35: warning: 'awb_fr' offset 36756 in 'struct ipu3_uapi_acc_param' isn't aligned to 32 [-Wpacked-not-aligned]
>   struct ipu3_uapi_awb_fr_config_s awb_fr;
>                                    ^~~~~~
> In file included from drivers/staging/media/ipu3/ipu3-tables.h:7,
>                  from drivers/staging/media/ipu3/ipu3-tables.c:4:
> drivers/staging/media/ipu3/ipu3-abi.h:1250:1: warning: alignment 1 of 'struct imgu_abi_awb_fr_config' is less than 32 [-Wpacked-not-aligned]
>  } __packed;
>  ^
> 
> Could you please send ASAP a patch series fixing them?
> 
> Thanks,
> Mauro

In time, I fixed a few really trivial warnings there, due to the
lack of an #include directive.

As this patch is trivial enough, I'll go ahead and just apply it.
I'll let the others for you to handle.

Thanks,
Mauro

[PATCH] ipu3: add missing #include

Lots of warning due to non-static functions are generated because
the headers with define them were not included.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/staging/media/ipu3/ipu3-css-params.c b/drivers/staging/media/ipu3/ipu3-css-params.c
index 776206ded83b..053edce54b71 100644
--- a/drivers/staging/media/ipu3/ipu3-css-params.c
+++ b/drivers/staging/media/ipu3/ipu3-css-params.c
@@ -6,6 +6,7 @@
 #include "ipu3-css.h"
 #include "ipu3-css-fw.h"
 #include "ipu3-tables.h"
+#include "ipu3-css-params.h"
 
 #define DIV_ROUND_CLOSEST_DOWN(a, b)	(((a) + ((b) / 2) - 1) / (b))
 #define roundclosest_down(a, b)		(DIV_ROUND_CLOSEST_DOWN(a, b) * (b))
diff --git a/drivers/staging/media/ipu3/ipu3-dmamap.c b/drivers/staging/media/ipu3/ipu3-dmamap.c
index 93a393d4e15e..5bed01d5b8df 100644
--- a/drivers/staging/media/ipu3/ipu3-dmamap.c
+++ b/drivers/staging/media/ipu3/ipu3-dmamap.c
@@ -12,6 +12,7 @@
 #include "ipu3.h"
 #include "ipu3-css-pool.h"
 #include "ipu3-mmu.h"
+#include "ipu3-dmamap.h"
 
 /*
  * Free a buffer allocated by ipu3_dmamap_alloc_buffer()

