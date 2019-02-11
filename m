Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E906C282CE
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A5B620838
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:54:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="HUvf8H1j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfBKKyB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:54:01 -0500
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:42593 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbfBKKyB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:54:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4003; q=dns/txt; s=iport;
  t=1549882440; x=1551092040;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=xIX20aRaH3nfQswz7eAW0uvpUbPmdxoljMavCY0LIZU=;
  b=HUvf8H1jjV+rqmw3A1BGbEO8q1667J/GwbyHeMci9HyZNtNBXDHu80JI
   IVXGtkMkHsMNY84/gxRZCW6FH7O0Kr33SejrKwD57Dp7wCMWNJecjLlRv
   Y5aTvK1YkRf42mmMmxQelPi1p5mbzn2Bo+Ks+nIJ9VU/4zRic9DHz7NCQ
   0=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AGAACyU2Fc/5pdJa1jGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBUQUBAQEBCwGCA4FqJwqMFIttgg18gWWCQTCDVwGOaYF7CwE?=
 =?us-ascii?q?BhGyDPSI0CQ0BAwEBAgEBAm0ohUoBAQEBAgEnEz8FCwIBCA4KHhAyJQIEAQ0?=
 =?us-ascii?q?FCIUGAw0Iqh0zgk6BNgGGIoxDF4FAP4ERgl01gleCKoVgApA5kjMzCQKPFIM?=
 =?us-ascii?q?yIZJgijOGaYp5AhEUgScfOIFWcBU7gmyQJgE2QTGLQ4EfAQE?=
X-IronPort-AV: E=Sophos;i="5.58,358,1544486400"; 
   d="scan'208";a="505684706"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2019 10:53:59 +0000
Received: from XCH-RCD-013.cisco.com (xch-rcd-013.cisco.com [173.37.102.23])
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id x1BArxqU023058
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 11 Feb 2019 10:53:59 GMT
Received: from xch-aln-012.cisco.com (173.36.7.22) by XCH-RCD-013.cisco.com
 (173.37.102.23) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 Feb
 2019 04:53:58 -0600
Received: from xch-aln-012.cisco.com ([173.36.7.22]) by XCH-ALN-012.cisco.com
 ([173.36.7.22]) with mapi id 15.00.1395.000; Mon, 11 Feb 2019 04:53:58 -0600
