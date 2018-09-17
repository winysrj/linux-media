Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:33307 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbeIQPyI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 11:54:08 -0400
Subject: Re: [PATCH] media: imx: Skip every second frame in VDIC DIRECT mode
To: Marek Vasut <marex@denx.de>, linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <20180407130440.24886-1-marex@denx.de>
 <e769f2b9-e46b-8bf6-d5cd-462f475b9c97@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <529202d4-c1c9-31d6-6e4a-49b4602b1eb6@xs4all.nl>
Date: Mon, 17 Sep 2018 12:27:18 +0200
MIME-Version: 1.0
In-Reply-To: <e769f2b9-e46b-8bf6-d5cd-462f475b9c97@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/07/2018 11:54 AM, Hans Verkuil wrote:
> On 07/04/18 15:04, Marek Vasut wrote:
>> In VDIC direct mode, the VDIC applies combing filter during and
>> doubles the framerate, that is, after the first two half-frames
>> are received and the first frame is emitted by the VDIC, every
>> subsequent half-frame is patched into the result and a full frame
>> is produced. The half-frame order in the full frames is as follows
>> 12 32 34 54 etc.
>>
>> Drop every second frame to trim the framerate back to the original
>> one of the signal and skip the odd patched frames.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
>> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Steve, Philipp,
> 
> I saw there was a discussion about this patch, but no clear answer whether
> or not this patch is OK. If it is, then please Ack this patch.

Marking this patch as Obsoleted since I have no seen any activity for a long time.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
>> ---
>>  drivers/staging/media/imx/imx-media-vdic.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
>> index 482250d47e7c..b538bbebedc5 100644
>> --- a/drivers/staging/media/imx/imx-media-vdic.c
>> +++ b/drivers/staging/media/imx/imx-media-vdic.c
>> @@ -289,6 +289,7 @@ static int vdic_setup_direct(struct vdic_priv *priv)
>>  	/* set VDIC to receive from CSI for direct path */
>>  	ipu_fsu_link(priv->ipu, IPUV3_CHANNEL_CSI_DIRECT,
>>  		     IPUV3_CHANNEL_CSI_VDI_PREV);
>> +	ipu_set_vdi_skip(priv->ipu, 0x2);
>>  
>>  	return 0;
>>  }
>> @@ -313,6 +314,8 @@ static int vdic_setup_indirect(struct vdic_priv *priv)
>>  	const struct imx_media_pixfmt *incc;
>>  	int in_size, ret;
>>  
>> +	ipu_set_vdi_skip(priv->ipu, 0x0);
>> +
>>  	infmt = &priv->format_mbus[VDIC_SINK_PAD_IDMAC];
>>  	incc = priv->cc[VDIC_SINK_PAD_IDMAC];
>>  
>>
> 
> 
