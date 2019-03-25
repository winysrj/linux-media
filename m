Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E0EC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 11:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11FDE20863
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 11:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbfCYLR5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 07:17:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:63395 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729727AbfCYLR5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 07:17:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Mar 2019 04:17:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="143617112"
Received: from ikahlonx-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.61.250])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Mar 2019 04:17:53 -0700
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 5AF2221D09; Mon, 25 Mar 2019 13:17:47 +0200 (EET)
Date:   Mon, 25 Mar 2019 13:17:47 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mickael GUENE <mickael.guene@st.com>
Cc:     Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Kao <ben.kao@intel.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Jason Chen <jasonx.z.chen@intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Tianshu Qiu <tian.shu.qiu@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>
Subject: Re: [PATCH v1 2/3] media:st-mipid02: MIPID02 CSI-2 to PARALLEL
 bridge driver
Message-ID: <20190325111746.h26isglf4d765mtg@kekkonen.localdomain>
References: <1552373045-134493-1-git-send-email-mickael.guene@st.com>
 <1552373045-134493-3-git-send-email-mickael.guene@st.com>
 <20190316221437.e3ukdpgyn2yq72tu@valkosipuli.retiisi.org.uk>
 <024de1c6-3e40-ac5a-586e-d9878947ff18@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <024de1c6-3e40-ac5a-586e-d9878947ff18@st.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mickael,

On Mon, Mar 18, 2019 at 09:57:44AM +0000, Mickael GUENE wrote:
> Hi Sakari,
> 
> Thanks for your review. Find my comments below.
> 
> On 3/16/19 23:14, Sakari Ailus wrote:
...
> >> +static struct v4l2_subdev *mipid02_find_sensor(struct mipid02_dev *bridge)
> >> +{
> >> +	struct media_device *mdev = bridge->sd.v4l2_dev->mdev;
> >> +	struct media_entity *entity;
> >> +
> >> +	if (!mdev)
> >> +		return NULL;
> >> +
> >> +	media_device_for_each_entity(entity, mdev)
> >> +		if (entity->function == MEDIA_ENT_F_CAM_SENSOR)
> >> +			return media_entity_to_v4l2_subdev(entity);
> > 
> > Hmm. Could you instead use the link state to determine which of the
> > receivers is active? You'll need one more pad, and then you'd had 1:1
> > mapping between ports and pads.
> > 
>  Goal here is not to detect which of the receivers is active but to find
> sensor in case there are others sub-dev in chain (for example a 
> serializer/deserializer as found in cars).

You shouldn't make assumptions on the rest of the pipeline beyond the
device that's directly connected. You might not even have a camera there.

>  For the moment the driver doesn't support second input port usage,
> this is why there is no such second sink pad yet in the driver.

Could you add the second sink pad now, so that the uAPI remains the same
when you add support for it? Nothing is connected to it but I don't think
it's an issue.

...

> >> +
> >> +	sensor = mipid02_find_sensor(bridge);
> >> +	if (!sensor)
> >> +		goto error;
> >> +
> >> +	dev_dbg(&client->dev, "use sensor '%s'", sensor->name);
> >> +	memset(&bridge->r, 0, sizeof(bridge->r));
> >> +	/* build registers content */
> >> +	code = mipid02_get_source_code(bridge, sensor);
> >> +	ret |= mipid02_configure_from_rx(bridge, code, sensor);
> >> +	ret |= mipid02_configure_from_tx(bridge);
> >> +	ret |= mipid02_configure_from_code(bridge, code);
> >> +
> >> +	/* write mipi registers */
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_CLK_LANE_REG1,
> >> +		bridge->r.clk_lane_reg1);
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_CLK_LANE_REG3, CLK_MIPI_CSI);
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_LANE0_REG1,
> >> +		bridge->r.data_lane0_reg1);
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_LANE0_REG2,
> >> +		DATA_MIPI_CSI);
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_LANE1_REG1,
> >> +		bridge->r.data_lane1_reg1);
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_LANE1_REG2,
> >> +		DATA_MIPI_CSI);
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_MODE_REG1,
> >> +		MODE_NO_BYPASS | bridge->r.mode_reg1);
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_MODE_REG2,
> >> +		bridge->r.mode_reg2);
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_ID_RREG,
> >> +		bridge->r.data_id_rreg);
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_DATA_SELECTION_CTRL,
> >> +		SELECTION_MANUAL_DATA | SELECTION_MANUAL_WIDTH);
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_PIX_WIDTH_CTRL,
> >> +		bridge->r.pix_width_ctrl);
> >> +	ret |= mipid02_write_reg(bridge, MIPID02_PIX_WIDTH_CTRL_EMB,
> >> +		bridge->r.pix_width_ctrl_emb);
> > 
> > Be careful with the error codes. ret will be returned by the s_stream
> > callback below.
> > 
>  I didn't understand your remark. Can you elaborate a little bit more ?

If the functions return different error codes, then ret possibly won't be a
valid error code, or at least it's not going to be what it was intended to
do. You'll need to stop when you encounter an error and then return it to
the caller.

...

> >> +static int mipid02_parse_tx_ep(struct mipid02_dev *bridge)
> >> +{
> >> +	struct i2c_client *client = bridge->i2c_client;
> >> +	struct v4l2_fwnode_endpoint ep;
> >> +	struct device_node *ep_node;
> >> +	int ret;
> >> +
> >> +	memset(&ep, 0, sizeof(ep));
> >> +	ep.bus_type = V4L2_MBUS_PARALLEL;
> > 
> > You can set the field in variable declaration, and omit memset. The same in
> > the function above.
> > 
> According to v4l2_fwnode_endpoint_parse() documentation:
>  * This function parses the V4L2 fwnode endpoint specific parameters from the
>  * firmware. The caller is responsible for assigning @vep.bus_type to a valid
>  * media bus type. The caller may also set the default configuration for the
>  * endpoint
> It seems safer to clear ep else it may select unwanted default configuration
> for the endpoint ?

By setting one of the fields in a struct in declaration, the rest will be
zeroed by the compiler. That's from the C standard.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
