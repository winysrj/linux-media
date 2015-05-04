Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:38721 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbbEDOJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 10:09:55 -0400
Message-ID: <55477DB2.2000601@cisco.com>
Date: Mon, 04 May 2015 16:09:54 +0200
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [RFC 05/12] [media] tc358743: fix lane number calculation to
 include blanking
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de> <1427713856-10240-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-6-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/30/2015 01:10 PM, Philipp Zabel wrote:
> Instead of only using the visible width and height, also add the
> horizontal and vertical blanking to calculate the bit rate.

I am not a CSI expert and when I look at the spreadsheet from Toshiba I 
understand that the calculation of the CSI parameters is quite complex. 
I think you are right that there should be added some kind of blanking 
to the active video, but adding all the blanking from the HDMI format 
gives a too high value. It seems like the calculation will fail if "CSI 
clock enable during LP" is set to "Disable", but that is not supported 
by the driver at the moment.

I have tested all the resolutions between 640x480p60 and 1920x1080p60 
that my video generator will give me, and it works perfect on our 
product. Do you have to change this for your product?

> Signed-off-by: Philipp Zabel<p.zabel@pengutronix.de>
> ---
>   drivers/media/i2c/tc358743.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index dd2ea16..74e83c5 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -713,9 +713,11 @@ static unsigned tc358743_num_csi_lanes_needed(struct v4l2_subdev *sd)
>   {
>   	struct tc358743_state *state = to_state(sd);
>   	struct v4l2_bt_timings *bt = &state->timings.bt;
> +	u32 htotal = bt->width + bt->hfrontporch + bt->hsync + bt->hbackporch;
> +	u32 vtotal = bt->height + bt->vfrontporch + bt->vsync + bt->vbackporch;

By the way, V4L2_DV_BT_FRAME_WIDTH(bt)  and V4L2_DV_BT_FRAME_HEIGHT(bt) 
can be used to calculate total frame width and height.

Regards,

Mats Randgaard


>   	u32 bits_pr_pixel =
>   		(state->mbus_fmt_code == MEDIA_BUS_FMT_UYVY8_1X16) ?  16 : 24;
> -	u32 bps = bt->width * bt->height * fps(bt) * bits_pr_pixel;
> +	u32 bps = htotal * vtotal * fps(bt) * bits_pr_pixel;
>   
>   	return DIV_ROUND_UP(bps, state->pdata.bps_pr_lane);
>   }

