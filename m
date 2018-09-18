Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:58602 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbeISEYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 00:24:54 -0400
Subject: Re: [PATCH] media: staging/imx: Handle CSI->VDIC->PRPVF pipeline
To: Hans Verkuil <hverkuil@xs4all.nl>, Marek Vasut <marex@denx.de>,
        <linux-media@vger.kernel.org>
CC: Philipp Zabel <p.zabel@pengutronix.de>
References: <20180407130513.24936-1-marex@denx.de>
 <bb97347f-5b38-47bd-7064-95f42719ce67@xs4all.nl>
 <8e855c2f-01c1-0d51-1945-70772ab08952@xs4all.nl>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <1d9feff1-c220-88aa-c1b1-31c7c93e784a@mentor.com>
Date: Tue, 18 Sep 2018 15:49:28 -0700
MIME-Version: 1.0
In-Reply-To: <8e855c2f-01c1-0d51-1945-70772ab08952@xs4all.nl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/17/2018 03:25 AM, Hans Verkuil wrote:
> On 05/07/2018 11:55 AM, Hans Verkuil wrote:
>> On 07/04/18 15:05, Marek Vasut wrote:
>>> In case the PRPVF is not connected directly to CSI, the PRPVF subdev
>>> driver won't find the CSI subdev and will not configure the CSI input
>>> mux. This is not noticable on the IPU1-CSI0 interface with parallel
>>> camera, since the mux is set "correctly" by default and the parallel
>>> camera will work just fine. This is however noticable on IPU2-CSI1,
>>> where the mux is not set to the correct position by default and the
>>> pipeline will fail.
>>>
>>> Add similar code to what is in PRPVF to VDIC driver, so that the VDIC
>>> can locate the CSI subdev and configure the mux correctly if the CSI
>>> is connected to the VDIC. Make the PRPVF driver configure the CSI mux
>>> only in case it's connected directly to CSI and not in case it is
>>> connected to VDIC.
>>>
>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>> Cc: Philipp Zabel <p.zabel@pengutronix.de>
>>> Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
>> Same here, I cannot merge with out Acks since I don't know the details
>> of the imx hardware.
> I'm marking this patch as Obsoleted since there has been no activity for a long
> time.

Hi Hans, yes that's fine. IIRC this issue has been fixed a different way.

Steve

>
>
>>> ---
>>>   drivers/staging/media/imx/imx-ic-prp.c     |  6 ++----
>>>   drivers/staging/media/imx/imx-media-vdic.c | 24 ++++++++++++++++++++++++
>>>   2 files changed, 26 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
>>> index 98923fc844ce..84fa66dae21a 100644
>>> --- a/drivers/staging/media/imx/imx-ic-prp.c
>>> +++ b/drivers/staging/media/imx/imx-ic-prp.c
>>> @@ -72,14 +72,12 @@ static inline struct prp_priv *sd_to_priv(struct v4l2_subdev *sd)
>>>   static int prp_start(struct prp_priv *priv)
>>>   {
>>>   	struct imx_ic_priv *ic_priv = priv->ic_priv;
>>> -	bool src_is_vdic;
>>>   
>>>   	priv->ipu = priv->md->ipu[ic_priv->ipu_id];
>>>   
>>>   	/* set IC to receive from CSI or VDI depending on source */
>>> -	src_is_vdic = !!(priv->src_sd->grp_id & IMX_MEDIA_GRP_ID_VDIC);
>>> -
>>> -	ipu_set_ic_src_mux(priv->ipu, priv->csi_id, src_is_vdic);
>>> +	if (!(priv->src_sd->grp_id & IMX_MEDIA_GRP_ID_VDIC))
>>> +		ipu_set_ic_src_mux(priv->ipu, priv->csi_id, false);
>>>   
>>>   	return 0;
>>>   }
>>> diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
>>> index b538bbebedc5..e660911e7024 100644
>>> --- a/drivers/staging/media/imx/imx-media-vdic.c
>>> +++ b/drivers/staging/media/imx/imx-media-vdic.c
>>> @@ -117,6 +117,9 @@ struct vdic_priv {
>>>   
>>>   	bool csi_direct;  /* using direct CSI->VDIC->IC pipeline */
>>>   
>>> +	/* the CSI id at link validate */
>>> +	int csi_id;
>>> +
>>>   	/* motion select control */
>>>   	struct v4l2_ctrl_handler ctrl_hdlr;
>>>   	enum ipu_motion_sel motion;
>>> @@ -388,6 +391,9 @@ static int vdic_start(struct vdic_priv *priv)
>>>   	if (ret)
>>>   		return ret;
>>>   
>>> +	/* set IC to receive from CSI or VDI depending on source */
>>> +	ipu_set_ic_src_mux(priv->ipu, priv->csi_id, true);
>>> +
>>>   	/*
>>>   	 * init the VDIC.
>>>   	 *
>>> @@ -778,6 +784,7 @@ static int vdic_link_validate(struct v4l2_subdev *sd,
>>>   			      struct v4l2_subdev_format *sink_fmt)
>>>   {
>>>   	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
>>> +	struct imx_media_subdev *csi;
>>>   	int ret;
>>>   
>>>   	ret = v4l2_subdev_link_validate_default(sd, link,
>>> @@ -785,6 +792,23 @@ static int vdic_link_validate(struct v4l2_subdev *sd,
>>>   	if (ret)
>>>   		return ret;
>>>   
>>> +	csi = imx_media_find_upstream_subdev(priv->md, priv->src,
>>> +					     IMX_MEDIA_GRP_ID_CSI);
>>> +	if (!IS_ERR(csi)) {
>>> +		switch (csi->sd->grp_id) {
>>> +		case IMX_MEDIA_GRP_ID_CSI0:
>>> +			priv->csi_id = 0;
>>> +			break;
>>> +		case IMX_MEDIA_GRP_ID_CSI1:
>>> +			priv->csi_id = 1;
>>> +			break;
>>> +		default:
>>> +			ret = -EINVAL;
>>> +		}
>>> +	} else {
>>> +		priv->csi_id = 0;
>>> +	}
>>> +
>>>   	mutex_lock(&priv->lock);
>>>   
>>>   	if (priv->csi_direct && priv->motion != HIGH_MOTION) {
>>>
>>
