Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5ABC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 16:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B2F821783
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 16:11:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="ZMnfRO2E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfAJQL1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 11:11:27 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:41148 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbfAJQL1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 11:11:27 -0500
Received: from mailhost.synopsys.com (mailhost2.synopsys.com [10.13.184.66])
        by smtprelay.synopsys.com (Postfix) with ESMTP id 9F6EB24E1242;
        Thu, 10 Jan 2019 08:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1547136686; bh=V1dk82MJv0Cqk7QD27S8dVm82/bTFkKWV2QTx2TOXEY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To:From;
        b=ZMnfRO2EitCtklyok15An7enh7eB8frYyZXoIGTRYvP+ulQE9SvruUTrw/vK31nOe
         q1L/pOewzT2ZFXVrrDBE2EUuFs2DUoHixr6chXuxUSM5F4nZhHXmfIPWWCQlpWgCup
         +MwCJ17AixE0p9iJLCMwbjDaA+4AU/dLQbMihfh+eMcE3HOlKQW7gtB92+G+bF0Tb1
         F/ifeZ3WmHkIR7jyV2y8FNb4PTXCPaLk072tt5wbbn4tvIb+adoEeBszutOaGRPdU/
         Cbxlf4QAZ7XeJG0tw+yeMMBeJSwWsKL9IVF7wel3IppVllzIp0DIbj3NMdeKvlj2Hi
         Us3q22rZG+dlw==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4EE3933BA;
        Thu, 10 Jan 2019 08:11:23 -0800 (PST)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 10 Jan 2019 08:11:23 -0800
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 DE02WEHTCA.internal.synopsys.com (10.225.19.92) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 10 Jan 2019 17:11:20 +0100
Received: from [10.107.19.13] (10.107.19.13) by
 DE02WEHTCB.internal.synopsys.com (10.225.19.80) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 10 Jan 2019 17:11:20 +0100
Subject: Re: [V3, 4/4] media: platform: dwc: Add MIPI CSI-2 controller driver
To:     "Eugen.Hristev@microchip.com" <Eugen.Hristev@microchip.com>,
        "luis.oliveira@synopsys.com" <luis.oliveira@synopsys.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "joao.pinto@synopsys.com" <joao.pinto@synopsys.com>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "todor.tomov@linaro.org" <todor.tomov@linaro.org>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-5-git-send-email-lolivei@synopsys.com>
 <ea589e15-a39d-84c0-f0ee-0f434273027b@microchip.com>
From:   Luis de Oliveira <luis.oliveira@synopsys.com>
Message-ID: <a40eac78-ab1a-9694-0f83-dd0ca64d96df@synopsys.com>
Date:   Thu, 10 Jan 2019 16:11:18 +0000
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <ea589e15-a39d-84c0-f0ee-0f434273027b@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.107.19.13]
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 10-Dec-18 12:39, Eugen.Hristev@microchip.com wrote:
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
> [...]
> 
> snip
> 
> 
>> +
>> +static int
>> +dw_mipi_csi_parse_dt(struct platform_device *pdev, struct mipi_csi_dev *dev)
>> +{
>> +	struct device_node *node = pdev->dev.of_node;
>> +	struct v4l2_fwnode_endpoint endpoint;
> 
> Hello Luis,
> 
> I believe you have to initialize "endpoint" here correctly, otherwise 
> the parsing mechanism (fwnode_endpoint_parse) will consider you have a 
> specific mbus type and fail to probe the endpoint: bail out with debug 
> message "expecting bus type not found "
> 
> (namely, initialize to zero which is the UNKNOWN mbus type, or , to a 
> specific mbus (from DT or whatever source))
> 
> Eugen
> 
Hi Eugen,

Sorry for my late reply, I was on Christmas break.
You are right, I will add that fix.

> 
>> +	int ret;
>> +
>> +	node = of_graph_get_next_endpoint(node, NULL);
>> +	if (!node) {
>> +		dev_err(&pdev->dev, "No port node at %s\n",
>> +				pdev->dev.of_node->full_name);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(node), &endpoint);
>> +	if (ret)
>> +		goto err;
>> +
>> +	dev->index = endpoint.base.port - 1;
>> +	if (dev->index >= CSI_MAX_ENTITIES) {
>> +		ret = -ENXIO;
>> +		goto err;
>> +	}
>> +	dev->hw.num_lanes = endpoint.bus.mipi_csi2.num_data_lanes;
>> +
>> +err:
>> +	of_node_put(node);
>> +	return ret;
>> +}
>> +
> 
> snip
> 
Thank you.
