Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44721 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbeKXJ05 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 04:26:57 -0500
Received: by mail-pf1-f193.google.com with SMTP id u6so3858053pfh.11
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2018 14:40:51 -0800 (PST)
Subject: Re: [PATCH] media: v4l2-fwnode: Demote warning to debug level
To: Fabio Estevam <festevam@gmail.com>, mchehab@kernel.org
Cc: sakari.ailus@linux.intel.com, p.zabel@pengutronix.de,
        linux-media@vger.kernel.org
References: <1542977459-14550-1-git-send-email-festevam@gmail.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <8ccd4efd-45c5-39a6-0300-43d97b34dff1@gmail.com>
Date: Fri, 23 Nov 2018 14:40:48 -0800
MIME-Version: 1.0
In-Reply-To: <1542977459-14550-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Steve Longerbeam <slongerbeam@gmail.com>


On 11/23/18 4:50 AM, Fabio Estevam wrote:
> On a imx6q-wandboard the following warnings are observed:
>
> [    4.327794] video-mux 20e0000.iomuxc-gpr:ipu1_csi0_mux: bad remote port parent
> [    4.336118] video-mux 20e0000.iomuxc-gpr:ipu2_csi1_mux: bad remote port parent
>
> As explained by Philipp Zabel:
>
> "There are empty endpoint nodes (without remote-endpoint property)
> labeled ipu1_csi[01]_mux_from_parallel_sensor in the i.MX6 device trees
> for board DT implementers' convenience. See commit 2539f517acbdc ("ARM:
> dts: imx6qdl: Add video multiplexers, mipi_csi, and their connections")."
>
> So demote the warning to debug level and make the wording a bit
> less misleading.
>
> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>   drivers/media/v4l2-core/v4l2-fwnode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 218f0da..7a3cc10 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -613,7 +613,7 @@ v4l2_async_notifier_fwnode_parse_endpoint(struct device *dev,
>   	asd->match.fwnode =
>   		fwnode_graph_get_remote_port_parent(endpoint);
>   	if (!asd->match.fwnode) {
> -		dev_warn(dev, "bad remote port parent\n");
> +		dev_dbg(dev, "no remote endpoint found\n");
>   		ret = -ENOTCONN;
>   		goto out_err;
>   	}
