Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C192C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E17F20870
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:01:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="PKBVY9SC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E17F20870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbeLMLBK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 06:01:10 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:47872 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbeLMLBK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 06:01:10 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 82ACB549;
        Thu, 13 Dec 2018 12:01:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544698868;
        bh=S/HO3wPl/pb3qjFoHoQscFOQXK2/EP99mq0tPDpuPsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKBVY9SCxxRqruKN55/rQq5nV095xtz0DRs0rUescfLIUNdjcUT5l4ejDQn/zYUi4
         abdfN6iubYVQdVBdyHIHVkh5z93bX3NrjOdgFAuie/VJZnSX6jJkl1eSuDbLLXBar/
         VNxOp+PJzB0BwTDWGd0saZ6wvKAQLeQIlMKOtPJg=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, yong.zhi@intel.com,
        rajmohan.mani@intel.com
Subject: Re: [PATCH v9 22/22] staging/ipu3-imgu: Add MAINTAINERS entry
Date:   Thu, 13 Dec 2018 13:01:55 +0200
Message-ID: <2125144.CY5uZKgWiE@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181213095107.14894-23-sakari.ailus@linux.intel.com>
References: <20181213095107.14894-1-sakari.ailus@linux.intel.com> <20181213095107.14894-23-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Thank you for the patch.

On Thursday, 13 December 2018 11:51:07 EET Sakari Ailus wrote:
> Add a MAINTAINERS entry for the ImgU driver.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3e9f1710ed13e..9ed5cff35e075 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7587,6 +7587,14 @@ S:	Maintained
>  F:	drivers/media/pci/intel/ipu3/
>  F:	Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
> 
> +INTEL IPU3 CSI-2 IMGU DRIVER
> +M:	Sakari Ailus <sakari.ailus@linux.intel.com>
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	drivers/staging/media/ipu3/
> +F:	Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> +F:	Documentation/media/v4l-drivers/ipu3.rst
> +

Do you realize what you're getting into ? ;-)

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

And thank you.

>  INTEL IXP4XX QMGR, NPE, ETHERNET and HSS SUPPORT
>  M:	Krzysztof Halasa <khalasa@piap.pl>
>  S:	Maintained

-- 
Regards,

Laurent Pinchart



