Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33353 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757339Ab3GaVFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 17:05:24 -0400
Date: Thu, 1 Aug 2013 00:04:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v4 5/7] v4l: Renesas R-Car VSP1 driver
Message-ID: <20130731210449.GR12281@valkosipuli.retiisi.org.uk>
References: <1375285954-32153-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1375285954-32153-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375285954-32153-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Jul 31, 2013 at 05:52:32PM +0200, Laurent Pinchart wrote:
...
> +static int vsp1_device_init(struct vsp1_device *vsp1)
> +{
> +	unsigned int i;
> +	u32 status;
> +
> +	/* Reset any channel that might be running. */
> +	status = vsp1_read(vsp1, VI6_STATUS);
> +
> +	for (i = 0; i < VPS1_MAX_WPF; ++i) {
> +		unsigned int timeout;
> +
> +		if (!(status & VI6_STATUS_SYS_ACT(i)))
> +			continue;
> +
> +		vsp1_write(vsp1, VI6_SRESET, VI6_SRESET_SRTS(i));
> +		for (timeout = 10; timeout > 0; --timeout) {
> +			status = vsp1_read(vsp1, VI6_STATUS);
> +			if (!(status & VI6_STATUS_SYS_ACT(i)))
> +				break;
> +
> +			usleep_range(1000, 2000);
> +		}
> +
> +		if (timeout) {

As discussed, with s/timeout/!timeout/,

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

> +			dev_err(vsp1->dev, "failed to reset wpf.%u\n", i);
> +			return -ETIMEDOUT;
> +		}
> +	}
> +
> +	vsp1_write(vsp1, VI6_CLK_DCSWT, (8 << VI6_CLK_DCSWT_CSTPW_SHIFT) |
> +		   (8 << VI6_CLK_DCSWT_CSTRW_SHIFT));
> +
> +	for (i = 0; i < VPS1_MAX_RPF; ++i)
> +		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE(i), VI6_DPR_NODE_UNUSED);
> +
> +	for (i = 0; i < VPS1_MAX_UDS; ++i)
> +		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE(i), VI6_DPR_NODE_UNUSED);
> +
> +	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, VI6_DPR_NODE_UNUSED);
> +	vsp1_write(vsp1, VI6_DPR_LUT_ROUTE, VI6_DPR_NODE_UNUSED);
> +	vsp1_write(vsp1, VI6_DPR_CLU_ROUTE, VI6_DPR_NODE_UNUSED);
> +	vsp1_write(vsp1, VI6_DPR_HST_ROUTE, VI6_DPR_NODE_UNUSED);
> +	vsp1_write(vsp1, VI6_DPR_HSI_ROUTE, VI6_DPR_NODE_UNUSED);
> +	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, VI6_DPR_NODE_UNUSED);
> +
> +	vsp1_write(vsp1, VI6_DPR_HGO_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
> +		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
> +	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
> +		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
> +
> +	return 0;
> +}

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
