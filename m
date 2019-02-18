Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80F7C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 11:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80F812177E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 11:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbfBRLqN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 06:46:13 -0500
Received: from mga17.intel.com ([192.55.52.151]:64550 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbfBRLqN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 06:46:13 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2019 03:46:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,384,1544515200"; 
   d="scan'208";a="123300514"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga007.fm.intel.com with ESMTP; 18 Feb 2019 03:46:10 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 3AB5D2063E; Mon, 18 Feb 2019 13:46:09 +0200 (EET)
Date:   Mon, 18 Feb 2019 13:46:09 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     hans.verkuil@cisco.com, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, graphics@pengutronix.de
Subject: Re: [PATCH 3/3] media: tc358746: update MAINTAINERS file
Message-ID: <20190218114608.qvoeyxlaw4yjrnnh@paasikivi.fi.intel.com>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-4-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218141240.3056-4-m.felsch@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Marco,

On Tue, Dec 18, 2018 at 03:12:40PM +0100, Marco Felsch wrote:
> Add me as partial maintainer, others are welcome too.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 546f8d936589..f97dedbe545c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15230,6 +15230,13 @@ S:	Maintained
>  F:	drivers/media/i2c/tc358743*
>  F:	include/media/i2c/tc358743.h
>  
> +TOSHIBA TC358746 DRIVER
> +M:	Marco Felsch <kernel@pengutronix.de>
> +L:	linux-media@vger.kernel.org
> +S:	Odd Fixes
> +F:	drivers/media/i2c/tc358746*
> +F:	Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> +
>  TOSHIBA WMI HOTKEYS DRIVER
>  M:	Azael Avalos <coproscefalo@gmail.com>
>  L:	platform-driver-x86@vger.kernel.org

This should go together with the DT bindings, in the same patch.

I'd expect a new driver to be listed as "Maintained". "Odd Fixes" suggests
no-one is particularly looking after it, and it's not nice if a new driver
starts off like that. :-I

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