From:   "Hans Verkuil (hansverk)" <hansverk@cisco.com>
To:     Wen Yang <yellowriver2010@hotmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>
CC:     "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] media: tegra-cec: fix possible object reference leak
Thread-Topic: [PATCH 4/4] media: tegra-cec: fix possible object reference leak
Thread-Index: AQHUwCLlBsdDSs++2E+MAWtRp0BX7w==
Date:   Mon, 11 Feb 2019 10:53:58 +0000
Message-ID: <acfbc23ff09e48db9c5cffebee87a3a4@XCH-ALN-012.cisco.com>
References: <HK0PR02MB363490E3F738F20868E8BD9DB26A0@HK0PR02MB3634.apcprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.61.175.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Outbound-SMTP-Client: 173.37.102.23, xch-rcd-013.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 09/02/2019 03:55, Wen Yang wrote:=0A=
> The call to of_parse_phandle() returns a node pointer with refcount=0A=
> incremented thus it must be explicitly decremented here after the last=0A=
> usage.=0A=
> The of_find_device_by_node() takes a reference to the underlying device=
=0A=
> structure, we also should release that reference.=0A=
> This patch fixes those two issues.=0A=
> =0A=
> Fixes: 9d2d60687c9a ("media: tegra-cec: add Tegra HDMI CEC driver")=0A=
> Signed-off-by: Wen Yang <yellowriver2010@hotmail.com>=0A=
> ---=0A=
>  drivers/media/platform/tegra-cec/tegra_cec.c | 20 ++++++++++++++++----=
=0A=
>  1 file changed, 16 insertions(+), 4 deletions(-)=0A=
> =0A=
> diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media=
/platform/tegra-cec/tegra_cec.c=0A=
> index aba488c..b6c28c8 100644=0A=
> --- a/drivers/media/platform/tegra-cec/tegra_cec.c=0A=
> +++ b/drivers/media/platform/tegra-cec/tegra_cec.c=0A=
> @@ -340,19 +340,24 @@ static int tegra_cec_probe(struct platform_device *=
pdev)=0A=
>  		return -ENODEV;=0A=
>  	}=0A=
>  	hdmi_dev =3D of_find_device_by_node(np);=0A=
> -	if (hdmi_dev =3D=3D NULL)=0A=
> +	if (hdmi_dev =3D=3D NULL) {=0A=
> +		of_node_put(np);=0A=
>  		return -EPROBE_DEFER;=0A=
> +	}=0A=
> +	of_node_put(np);=0A=
=0A=
You can move this line to just after the 'hdmi_dev =3D of_find_device_by_no=
de(np);'=0A=
line.=0A=
=0A=
>  =0A=
>  	cec =3D devm_kzalloc(&pdev->dev, sizeof(struct tegra_cec), GFP_KERNEL);=
=0A=
> -=0A=
> -	if (!cec)=0A=
> +	if (!cec) {=0A=
> +		put_device(&hdmi_dev->dev);=0A=
=0A=
You don't need to do this. In fact, the put_device can be done before the=
=0A=
cec =3D devm_kzalloc line.=0A=
=0A=
There is no need for this driver to keep a reference to the hdmi device, th=
e=0A=
device pointer is only used as a key in the notifier list. This cec driver=
=0A=
will never access the hdmi device.=0A=
=0A=
There are several other CEC drivers that have this same mistake and that=0A=
need to put the hdmi_dev device.=0A=
=0A=
Regards,=0A=
=0A=
	Hans=0A=
=0A=
>  		return -ENOMEM;=0A=
> +	}=0A=
>  =0A=
>  	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);=0A=
>  =0A=
>  	if (!res) {=0A=
>  		dev_err(&pdev->dev,=0A=
>  			"Unable to allocate resources for device\n");=0A=
> +		put_device(&hdmi_dev->dev);=0A=
>  		return -EBUSY;=0A=
>  	}=0A=
>  =0A=
> @@ -360,19 +365,23 @@ static int tegra_cec_probe(struct platform_device *=
pdev)=0A=
>  		pdev->name)) {=0A=
>  		dev_err(&pdev->dev,=0A=
>  			"Unable to request mem region for device\n");=0A=
> +		put_device(&hdmi_dev->dev);=0A=
>  		return -EBUSY;=0A=
>  	}=0A=
>  =0A=
>  	cec->tegra_cec_irq =3D platform_get_irq(pdev, 0);=0A=
>  =0A=
> -	if (cec->tegra_cec_irq <=3D 0)=0A=
> +	if (cec->tegra_cec_irq <=3D 0) {=0A=
> +		put_device(&hdmi_dev->dev);=0A=
>  		return -EBUSY;=0A=
> +	}=0A=
>  =0A=
>  	cec->cec_base =3D devm_ioremap_nocache(&pdev->dev, res->start,=0A=
>  					     resource_size(res));=0A=
>  =0A=
>  	if (!cec->cec_base) {=0A=
>  		dev_err(&pdev->dev, "Unable to grab IOs for device\n");=0A=
> +		put_device(&hdmi_dev->dev);=0A=
>  		return -EBUSY;=0A=
>  	}=0A=
>  =0A=
> @@ -380,6 +389,7 @@ static int tegra_cec_probe(struct platform_device *pd=
ev)=0A=
>  =0A=
>  	if (IS_ERR_OR_NULL(cec->clk)) {=0A=
>  		dev_err(&pdev->dev, "Can't get clock for CEC\n");=0A=
> +		put_device(&hdmi_dev->dev);=0A=
>  		return -ENOENT;=0A=
>  	}=0A=
>  =0A=
> @@ -397,12 +407,14 @@ static int tegra_cec_probe(struct platform_device *=
pdev)=0A=
>  	if (ret) {=0A=
>  		dev_err(&pdev->dev,=0A=
>  			"Unable to request interrupt for device\n");=0A=
> +		put_device(&hdmi_dev->dev);=0A=
>  		goto clk_error;=0A=
>  	}=0A=
>  =0A=
>  	cec->notifier =3D cec_notifier_get(&hdmi_dev->dev);=0A=
>  	if (!cec->notifier) {=0A=
>  		ret =3D -ENOMEM;=0A=
> +		put_device(&hdmi_dev->dev);=0A=
>  		goto clk_error;=0A=
>  	}=0A=
>  =0A=
> =0A=
=0A=
