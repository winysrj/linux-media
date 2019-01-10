Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327A5C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 16:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8F0C20685
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 16:18:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="M2pK/8FU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbfAJQSp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 11:18:45 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:41458 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727788AbfAJQSo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 11:18:44 -0500
Received: from mailhost.synopsys.com (mailhost2.synopsys.com [10.13.184.66])
        by smtprelay.synopsys.com (Postfix) with ESMTP id 0A59924E1190;
        Thu, 10 Jan 2019 08:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1547137124; bh=e36giWoucqJ1mkLZysgssgXf4Q045PYv6EaiUSHhT5k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To:From;
        b=M2pK/8FUvc4OMMR2IdgmbgfCrnYvWlEdMUpJwB2YYm3bxx3DmTafaCikaqNDLUKEf
         NmPKrPjUYJTFCKMXf7xU9mYNMRzrCCXG5U3tQOSrZyzb+eHXTbfesSVNPCHdfeMuXY
         ZYcsaFEKSv0wvTmOLAJIPDvEOjOqHZxJ9j3cK48uwmItVinLEgKH/Qji/N8Dd2rbYi
         UD9EuejkY/eVdiITQ56cmI7rEi98wSZwwPPWShlWSgNZY0LczLvqvX4dDHXnZuzjuo
         NSwFibHlZilHM1+pqUVaPtl1hCLpSZxJFF2gO3gOskWeLmnim0eBCkphdSYa+5WHNT
         /zppvy/1hDC5A==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        by mailhost.synopsys.com (Postfix) with ESMTP id BD7EA31BF;
        Thu, 10 Jan 2019 08:18:43 -0800 (PST)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 10 Jan 2019 08:18:43 -0800
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 DE02WEHTCA.internal.synopsys.com (10.225.19.92) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 10 Jan 2019 17:18:41 +0100
Received: from [10.107.19.13] (10.107.19.13) by
 DE02WEHTCB.internal.synopsys.com (10.225.19.80) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 10 Jan 2019 17:18:41 +0100
Subject: Re: [V3, 4/4] media: platform: dwc: Add MIPI CSI-2 controller driver
To:     <Eugen.Hristev@microchip.com>, <luis.oliveira@synopsys.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <joao.pinto@synopsys.com>, <festevam@gmail.com>,
        <mchehab@kernel.org>, <gregkh@linuxfoundation.org>,
        <davem@davemloft.net>, <akpm@linux-foundation.org>,
        <arnd@arndb.de>, <hans.verkuil@cisco.com>,
        <laurent.pinchart@ideasonboard.com>, <geert@linux-m68k.org>,
        <narmstrong@baylibre.com>, <p.zabel@pengutronix.de>,
        <treding@nvidia.com>, <maxime.ripard@bootlin.com>,
        <todor.tomov@linaro.org>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-5-git-send-email-lolivei@synopsys.com>
 <4db76eb2-460f-c644-6dbd-370b07b2def8@microchip.com>
