Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1964 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934478AbbIVTFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 15:05:19 -0400
Subject: Re: [PATCH 1/3] [media] v4l: tegra: Add NVIDIA Tegra VI driver
To: Thierry Reding <treding@nvidia.com>
References: <1442861755-22743-1-git-send-email-pengw@nvidia.com>
 <1442861755-22743-2-git-send-email-pengw@nvidia.com>
 <20150922114720.GB1417@ulmo.nvidia.com>
CC: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>, <bmurthyv@nvidia.com>
From: Bryan Wu <pengw@nvidia.com>
Message-ID: <5601A66D.9060800@nvidia.com>
Date: Tue, 22 Sep 2015 12:05:17 -0700
MIME-Version: 1.0
In-Reply-To: <20150922114720.GB1417@ulmo.nvidia.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/22/2015 04:47 AM, Thierry Reding wrote:
> On Mon, Sep 21, 2015 at 11:55:53AM -0700, Bryan Wu wrote:
> [...]
>> +static int tegra_csi_s_stream(struct v4l2_subdev *subdev, int enable)
>> +{
>> +	struct tegra_csi_device *csi = to_csi(subdev);
>> +	struct tegra_channel *chan = subdev->host_priv;
>> +	enum tegra_csi_port_num port_num = (chan->port & 1) ? PORT_B : PORT_A;
>> +	struct tegra_csi_port *port = &csi->ports[port_num];
>> +	int ret;
>> +
>> +	if (enable) {
> [...]
>> +	} else {
>> +		u32 val = pp_read(port, TEGRA_CSI_PIXEL_PARSER_STATUS);
>> +		dev_dbg(csi->dev, "TEGRA_CSI_PIXEL_PARSER_STATUS 0x%08x\n", val);
>> +
>> +		val = cil_read(port, TEGRA_CSI_CIL_STATUS);
>> +		dev_dbg(csi->dev, "TEGRA_CSI_CIL_STATUS 0x%08x\n", val);
>> +
>> +		val = cil_read(port, TEGRA_CSI_CILX_STATUS);
>> +		dev_dbg(csi->dev, "TEGRA_CSI_CILX_STATUS 0x%08x\n", val);
>> +	
> I was going to apply this and give it a spin, but then git am complained
> about trailing whitespace above...
>
>> +#ifdef DEBUG
>> +		val = csi_read(csi, TEGRA_CSI_DEBUG_COUNTER_0);
>> +		dev_err(&csi->dev, "TEGRA_CSI_DEBUG_COUNTER_0 0x%08x\n", val);
>> +#endif
>> +
>> +		pp_write(port, TEGRA_CSI_PIXEL_STREAM_PP_COMMAND,
>> +			 (0xF << CSI_PP_START_MARKER_FRAME_MAX_OFFSET) |
>> +			 CSI_PP_DISABLE);
>> +
>> +		clk_disable_unprepare(csi->clk);
>> +	}
>> +	
> and here, ...
>
>> +static int tegra_csi_probe(struct platform_device *pdev)
>> +{
> [...]
>> +	for (i = 0; i < TEGRA_CSI_PORTS_NUM; i++) {
>> +		/* Initialize the default format */
>> +		csi->ports[i].format.code = TEGRA_VF_DEF;
>> +		csi->ports[i].format.field = V4L2_FIELD_NONE;
>> +		csi->ports[i].format.colorspace = V4L2_COLORSPACE_SRGB;
>> +		csi->ports[i].format.width = TEGRA_DEF_WIDTH;
>> +		csi->ports[i].format.height = TEGRA_DEF_HEIGHT;
>> +
>> +		/* Initialize port register bases */
>> +		csi->ports[i].pixel_parser = csi->iomem +
>> +					     (i & 1) * TEGRA_CSI_PORT_OFFSET;
>> +		csi->ports[i].cil = csi->iomem + TEGRA_CSI_CIL_OFFSET +
> here and...
>
>> +				    (i & 1) * TEGRA_CSI_PORT_OFFSET;
>> +		csi->ports[i].tpg = csi->iomem + TEGRA_CSI_TPG_OFFSET +
> here.
>
> Might be worth fixing those up if you'll respin anyway.
>
> Thierry
Thanks for pointing out this, I will rerun the check-patch.pl and fix 
all those coding style errors.

-Bryan

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
