Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D328C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 14:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C667920848
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 14:38:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="dGusKQDm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbfCEOiF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 09:38:05 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37974 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbfCEOiF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 09:38:05 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x25Ebi87004964;
        Tue, 5 Mar 2019 08:37:44 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1551796664;
        bh=Tj2Jbcnxb801IHrUM9XlUUrlXeL6R9lIoKHS3vsi8YQ=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=dGusKQDm/YdixzZPf7aR9FIP8FLtHyb9brAOr7N1HRA186vSbZzKlmrVVkQsrkm5v
         jAlkpeFTaFOK9Dmx0EVAK1PSX0DSSWcms6Nkd8cNiSEiEzDX0aIB1drx5FIUvpfcSx
         Hp7xNMxPoh/v/K2xZBcKkgKhLy/Qxj7Wd4Shmm0M=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x25EbiCe048995
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 5 Mar 2019 08:37:44 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Tue, 5
 Mar 2019 08:37:44 -0600
Received: from dflp32.itg.ti.com (10.64.6.15) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_0,
 cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.1.1591.10 via Frontend Transport;
 Tue, 5 Mar 2019 08:37:44 -0600
Received: from ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by dflp32.itg.ti.com (8.14.3/8.13.8) with SMTP id x25Ebibo031424;
        Tue, 5 Mar 2019 08:37:44 -0600
Date:   Tue, 5 Mar 2019 08:34:09 -0600
From:   Benoit Parrot <bparrot@ti.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     <linux-media@vger.kernel.org>, <akinobu.mita@gmail.com>,
        <robert.jarzmik@free.fr>, <hverkuil@xs4all.nl>
Subject: Re: [PATCH v1.1 4/4] ti-vpe: Parse local endpoint for properties,
 not the remote one
Message-ID: <20190305143409.yzmusyvuaab5ap4w@ti.com>
References: <20190305135602.24199-5-sakari.ailus@linux.intel.com>
 <20190305140224.25889-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190305140224.25889-1-sakari.ailus@linux.intel.com>
User-Agent: NeoMutt/20171215
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sakari,

Thank you for the patch.

Sakari Ailus <sakari.ailus@linux.intel.com> wrote on Tue [2019-Mar-05 16:02:24 +0200]:
> ti-vpe driver parsed the remote endpoints for properties but ignored the
> local ones. Fix this by parsing the local endpoint properties instead.

I am not sure I understand the logic here.  For CSI2 sensor as far as I
understand the lane mapping (clock and data) is driven from the sensor
side. The bridge driver (in this case CAL) needs to setup the receiver side
based on what the sensor (aka remote endpoint) can provide.

I failed to see how this fixes things here.

Are you suggesting that sensor relevant properties be set (and effectively
duplicated) on the bridge/receiver side?

Some sensor can and do handle multiple data lanes configuration so the
sensor driver also needs to use those properties at probe time, duplicating
the lane data is just asking for a mismatch to happen, no?

Benoit

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> since v1:
> 
> - Remove of_node_put(remote_ep) as well, the only remaining reference to it.
> 
>  drivers/media/platform/ti-vpe/cal.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index fc3c212b96e1..8d075683e448 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -1643,8 +1643,7 @@ of_get_next_endpoint(const struct device_node *parent,
>  static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  {
>  	struct platform_device *pdev = ctx->dev->pdev;
> -	struct device_node *ep_node, *port, *remote_ep,
> -			*sensor_node, *parent;
> +	struct device_node *ep_node, *port, *sensor_node, *parent;
>  	struct v4l2_fwnode_endpoint *endpoint;
>  	struct v4l2_async_subdev *asd;
>  	u32 regval = 0;
> @@ -1657,7 +1656,6 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  
>  	ep_node = NULL;
>  	port = NULL;
> -	remote_ep = NULL;
>  	sensor_node = NULL;
>  	ret = -EINVAL;
>  
> @@ -1703,12 +1701,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
>  	asd->match.fwnode = of_fwnode_handle(sensor_node);
>  
> -	remote_ep = of_graph_get_remote_endpoint(ep_node);
> -	if (!remote_ep) {
> -		ctx_dbg(3, ctx, "can't get remote-endpoint\n");
> -		goto cleanup_exit;
> -	}
> -	v4l2_fwnode_endpoint_parse(of_fwnode_handle(remote_ep), endpoint);
> +	v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep_node), endpoint);
>  
>  	if (endpoint->bus_type != V4L2_MBUS_CSI2_DPHY) {
>  		ctx_err(ctx, "Port:%d sub-device %pOFn is not a CSI2 device\n",
> @@ -1759,7 +1752,6 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  	sensor_node = NULL;
>  
>  cleanup_exit:
> -	of_node_put(remote_ep);
>  	of_node_put(sensor_node);
>  	of_node_put(ep_node);
>  	of_node_put(port);
> -- 
> 2.11.0
> 
