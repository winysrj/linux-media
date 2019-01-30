Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA34C282D8
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 12:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E8FC21473
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 12:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbfA3Mlb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 07:41:31 -0500
Received: from mga17.intel.com ([192.55.52.151]:8896 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfA3Mla (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 07:41:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2019 04:41:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,540,1539673200"; 
   d="scan'208";a="314853336"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2019 04:41:27 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 15F2D203F8; Wed, 30 Jan 2019 14:41:27 +0200 (EET)
Date:   Wed, 30 Jan 2019 14:41:26 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Rui Miguel Silva <rui.silva@linaro.org>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v11 00/13] media: staging/imx7: add i.MX7 media driver
Message-ID: <20190130124126.ahewjkc7ycko5ckg@paasikivi.fi.intel.com>
References: <20190124160928.31884-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124160928.31884-1-rui.silva@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 24, 2019 at 04:09:15PM +0000, Rui Miguel Silva wrote:
> Hi,
> This series introduces the Media driver to work with the i.MX7 SoC. it uses the
> already existing imx media core drivers but since the i.MX7, contrary to
> i.MX5/6, do not have an IPU and because of that some changes in the imx media
> core are made along this series to make it support that case.
> 
> This patches adds CSI and MIPI-CSI2 drivers for i.MX7, along with several
> configurations changes for this to work as a capture subsystem. Some bugs are
> also fixed along the line. And necessary documentation.
> 
> For a more detailed view of the capture paths, pads links in the i.MX7 please
> take a look at the documentation in PATCH 10.
> 
> The system used to test and develop this was the Warp7 board with an OV2680
> sensor, which output format is 10-bit bayer. So, only MIPI interface was
> tested, a scenario with an parallel input would nice to have.
> 
> Bellow goes an example of the output of the pads and links and the output of
> v4l2-compliance testing.
> 
> The v4l-utils version used is:
> v4l2-compliance SHA: 1a6c8fe9a65c26e78ba34bd4aa2df28ede7d00cb, 32 bits
> 
> The Media Driver fail some tests but this failures are coming from code out of
> scope of this series (imx-capture), and some from the sensor OV2680
> but that I think not related with the sensor driver but with the testing and
> core.
> 
> The csi and mipi-csi entities pass all compliance tests.

For patches 1, 4 and 10--13:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
