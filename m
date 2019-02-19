Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDC8C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C787E2146E
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfBSODY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:03:24 -0500
Received: from mga05.intel.com ([192.55.52.43]:24846 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbfBSODX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 09:03:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2019 06:03:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,388,1544515200"; 
   d="scan'208";a="119091183"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.44.116])
  by orsmga008.jf.intel.com with ESMTP; 19 Feb 2019 06:03:20 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 1882821E8D; Tue, 19 Feb 2019 16:03:18 +0200 (EET)
Date:   Tue, 19 Feb 2019 16:03:17 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] media: ipu3: shut up warnings produced with W=1
Message-ID: <20190219140317.hmsyybhbe7lan2ek@kekkonen.localdomain>
References: <0bdfc56c13c0ffe003f28395fcde2cd9b5ea0622.1550584828.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bdfc56c13c0ffe003f28395fcde2cd9b5ea0622.1550584828.git.mchehab+samsung@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

On Tue, Feb 19, 2019 at 09:00:29AM -0500, Mauro Carvalho Chehab wrote:
> There are lots of warnings produced by this driver. It is not
> as much as atomisp, but it is still a lot.
> 
> So, use the same solution to hide most of them.
> Those need to be fixed before promoting it out of staging,
> so add it at the TODO list.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/staging/media/ipu3/Makefile | 6 ++++++
>  drivers/staging/media/ipu3/TODO     | 2 ++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/staging/media/ipu3/Makefile b/drivers/staging/media/ipu3/Makefile
> index fb146d178bd4..fa7fa3372bcb 100644
> --- a/drivers/staging/media/ipu3/Makefile
> +++ b/drivers/staging/media/ipu3/Makefile
> @@ -9,3 +9,9 @@ ipu3-imgu-objs += \
>  		ipu3-css.o ipu3-v4l2.o ipu3.o
>  
>  obj-$(CONFIG_VIDEO_IPU3_IMGU) += ipu3-imgu.o
> +
> +# HACK! While this driver is in bad shape, don't enable several warnings
> +#       that would be otherwise enabled with W=1
> +ccflags-y += $(call cc-disable-warning, packed-not-aligned)
> +ccflags-y += $(call cc-disable-warning, type-limits)
> +ccflags-y += $(call cc-disable-warning, unused-const-variable)

I'm preparing patches to address these. Could you wait a little bit more,
please?

Thanks.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
