Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367DEC10F03
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 12:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F95220840
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 12:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfCGM4P (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 07:56:15 -0500
Received: from mga18.intel.com ([134.134.136.126]:42960 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfCGM4O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 07:56:14 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Mar 2019 04:56:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,451,1544515200"; 
   d="scan'208";a="132336267"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga007.fm.intel.com with ESMTP; 07 Mar 2019 04:56:11 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 8ED73204CC; Thu,  7 Mar 2019 14:56:10 +0200 (EET)
Date:   Thu, 7 Mar 2019 14:56:10 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 31/31] media: rcar-csi2: Implement has_route()
Message-ID: <20190307125610.xtsobfteeu7ju45e@paasikivi.fi.intel.com>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-32-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190305185150.20776-32-jacopo+renesas@jmondi.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On Tue, Mar 05, 2019 at 07:51:50PM +0100, Jacopo Mondi wrote:
> Now that the rcar-csi2 subdevice supports internal routing, add an
> has_route() operation used during graph traversal.
> 
> The internal routing between the sink and the source pads depends on the
> virtual channel used to transmit the video stream from the remote
> subdevice to the R-Car CSI-2 receiver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 35 +++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index cc7077b40f18..6c46bcc0ee83 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -1028,7 +1028,42 @@ static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
>   * Platform Device Driver.
>   */
>  
> +static bool rcar_csi2_has_route(struct media_entity *entity,
> +				unsigned int pad0, unsigned int pad1)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> +	struct v4l2_mbus_frame_desc fd;
> +	unsigned int i;
> +	int ret;
> +
> +	/* Support only direct sink->source routes. */
> +	if (pad0 != RCAR_CSI2_SINK)
> +		return false;
> +
> +	/* Get the frame description: from CSI-2 VC to source pad number. */
> +	ret = rcsi2_get_remote_frame_desc(priv, &fd);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < fd.num_entries; i++) {
> +		struct v4l2_mbus_frame_desc_entry *entry = &fd.entry[i];
> +		int source_pad = rcsi2_vc_to_pad(entry->bus.csi2.channel);

A newline here would make this prettier IMO.

> +		if (source_pad < 0) {
> +			dev_err(priv->dev, "Virtual Channel out of range: %u\n",
> +				entry->bus.csi2.channel);
> +			return -EINVAL;

-EINVAL will be cast as true... same above.

This op wasn't really intended to fail. That should instead happen in e.g.
link or route configuration.

I think that if the two endpoints are in an agreement on the fundamental
CSI-2 bus parameters, I'd expect this just to work. Or is your CSI-2
receiver restricted to fewer virtual channels?

Alternatively we could make the frame descriptors settable as well so that
the receiver driver could use them to configure the transmitter. That'd
probably not be trivial to implement though.

> +		}
> +
> +		if (source_pad == pad1)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  static const struct media_entity_operations rcar_csi2_entity_ops = {
> +	.has_route = rcar_csi2_has_route,
>  	.link_validate = v4l2_subdev_link_validate,
>  };
>  

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
