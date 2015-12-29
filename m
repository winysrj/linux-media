Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59144 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbbL2Jik (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 04:38:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [media] mt9v032: Add V4L2 controls for AEC and AGC
Date: Tue, 29 Dec 2015 11:38:39 +0200
Message-ID: <5194938.P3WvP9gjaZ@avalon>
In-Reply-To: <2570493.HaAAxn7ErG@adelgunde>
References: <1450104113-6392-1-git-send-email-mpa@pengutronix.de> <290053152.GcUooHzFZY@avalon> <2570493.HaAAxn7ErG@adelgunde>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

On Wednesday 16 December 2015 11:14:28 Markus Pargmann wrote:
> On Wednesday 16 December 2015 09:47:58 Laurent Pinchart wrote:
> > On Monday 14 December 2015 15:41:53 Markus Pargmann wrote:
> >> This patch adds V4L2 controls for Auto Exposure Control and Auto Gain
> >> Control settings. These settings include low pass filter, update
> >> frequency of these settings and the update interval for those units.
> >> 
> >> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> > 
> > Please see below for a few comments. If you agree about them there's no
> > need to resubmit, I'll fix the patch when applying.
> 
> Most of them are fine, I commented on the open ones.
> 
> >> ---
> >> 
> >>  drivers/media/i2c/mt9v032.c | 153 ++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 152 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> >> index cc16acf001de..6cbc3b87eda9 100644
> >> --- a/drivers/media/i2c/mt9v032.c
> >> +++ b/drivers/media/i2c/mt9v032.c

[snip]

> >> +static const struct v4l2_ctrl_config mt9v032_aec_max_shutter_width = {
> >> +	.ops		= &mt9v032_ctrl_ops,
> >> +	.id		= V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
> >> +	.type		= V4L2_CTRL_TYPE_INTEGER,
> >> +	.name		= "aec_max_shutter_width",
> >> +	.min		= 1,
> >> +	.max		= MT9V032_TOTAL_SHUTTER_WIDTH_MAX,
> > 
> > According the the MT9V032 datasheet I have, the maximum value is 2047
> > while MT9V032_TOTAL_SHUTTER_WIDTH_MAX is defined as 32767. Do you have any
> > information that would hint for an error in the datasheet ?
> 
> The register is defined as having 15 bits. I simply assumed that the already
> defined TOTAL_SHUTTER_WIDTH_MAX would apply for this register as well. At
> least it should end up controlling the same property of the chip. I didn't
> test this on mt9v032 but on mt9v024.

According to the MT9V032 datasheet 
(http://www.onsemi.com/pub/Collateral/MT9V032-D.PDF) the maximum shutter width 
in AEC mode is limited to 2047. That is documented both in the Maximum Total 
Shutter Width register legal values and in the "Automatic Gain Control and 
Automatic Exposure Control" section:

"The exposure is measured in row-time by reading R0xBB. The exposure range is
1 to 2047."

I assume that the the AEC unit limits the shutter width to 2047 lines and that 
it's thus pointless to set the maximum total shutter width to a higher value. 
Whether doing so could have any adverse effect I don't know, but better be 
same than sorry. If you agree we should limit the value to 2047 I can fix 
this.

> >> +	.step		= 1,
> >> +	.def		= MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
> >> +	.flags		= 0,
> >> +};
> >> +
> >> +static const struct v4l2_ctrl_config mt9v034_aec_max_shutter_width = {
> >> +	.ops		= &mt9v032_ctrl_ops,
> >> +	.id		= V4L2_CID_AEC_MAX_SHUTTER_WIDTH,
> >> +	.type		= V4L2_CTRL_TYPE_INTEGER,
> >> +	.name		= "aec_max_shutter_width",
> >> +	.min		= 1,
> >> +	.max		= MT9V034_TOTAL_SHUTTER_WIDTH_MAX,
> >> +	.step		= 1,
> >> +	.def		= MT9V032_TOTAL_SHUTTER_WIDTH_DEF,
> >> +	.flags		= 0,
> >> +};
> > 
> > [snip]

-- 
Regards,

Laurent Pinchart

