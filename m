Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34091 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753655AbeE1H7e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 03:59:34 -0400
Received: by mail-wr0-f193.google.com with SMTP id j1-v6so18737514wrm.1
        for <linux-media@vger.kernel.org>; Mon, 28 May 2018 00:59:33 -0700 (PDT)
Subject: Re: [PATCH 4/6] media: imx-csi: Enable interlaced scan for field type
 alternate
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
 <1527292416-26187-5-git-send-email-steve_longerbeam@mentor.com>
 <1527490835.6846.1.camel@pengutronix.de>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <b8a58843-35bd-1f74-2131-4987dcb4b42c@gmail.com>
Date: Mon, 28 May 2018 08:59:30 +0100
MIME-Version: 1.0
In-Reply-To: <1527490835.6846.1.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/05/18 08:00, Philipp Zabel wrote:
> On Fri, 2018-05-25 at 16:53 -0700, Steve Longerbeam wrote:
>> Interlaced scan, a.k.a. interweave, should be enabled at the CSI IDMAC
>> output pad if the input field type is 'alternate' (in addition to field
>> types 'seq-tb' and 'seq-bt').
>>
>> Which brings up whether V4L2_FIELD_HAS_BOTH() macro should be used
>> to determine enabling interlaced/interweave scan. That macro
>> includes the 'interlaced' field types, and in those cases the data
>> is already interweaved with top/bottom field lines. A heads-up for
>> now that this if statement may need to call V4L2_FIELD_IS_SEQUENTIAL()
>> instead, I have no sensor hardware that sends 'interlaced' data, so can't
>> test.
> 
> I agree, the check here should be IS_SEQUENTIAL || ALTERNATE, and
> interlaced_scan should also be enabled if image.pix.field is
> INTERLACED_TB/BT.
> And for INTERLACED_TB/BT input, the logic should be inverted: then we'd
> have to enable interlaced_scan whenever image.pix.field is SEQ_BT/TB.

Hi Philipp,

If your intent here is to de-interweave the two fields back to two 
sequential fields, I don't believe the IDMAC operation would achieve 
that. It's basically line stride doubling and a line offset for the 
lines in the 2nd half of the incoming frame, right?

Regards,
Ian
> 
> regards
> Philipp
> 
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   drivers/staging/media/imx/imx-media-csi.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index 9bc555c..eef3483 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -477,7 +477,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>>   	ipu_smfc_set_burstsize(priv->smfc, burst_size);
>>   
>>   	if (image.pix.field == V4L2_FIELD_NONE &&
>> -	    V4L2_FIELD_HAS_BOTH(infmt->field))
>> +	    (V4L2_FIELD_HAS_BOTH(infmt->field) ||
>> +	     infmt->field == V4L2_FIELD_ALTERNATE))
>>   		ipu_cpmem_interlaced_scan(priv->idmac_ch,
>>   					  image.pix.bytesperline);
>>   
