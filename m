Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37753 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbeJIIWR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 04:22:17 -0400
Subject: Re: [PATCH v4 10/11] media: imx: Allow interweave with top/bottom
 lines swapped
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
 <20181004185401.15751-11-slongerbeam@gmail.com>
 <1538736221.3545.17.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <6c8404fa-88b4-9e07-34d4-bc6652736644@gmail.com>
Date: Mon, 8 Oct 2018 18:07:46 -0700
MIME-Version: 1.0
In-Reply-To: <1538736221.3545.17.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,


On 10/05/2018 03:43 AM, Philipp Zabel wrote:
> Hi Steve,
>
> On Thu, 2018-10-04 at 11:54 -0700, Steve Longerbeam wrote:
>> Allow sequential->interlaced interweaving but with top/bottom
>> lines swapped to the output buffer.
>>
>> This can be accomplished by adding one line length to IDMAC output
>> channel address, with a negative line length for the interlace offset.
>>
>> This is to allow the seq-bt -> interlaced-bt transformation, where
>> bottom lines are still dominant (older in time) but with top lines
>> first in the interweaved output buffer.
>>
>> With this support, the CSI can now allow seq-bt at its source pads,
>> e.g. the following transformations are allowed in CSI from sink to
>> source:
>>
>> seq-tb -> seq-bt
>> seq-bt -> seq-bt
>> alternate -> seq-bt
>>
>> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> ---
>>   drivers/staging/media/imx/imx-ic-prpencvf.c | 17 +++++++-
>>   drivers/staging/media/imx/imx-media-csi.c   | 46 +++++++++++++++++----
>>   2 files changed, 53 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
>> index cf76b0432371..1499b0c62d74 100644
>> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
>> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
>> @@ -106,6 +106,8 @@ struct prp_priv {
>>   	u32 frame_sequence; /* frame sequence counter */
>>   	bool last_eof;  /* waiting for last EOF at stream off */
>>   	bool nfb4eof;    /* NFB4EOF encountered during streaming */
>> +	u32 interweave_offset; /* interweave line offset to swap
>> +				  top/bottom lines */
> We have to store this instead of using vdev->fmt.fmt.bytesperline
> because this potentially is the pre-rotation stride instead?

interweave_offset was used by prp_vb2_buf_done() below, but in fact
that function is passed the non-rotation IDMAC channel (priv->out_ch)
_only_ if rotation is not enabled, so it is actually safe to use
vdev->fmt.fmt.bytesperline for the interweave offset in
prp_vb2_buf_done().

So I've gotten rid of interweave_offset in both imx-ic-prpencvf.c and
imx-media-csi.c, and replaced with a boolean interweave_swap as you
suggested. I agree it is much cleaner.
   

>>
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index 679295da5dde..592f7d6edec1 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -114,6 +114,8 @@ struct csi_priv {
>>   	u32 frame_sequence; /* frame sequence counter */
>>   	bool last_eof;   /* waiting for last EOF at stream off */
>>   	bool nfb4eof;    /* NFB4EOF encountered during streaming */
>> +	u32 interweave_offset; /* interweave line offset to swap
>> +				  top/bottom lines */
> This doesn't seem necessary. Since there is no rotation here, the offset
> is just vdev->fmt.fmt.pix.bytesperline if interweave_swap is enabled.
> Maybe turn this into a bool interweave_swap?

Agreed.

>
>>   	struct completion last_eof_comp;
>>   };
>>   
>> @@ -286,7 +288,8 @@ static void csi_vb2_buf_done(struct csi_priv *priv)
>>   	if (ipu_idmac_buffer_is_ready(priv->idmac_ch, priv->ipu_buf_num))
>>   		ipu_idmac_clear_buffer(priv->idmac_ch, priv->ipu_buf_num);
>>   
>> -	ipu_cpmem_set_buffer(priv->idmac_ch, priv->ipu_buf_num, phys);
>> +	ipu_cpmem_set_buffer(priv->idmac_ch, priv->ipu_buf_num,
>> +			     phys + priv->interweave_offset);
>>   }
>>   
>>   static irqreturn_t csi_idmac_eof_interrupt(int irq, void *dev_id)
>> @@ -396,10 +399,10 @@ static void csi_idmac_unsetup_vb2_buf(struct csi_priv *priv,
>>   static int csi_idmac_setup_channel(struct csi_priv *priv)
>>   {
>>   	struct imx_media_video_dev *vdev = priv->vdev;
>> +	bool passthrough, interweave, interweave_swap;
>>   	const struct imx_media_pixfmt *incc;
>>   	struct v4l2_mbus_framefmt *infmt;
>>   	struct v4l2_mbus_framefmt *outfmt;
>> -	bool passthrough, interweave;
>>   	struct ipu_image image;
>>   	u32 passthrough_bits;
>>   	u32 passthrough_cycles;
>> @@ -433,6 +436,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>>   	 */
>>   	interweave = V4L2_FIELD_IS_INTERLACED(image.pix.field) &&
>>   		V4L2_FIELD_IS_SEQUENTIAL(outfmt->field);
>> +	interweave_swap = interweave &&
>> +		image.pix.field == V4L2_FIELD_INTERLACED_BT;
> Although this could just as well be recalculated in csi_vb2_buf_done.

In the future yes, when we add support for alternate mode (I assume
that's what you are getting at?).


> Apart from that,
>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

Thanks.

Steve
