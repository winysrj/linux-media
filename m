Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34325 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbeFBQbB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2018 12:31:01 -0400
Received: by mail-qt0-f194.google.com with SMTP id d3-v6so1465661qto.1
        for <linux-media@vger.kernel.org>; Sat, 02 Jun 2018 09:31:01 -0700 (PDT)
Subject: Re: [PATCH v2 01/10] media: imx-csi: Pass sink pad field to
 ipu_csi_init_interface
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
 <1527813049-3231-2-git-send-email-steve_longerbeam@mentor.com>
 <1527859350.5913.4.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <bbae0a24-7ab6-1361-f15c-068f32482f1f@gmail.com>
Date: Sat, 2 Jun 2018 09:30:57 -0700
MIME-Version: 1.0
In-Reply-To: <1527859350.5913.4.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/01/2018 06:22 AM, Philipp Zabel wrote:
> On Thu, 2018-05-31 at 17:30 -0700, Steve Longerbeam wrote:
>> The output pad's field type was being passed to ipu_csi_init_interface(),
>> in order to deal with field type 'alternate' at the sink pad, which
>> is not understood by ipu_csi_init_interface().
>>
>> Remove that code and pass the sink pad field to ipu_csi_init_interface().
>> The latter function will have to explicity deal with field type 'alternate'
>> when setting up the CSI interface for BT.656 busses.
> I fear this won't be enough. If we want to capture
> sink:ALTERNATE/SEQ_TB/SEQ_BT -> src:SEQ_TB we have to configure the CSI
> differently than if we want to capture
> ALTERNATE/SEQ_TB/SEQ_BT -> src:SEQ_BT. (And differently for NTSC and
> PAL). For NTSC sink:ALTERNATE should behave like sink:SEQ_BT, and for
> PAL sink:ALTERNATE should behave like sink:SEQ_TB.

I think we should return to enforcing field order to userspace that
matches field order from the source, which is what I had implemented
previously. I agree with you that we should put off allowing inverting
field order.

>
> Interweaving SEQ_TB to INTERLACED_TB should work right now, but to
> interweave SEQ_BT to INTERLACED_BT, we need to add one line offset to
> the frame start and use a negative interlaced scanline offset.

Is that because ipu_csi_init_interface() is inverting the F-bit for
NTSC? I think we should remove that code, I will comment on
that in another thread.

Steve


>
>
>
>> Reported-by: Krzysztof Hałasa <khalasa@piap.pl>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   drivers/staging/media/imx/imx-media-csi.c | 13 ++-----------
>>   1 file changed, 2 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index 95d7805..9bc555c 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -629,12 +629,10 @@ static void csi_idmac_stop(struct csi_priv *priv)
>>   /* Update the CSI whole sensor and active windows */
>>   static int csi_setup(struct csi_priv *priv)
>>   {
>> -	struct v4l2_mbus_framefmt *infmt, *outfmt;
>> +	struct v4l2_mbus_framefmt *infmt;
>>   	struct v4l2_mbus_config mbus_cfg;
>> -	struct v4l2_mbus_framefmt if_fmt;
>>   
>>   	infmt = &priv->format_mbus[CSI_SINK_PAD];
>> -	outfmt = &priv->format_mbus[priv->active_output_pad];
>>   
>>   	/* compose mbus_config from the upstream endpoint */
>>   	mbus_cfg.type = priv->upstream_ep.bus_type;
>> @@ -642,20 +640,13 @@ static int csi_setup(struct csi_priv *priv)
>>   		priv->upstream_ep.bus.mipi_csi2.flags :
>>   		priv->upstream_ep.bus.parallel.flags;
>>   
>> -	/*
>> -	 * we need to pass input frame to CSI interface, but
>> -	 * with translated field type from output format
>> -	 */
>> -	if_fmt = *infmt;
>> -	if_fmt.field = outfmt->field;
>> -
>>   	ipu_csi_set_window(priv->csi, &priv->crop);
>>   
>>   	ipu_csi_set_downsize(priv->csi,
>>   			     priv->crop.width == 2 * priv->compose.width,
>>   			     priv->crop.height == 2 * priv->compose.height);
>>   
>> -	ipu_csi_init_interface(priv->csi, &mbus_cfg, &if_fmt);
>> +	ipu_csi_init_interface(priv->csi, &mbus_cfg, infmt);
>>   
>>   	ipu_csi_set_dest(priv->csi, priv->dest);
>>   
