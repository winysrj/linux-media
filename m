Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4996FC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 00:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2101720675
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 00:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfCEAJg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 19:09:36 -0500
Received: from mga03.intel.com ([134.134.136.65]:14865 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbfCEAJg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Mar 2019 19:09:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2019 16:09:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,441,1544515200"; 
   d="scan'208";a="279738418"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga004.jf.intel.com with ESMTP; 04 Mar 2019 16:09:33 -0800
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 4 Mar 2019 16:09:32 -0800
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 fmsmsx116.amr.corp.intel.com (10.18.116.20) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 4 Mar 2019 16:09:32 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.74]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.26]) with mapi id 14.03.0415.000;
 Tue, 5 Mar 2019 08:09:30 +0800
From:   "Cao, Bingbu" <bingbu.cao@intel.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "Zhi, Yong" <yong.zhi@intel.com>, Tomasz Figa <tfiga@chromium.org>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] media: staging/intel-ipu3: mark PM function as
 __maybe_unused
Thread-Topic: [PATCH] media: staging/intel-ipu3: mark PM function as
 __maybe_unused
Thread-Index: AQHU0skBhQ6EBfjbEE2shBfE7uTelaX8KELA
Date:   Tue, 5 Mar 2019 00:09:30 +0000
Message-ID: <EE45BB6704246A4E914B70E8B61FB42A15C13194@SHSMSX104.ccr.corp.intel.com>
References: <20190304202920.1845797-1-arnd@arndb.de>
In-Reply-To: <20190304202920.1845797-1-arnd@arndb.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOWExOWY4ODEtZjk0MS00M2JhLTk0MWEtZWRjYzQ5MGI4NDk1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibVZmbFE0S2NGajlkQjVLVXJqWlZhZStBY0Z6ZGlyVGJvZnE4eTA0bVkwMmRPMGhUZWRVejhzQjN6dDhUaUJvWCJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi, Bergmann,

Thanks for your patch.
Reviewed-by: Cao, Bingbu <bingbu.cao@intel.com>

__________________________
BRs,
Cao, Bingbu


> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, March 5, 2019 4:29 AM
> To: Sakari Ailus <sakari.ailus@linux.intel.com>; Mauro Carvalho Chehab
> <mchehab@kernel.org>; Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>; Zhi, Yong <yong.zhi@intel.com>;
> Tomasz Figa <tfiga@chromium.org>; Qiu, Tian Shu
> <tian.shu.qiu@intel.com>; Cao, Bingbu <bingbu.cao@intel.com>; linux-
> media@vger.kernel.org; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] media: staging/intel-ipu3: mark PM function as
> __maybe_unused
> 
> The imgu_rpm_dummy_cb() looks like an API misuse that is explained in
> the comment above it. Aside from that, it also causes a warning when
> power management support is disabled:
> 
> drivers/staging/media/ipu3/ipu3.c:794:12: error: 'imgu_rpm_dummy_cb'
> defined but not used [-Werror=unused-function]
> 
> The warning is at least easy to fix by marking the function as
> __maybe_unused.
> 
> Fixes: 7fc7af649ca7 ("media: staging/intel-ipu3: Add imgu top level pci
> device driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/staging/media/ipu3/ipu3.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/ipu3/ipu3.c
> b/drivers/staging/media/ipu3/ipu3.c
> index d575ac78c8f0..d00d26264c37 100644
> --- a/drivers/staging/media/ipu3/ipu3.c
> +++ b/drivers/staging/media/ipu3/ipu3.c
> @@ -791,7 +791,7 @@ static int __maybe_unused imgu_resume(struct device
> *dev)
>   * PCI rpm framework checks the existence of driver rpm callbacks.
>   * Place a dummy callback here to avoid rpm going into error state.
>   */
> -static int imgu_rpm_dummy_cb(struct device *dev)
> +static __maybe_unused int imgu_rpm_dummy_cb(struct device *dev)
>  {
>  	return 0;
>  }
> --
> 2.20.0

