Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C5AC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 11:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 692C32077B
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 11:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfBELOk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 06:14:40 -0500
Received: from mga07.intel.com ([134.134.136.100]:51889 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbfBELOk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 06:14:40 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2019 03:14:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,563,1539673200"; 
   d="scan'208";a="141693781"
Received: from ekorotko-mobl1.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.43.22])
  by fmsmga004.fm.intel.com with ESMTP; 05 Feb 2019 03:14:37 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 9185821D9A; Tue,  5 Feb 2019 13:14:36 +0200 (EET)
Date:   Tue, 5 Feb 2019 13:14:36 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Rui Miguel Silva <rui.silva@linaro.org>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v12 00/13] media: staging/imx7: add i.MX7 media driver
Message-ID: <20190205111435.2oz46dqphfdt6mn5@kekkonen.localdomain>
References: <20190204120039.1198-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204120039.1198-1-rui.silva@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rui,

On Mon, Feb 04, 2019 at 12:00:26PM +0000, Rui Miguel Silva wrote:
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
> 
> Cheers,
>     Rui
> 
> v11->v12:
>   Sakari:
>     - check v4l2_ctrl_handler_free and init when exposed to userspace
>     - check csi_remove missing v4l2_async_notifier_unregister
>     - media device unregister before ctrl_handler_free
>     - GPL => GPL v2
>     - Fix squash of CSI patches, issue on v11
>     - add Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com> 10--13
>     - mipi_s_stream check for ret < 0 and call pm_runtime_put_noidle
>     - use __maybe_unused in pm functions
>     - Extra space before labels

For patches 1, 2 and 4:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Thanks!

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
