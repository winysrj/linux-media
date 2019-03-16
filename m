Return-Path: <SRS0=HTTW=RT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD35C4360F
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 17:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18881218FE
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 17:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfCPRv3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Mar 2019 13:51:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:10483 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbfCPRv3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Mar 2019 13:51:29 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Mar 2019 10:51:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,486,1544515200"; 
   d="scan'208";a="142619686"
Received: from gpleierx-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.43.205])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2019 10:51:26 -0700
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id E8BE421F57; Sat, 16 Mar 2019 19:51:21 +0200 (EET)
Date:   Sat, 16 Mar 2019 19:51:21 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, dave.stevenson@raspberrypi.org
Subject: Re: [RFC 1/5] v4l: subdev: Add MIPI CSI-2 PHY to frame desc
Message-ID: <20190316175121.wdek74c7tfpmrhde@kekkonen.localdomain>
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
 <20190316154801.20460-2-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190316154801.20460-2-jacopo+renesas@jmondi.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On Sat, Mar 16, 2019 at 04:47:57PM +0100, Jacopo Mondi wrote:
> Add PHY-specific parameters to MIPI CSI-2 frame descriptor.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  include/media/v4l2-subdev.h | 42 +++++++++++++++++++++++++++++++------
>  1 file changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 6311f670de3c..eca9633c83bf 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -317,11 +317,33 @@ struct v4l2_subdev_audio_ops {
>  	int (*s_stream)(struct v4l2_subdev *sd, int enable);
>  };
>  
> +#define V4L2_FRAME_DESC_ENTRY_DPHY_DATA_LANES	4
> +
> +/**
> + * struct v4l2_mbus_frame_desc_entry_csi2_dphy - MIPI D-PHY bus configuration
> + *
> + * @clock_lane:		physical lane index of the clock lane
> + * @data_lanes:		an array of physical data lane indexes
> + * @num_data_lanes:	number of data lanes
> + */
> +struct v4l2_mbus_frame_desc_entry_csi2_dphy {
> +	u8 clock_lane;
> +	u8 data_lanes[V4L2_FRAME_DESC_ENTRY_DPHY_DATA_LANES];
> +	u8 num_data_lanes;

Do you need more than the number of the data lanes? I'd expect few devices
to be able to do more than that. The PHY type comes already from the
firmware but I guess it's good to do the separation here as well.

Could you use V4L2_FWNODE_CSI2_MAX_DATA_LANES? Or we could rename it. But I
think it'd be good to stick to a single definition.

> +};
> +
> +/**
> + * struct v4l2_mbus_frame_desc_entry_csi2_cphy - MIPI C-PHY bus configuration
> + */
> +struct v4l2_mbus_frame_desc_entry_csi2_cphy {
> +	/* TODO */
> +};
> +
>  /**
>   * struct v4l2_mbus_frame_desc_entry_csi2
>   *
> - * @channel: CSI-2 virtual channel
> - * @data_type: CSI-2 data type ID
> + * @channel:	CSI-2 virtual channel
> + * @data_type:	CSI-2 data type ID
>   */
>  struct v4l2_mbus_frame_desc_entry_csi2 {
>  	u8 channel;
> @@ -371,18 +393,26 @@ enum v4l2_mbus_frame_desc_type {
>  	V4L2_MBUS_FRAME_DESC_TYPE_PLATFORM,
>  	V4L2_MBUS_FRAME_DESC_TYPE_PARALLEL,
>  	V4L2_MBUS_FRAME_DESC_TYPE_CCP2,
> -	V4L2_MBUS_FRAME_DESC_TYPE_CSI2,
> +	V4L2_MBUS_FRAME_DESC_TYPE_CSI2_DPHY,
> +	V4L2_MBUS_FRAME_DESC_TYPE_CSI2_CPHY,
>  };
>  
>  /**
>   * struct v4l2_mbus_frame_desc - media bus data frame description
> - * @type: type of the bus (enum v4l2_mbus_frame_desc_type)
> - * @entry: frame descriptors array
> - * @num_entries: number of entries in @entry array
> + * @type:		type of the bus (enum v4l2_mbus_frame_desc_type)
> + * @entry:		frame descriptors array
> + * @phy:		PHY specific parameters
> + * @phy.dphy:		MIPI D-PHY specific bus configurations
> + * @phy.cphy:		MIPI C-PHY specific bus configurations
> + * @num_entries:	number of entries in @entry array
>   */
>  struct v4l2_mbus_frame_desc {
>  	enum v4l2_mbus_frame_desc_type type;
>  	struct v4l2_mbus_frame_desc_entry entry[V4L2_FRAME_DESC_ENTRY_MAX];
> +	union {
> +		struct v4l2_mbus_frame_desc_entry_csi2_dphy csi2_dphy;
> +		struct v4l2_mbus_frame_desc_entry_csi2_cphy csi2_cphy;
> +	} phy;
>  	unsigned short num_entries;
>  };
>  

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