From:   Luis de Oliveira <luis.oliveira@synopsys.com>
Message-ID: <2407a3ca-1a83-5685-c26c-a922251b2943@synopsys.com>
Date:   Thu, 10 Jan 2019 16:18:38 +0000
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <4db76eb2-460f-c644-6dbd-370b07b2def8@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.107.19.13]
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 09-Jan-19 13:07, Eugen.Hristev@microchip.com wrote:
> 
> 
> On 19.10.2018 15:52, Luis Oliveira wrote:
>> Add the Synopsys MIPI CSI-2 controller driver. This
>> controller driver is divided in platform dependent functions
>> and core functions. It also includes a platform for future
>> DesignWare drivers.
>>
>> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
>> ---
>> Changelog
>> v2-V3
>> - exposed IPI settings to userspace
>> - fixed headers
>>
>>   MAINTAINERS                              |  11 +
>>   drivers/media/platform/dwc/Kconfig       |  30 +-
>>   drivers/media/platform/dwc/Makefile      |   2 +
>>   drivers/media/platform/dwc/dw-csi-plat.c | 699 +++++++++++++++++++++++++++++++
>>   drivers/media/platform/dwc/dw-csi-plat.h |  77 ++++
>>   drivers/media/platform/dwc/dw-mipi-csi.c | 494 ++++++++++++++++++++++
>>   drivers/media/platform/dwc/dw-mipi-csi.h | 202 +++++++++
>>   include/media/dwc/dw-mipi-csi-pltfrm.h   | 102 +++++
>>   8 files changed, 1616 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/media/platform/dwc/dw-csi-plat.c
>>   create mode 100644 drivers/media/platform/dwc/dw-csi-plat.h
>>   create mode 100644 drivers/media/platform/dwc/dw-mipi-csi.c
>>   create mode 100644 drivers/media/platform/dwc/dw-mipi-csi.h
>>   create mode 100644 include/media/dwc/dw-mipi-csi-pltfrm.h
>>
> 
> [snip]
> 
>> +/* Video formats supported by the MIPI CSI-2 */
>> +const struct mipi_fmt dw_mipi_csi_formats[] = {
>> +	{
>> +		/* RAW 8 */
>> +		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
>> +		.depth = 8,
>> +	},
>> +	{
>> +		/* RAW 10 */
>> +		.code = MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE,
>> +		.depth = 10,
>> +	},
> 
> Hi Luis,
> 
> Any reason why RAW12 format is not handled here ?
> 
> Here, namely MEDIA_BUS_FMT_SBGGR12_1X12 etc.
> 
Hi Eugen,

My Hw testing setup currently does not support it, so I didn't add it.

>> +	{
>> +		/* RGB 565 */
>> +		.code = MEDIA_BUS_FMT_RGB565_2X8_BE,
>> +		.depth = 16,
>> +	},
>> +	{
>> +		/* BGR 565 */
>> +		.code = MEDIA_BUS_FMT_RGB565_2X8_LE,
>> +		.depth = 16,
>> +	},
>> +	{
>> +		/* RGB 888 */
>> +		.code = MEDIA_BUS_FMT_RGB888_2X12_LE,
>> +		.depth = 24,
>> +	},
>> +	{
>> +		/* BGR 888 */
>> +		.code = MEDIA_BUS_FMT_RGB888_2X12_BE,
>> +		.depth = 24,
>> +	},
>> +};
> 
> [snip]
> 
>> +
>> +void dw_mipi_csi_set_ipi_fmt(struct mipi_csi_dev *csi_dev)
>> +{
>> +	struct device *dev = csi_dev->dev;
>> +
>> +	if (csi_dev->ipi_dt)
>> +		dw_mipi_csi_write(csi_dev, reg.IPI_DATA_TYPE, csi_dev->ipi_dt);
>> +	else {
>> +		switch (csi_dev->fmt->code) {
>> +		case MEDIA_BUS_FMT_RGB565_2X8_BE:
>> +		case MEDIA_BUS_FMT_RGB565_2X8_LE:
>> +			dw_mipi_csi_write(csi_dev,
>> +					reg.IPI_DATA_TYPE, CSI_2_RGB565);
>> +			dev_dbg(dev, "DT: RGB 565");
>> +			break;
>> +
>> +		case MEDIA_BUS_FMT_RGB888_2X12_LE:
>> +		case MEDIA_BUS_FMT_RGB888_2X12_BE:
>> +			dw_mipi_csi_write(csi_dev,
>> +					reg.IPI_DATA_TYPE, CSI_2_RGB888);
>> +			dev_dbg(dev, "DT: RGB 888");
>> +			break;
>> +		case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE:
>> +			dw_mipi_csi_write(csi_dev,
>> +					reg.IPI_DATA_TYPE, CSI_2_RAW10);
>> +			dev_dbg(dev, "DT: RAW 10");
>> +			break;
>> +		case MEDIA_BUS_FMT_SBGGR8_1X8:
>> +			dw_mipi_csi_write(csi_dev,
>> +					reg.IPI_DATA_TYPE, CSI_2_RAW8);
>> +			dev_dbg(dev, "DT: RAW 8");
>> +			break;
> 
> Same here, in CSI_2_RAW12 case it will default to a RGB565 case.
> 
> Thanks,
> 
> Eugen
> 
> 
I will try to add the support for this data type in my next patchset if not I
will flag it as unsupported for now in the commit message and code.

Thanks for your review,
Luis

> 
>> +		default:
>> +			dw_mipi_csi_write(csi_dev,
>> +					reg.IPI_DATA_TYPE, CSI_2_RGB565);
>> +			dev_dbg(dev, "Error");
>> +			break;
>> +		}
>> +	}
>> +}
>> +
> 
> [snip]
> 
