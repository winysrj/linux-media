Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:57134 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757306AbdEWQst (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 12:48:49 -0400
Subject: Re: [RFC 2/2] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: linux-media@vger.kernel.org,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org
References: <cover.1492767176.git.joabreu@synopsys.com>
 <a0c0a46aa86abf87da4f6b1742114fbfc40a3963.1492767176.git.joabreu@synopsys.com>
 <d6bfa439-a0e5-d08f-a94f-5b75e17bf9db@xs4all.nl>
 <05c536fe-4a0b-b78d-7f88-c3c51383863e@synopsys.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e21711ef-70e9-1cbd-a759-0e4476dd09d1@xs4all.nl>
Date: Tue, 23 May 2017 18:48:43 +0200
MIME-Version: 1.0
In-Reply-To: <05c536fe-4a0b-b78d-7f88-c3c51383863e@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/23/2017 06:38 PM, Jose Abreu wrote:
> Hi Hans,
> 
> 
> Thanks for the review!
> 
> On 22-05-2017 11:36, Hans Verkuil wrote:
>> On 04/21/2017 11:53 AM, Jose Abreu wrote:

<snip>

>>> +static int dw_hdmi_query_dv_timings(struct v4l2_subdev *sd,
>>> +		struct v4l2_dv_timings *timings)
>>> +{
>>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>> +	struct v4l2_bt_timings *bt = &timings->bt;
>>> +	u32 htot, hofs;
>>> +	u32 vtot;
>>> +	u8 vic;
>>> +
>>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>>> +
>>> +	memset(timings, 0, sizeof(*timings));
>>> +
>>> +	timings->type = V4L2_DV_BT_656_1120;
>>> +	bt->width = hdmi_readl(dw_dev, HDMI_MD_HACT_PX);
>>> +	bt->height = hdmi_readl(dw_dev, HDMI_MD_VAL);
>>> +	bt->interlaced = 0;
>> There is no interlaced support? Most receivers can at least detect it.
> 
> The controller supports interlaced, unfortunately there is no way
> I can test it, so we chose not to add it in the driver.

But isn't there a register that tells you if the source was interlaced?
Almost all HDMI receiver drivers can detect this, even though they don't
actually allow interlaced formats to be used. It is disabled in the
DV timings capabilities.

My problem with this code is that it doesn't tell the caller that the
signal is interlaced. This can lead to problems where it is incorrectly
interpreted as progressive.

> 
>>
>>> +
>>> +	if (hdmi_readl(dw_dev, HDMI_ISTS) & HDMI_ISTS_VS_POL_ADJ)
>>> +		bt->polarities |= V4L2_DV_VSYNC_POS_POL;
>>> +	if (hdmi_readl(dw_dev, HDMI_ISTS) & HDMI_ISTS_HS_POL_ADJ)
>>> +		bt->polarities |= V4L2_DV_HSYNC_POS_POL;
>>> +
>>> +	bt->pixelclock = dw_hdmi_get_pixelclk(dw_dev);
>> Can this be rounded up to a value above 594 MHz? In the timings cap that
>> is the max frequency, but you probably need to allow for a bit of margin there
>> in case you measure e.g. 594050000 Hz.
> 
> Hmm, yeah, probably it can. Actually the timings cap may not be
> correct because we support deep color in 4k, so freq will be >
> 594MHz.

No, since this is the pixel clock, and the number of pixels remains the same,
even when using deep color.

It is increasingly likely that this driver might be the first to support
deep color, so it is very possible that some API changes may have to be made.

I always wanted to add support for this, but I never had the chance.

>>> +static int dw_hdmi_s_register(struct v4l2_subdev *sd,
>>> +		const struct v4l2_dbg_register *reg)
>>> +{
>>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>> +
>>> +	switch (reg->reg >> 15) {
>>> +	case 0: /* Controller core write */
>>> +		hdmi_writel(dw_dev, reg->val & GENMASK(31,0), reg->reg & 0x7fff);
>>> +		return 0;
>>> +	case 1: /* PHY write */
>>> +		if ((reg->reg & ~0xff) != BIT(15))
>>> +			break;
>>> +		dw_hdmi_phy_write(dw_dev, reg->val & 0xffff, reg->reg & 0xff);
>>> +		return 0;
>>> +	default:
>>> +		break;
>>> +	}
>> Be careful here: if you support HDCP, then you typically don't want to allow
>> userspace to touch any HDCP-related registers through this API.
> 
> Yeah, HDCP is supported but still not implemented. Still, the
> only thing the user will be able to change will be bksv because
> keys can not be read, they are write only. I will add a check though.

Let me know if/when you want to add actual HDCP support. I have some old patches
for HDCP that we (Cisco) made a long time ago.

Regards,

	Hans
