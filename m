Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34120 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbeEET4i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 15:56:38 -0400
Received: by mail-pf0-f193.google.com with SMTP id a14so19917475pfi.1
        for <linux-media@vger.kernel.org>; Sat, 05 May 2018 12:56:38 -0700 (PDT)
Subject: Re: [PATCH] media: imx-csi: fix burst size for 16 bit
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Jan Luebbe <jlu@pengutronix.de>, linux-media@vger.kernel.org
References: <20180503163200.12214-1-jlu@pengutronix.de>
 <1525365651.3408.3.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <81614a46-d06b-3f91-91c5-e599a987ea75@gmail.com>
Date: Sat, 5 May 2018 12:56:35 -0700
MIME-Version: 1.0
In-Reply-To: <1525365651.3408.3.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>


On 05/03/2018 09:40 AM, Philipp Zabel wrote:
> On Thu, 2018-05-03 at 18:32 +0200, Jan Luebbe wrote:
>> A burst_size of 4 does not work for the 16 bit passthrough formats, so
>> we use 8 instead.
>>
>> Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
>> ---
>>   drivers/staging/media/imx/imx-media-csi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index 1112d8f67a18..08b636084286 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -410,7 +410,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>>   	case V4L2_PIX_FMT_SGRBG16:
>>   	case V4L2_PIX_FMT_SRGGB16:
>>   	case V4L2_PIX_FMT_Y16:
>> -		burst_size = 4;
>> +		burst_size = 8;
> This seems to be the equivalent to commit 37ea9830139b3 ("media: imx-
> csi: fix burst size"), but for 16-bit formats.
>
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
>
> regards
> Philipp
