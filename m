Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59541 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbaANBq0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 20:46:26 -0500
Message-ID: <52D496F0.1050807@iki.fi>
Date: Tue, 14 Jan 2014 03:46:24 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] msi3101: add u8 sample format
References: <1388292700-18369-1-git-send-email-crope@iki.fi> <1388292700-18369-4-git-send-email-crope@iki.fi> <52C94CC2.30005@xs4all.nl>
In-Reply-To: <52C94CC2.30005@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05.01.2014 14:14, Hans Verkuil wrote:
> On 12/29/2013 05:51 AM, Antti Palosaari wrote:
>> Add unsigned 8-bit sample format. Format is got directly from
>> hardware, but it is converted from signed to unsigned. It is worst
>> known sampling resolution hardware offer.
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/staging/media/msi3101/sdr-msi3101.c | 67 ++++++++++++++++++++++++++++-
>>   1 file changed, 66 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
>> index 9c54c63..2110488 100644
>> --- a/drivers/staging/media/msi3101/sdr-msi3101.c
>> +++ b/drivers/staging/media/msi3101/sdr-msi3101.c
>> @@ -385,6 +385,7 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
>>   #define MSI3101_CID_TUNER_IF              ((V4L2_CID_USER_BASE | 0xf000) + 12)
>>   #define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
>>
>> +#define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
>>   #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
>>   #define V4L2_PIX_FMT_SDR_S12    v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
>>   #define V4L2_PIX_FMT_SDR_S14    v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */
>
> These defines should be moved to videodev2.h and documented in DocBook.

Indeed, but that driver is still on staging. I will move those later...

regards
Antti


-- 
http://palosaari.fi/
