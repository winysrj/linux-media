Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:49493 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754397AbbHJJDx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 05:03:53 -0400
Message-ID: <55C868DE.3060705@xs4all.nl>
Date: Mon, 10 Aug 2015 11:03:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 08/13] hackrf: add control for RF amplifier
References: <1438308650-2702-1-git-send-email-crope@iki.fi> <1438308650-2702-9-git-send-email-crope@iki.fi>
In-Reply-To: <1438308650-2702-9-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2015 04:10 AM, Antti Palosaari wrote:
> There is Avago MGA-81563 amplifier just right after antenna connector.
> It could be turned on/off and its gain is around 12dB.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/usb/hackrf/hackrf.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
> index fd1fa41..136de9a 100644
> --- a/drivers/media/usb/hackrf/hackrf.c
> +++ b/drivers/media/usb/hackrf/hackrf.c
> @@ -31,6 +31,7 @@ enum {
>  	CMD_BOARD_ID_READ                  = 0x0e,
>  	CMD_VERSION_STRING_READ            = 0x0f,
>  	CMD_SET_FREQ                       = 0x10,
> +	CMD_AMP_ENABLE                     = 0x11,
>  	CMD_SET_LNA_GAIN                   = 0x13,
>  	CMD_SET_VGA_GAIN                   = 0x14,
>  };
> @@ -133,6 +134,7 @@ struct hackrf_dev {
>  	struct v4l2_ctrl_handler hdl;
>  	struct v4l2_ctrl *bandwidth_auto;
>  	struct v4l2_ctrl *bandwidth;
> +	struct v4l2_ctrl *rf_gain;
>  	struct v4l2_ctrl *lna_gain;
>  	struct v4l2_ctrl *if_gain;
>  
> @@ -164,6 +166,7 @@ static int hackrf_ctrl_msg(struct hackrf_dev *dev, u8 request, u16 value,
>  	switch (request) {
>  	case CMD_SET_TRANSCEIVER_MODE:
>  	case CMD_SET_FREQ:
> +	case CMD_AMP_ENABLE:
>  	case CMD_SAMPLE_RATE_SET:
>  	case CMD_BASEBAND_FILTER_BANDWIDTH_SET:
>  		pipe = usb_sndctrlpipe(dev->udev, 0);
> @@ -949,6 +952,22 @@ static int hackrf_set_bandwidth(struct hackrf_dev *dev)
>  	return ret;
>  }
>  
> +static int hackrf_set_rf_gain(struct hackrf_dev *dev)
> +{
> +	int ret;
> +	u8 u8tmp;
> +
> +	dev_dbg(dev->dev, "rf val=%d->%d\n",
> +		dev->rf_gain->cur.val, dev->rf_gain->val);
> +
> +	u8tmp = (dev->rf_gain->val) ? 1 : 0;
> +	ret = hackrf_ctrl_msg(dev, CMD_AMP_ENABLE, u8tmp, 0, NULL, 0);
> +	if (ret)
> +		dev_dbg(dev->dev, "failed=%d\n", ret);
> +
> +	return ret;
> +}
> +
>  static int hackrf_set_lna_gain(struct hackrf_dev *dev)
>  {
>  	int ret;
> @@ -992,6 +1011,9 @@ static int hackrf_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_RF_TUNER_BANDWIDTH:
>  		ret = hackrf_set_bandwidth(dev);
>  		break;
> +	case  V4L2_CID_RF_TUNER_RF_GAIN:
> +		ret = hackrf_set_rf_gain(dev);
> +		break;
>  	case  V4L2_CID_RF_TUNER_LNA_GAIN:
>  		ret = hackrf_set_lna_gain(dev);
>  		break;
> @@ -1077,13 +1099,15 @@ static int hackrf_probe(struct usb_interface *intf,
>  	}
>  
>  	/* Register controls */
> -	v4l2_ctrl_handler_init(&dev->hdl, 4);
> +	v4l2_ctrl_handler_init(&dev->hdl, 5);
>  	dev->bandwidth_auto = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
>  			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
>  	dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
>  			V4L2_CID_RF_TUNER_BANDWIDTH,
>  			1750000, 28000000, 50000, 1750000);
>  	v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
> +	dev->rf_gain = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
> +			V4L2_CID_RF_TUNER_RF_GAIN, 0, 12, 12, 0);
>  	dev->lna_gain = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
>  			V4L2_CID_RF_TUNER_LNA_GAIN, 0, 40, 8, 0);
>  	dev->if_gain = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
> 

