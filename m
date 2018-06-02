Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:44095 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbeFBQcx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2018 12:32:53 -0400
Received: by mail-qt0-f193.google.com with SMTP id d3-v6so35927198qtp.11
        for <linux-media@vger.kernel.org>; Sat, 02 Jun 2018 09:32:53 -0700 (PDT)
Subject: Re: [PATCH v2 06/10] media: imx: Fix field setting logic in try_fmt
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
 <1527813049-3231-7-git-send-email-steve_longerbeam@mentor.com>
 <1527860095.5913.10.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <3acbaa61-3e0c-1573-7495-8407c50768af@gmail.com>
Date: Sat, 2 Jun 2018 09:32:50 -0700
MIME-Version: 1.0
In-Reply-To: <1527860095.5913.10.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/01/2018 06:34 AM, Philipp Zabel wrote:
> On Thu, 2018-05-31 at 17:30 -0700, Steve Longerbeam wrote:
>> The logic for setting field type in try_fmt at CSI and PRPENCVF
>> entities wasn't quite right. The behavior should be:
>>
>> - No restrictions on field type at sink pads (except ANY, which is filled
>>    with current sink pad field by imx_media_fill_default_mbus_fields()).
>>
>> - At IDMAC output pads, if the caller asks for an interlaced output, and
>>    the input is sequential fields, the IDMAC output channel can accommodate
>>    by interweaving. The CSI can also interweave if input is alternate
>>    fields.
>>
>> - If final source pad field type is alternate, translate to seq_bt or
>>    seq_tb. But the field order translation was backwards, SD NTSC is BT
>>    order, SD PAL is TB.
>>
>> Move this logic to new functions csi_try_field() and prp_try_field().
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   drivers/staging/media/imx/imx-ic-prpencvf.c | 22 +++++++++++--
>>   drivers/staging/media/imx/imx-media-csi.c   | 50 +++++++++++++++++++++--------
>>   2 files changed, 56 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
>> index 7e1e0c3..1002eb1 100644
>> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
>> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
>> @@ -833,6 +833,21 @@ static int prp_get_fmt(struct v4l2_subdev *sd,
>>   	return ret;
>>   }
>>   
>> +static void prp_try_field(struct prp_priv *priv,
>> +			  struct v4l2_subdev_pad_config *cfg,
>> +			  struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct v4l2_mbus_framefmt *infmt =
>> +		__prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD, sdformat->which);
>> +
>> +	/* no restrictions on sink pad field type */
>> +	if (sdformat->pad == PRPENCVF_SINK_PAD)
>> +		return;
>> +
>> +	if (!idmac_interweave(sdformat->format.field, infmt->field))
>> +		sdformat->format.field = infmt->field;
> This is not strict enough. As I wrote in reply to patch 4, we can only
> do SEQ_TB -> INTERLACED_TB and SEQ_BT -> INTERLACED_BT interweaving.

Agreed.

Steve
