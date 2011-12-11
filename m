Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1LKLaT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 06:30:19 -0500
Message-ID: <4EE49440.4010606@infradead.org>
Date: Sun, 11 Dec 2011 09:30:08 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: 'Peter Korsgaard' <jacmet@sunsite.dk>, linux-media@vger.kernel.org
Subject: Re: [PATCH] s5p_mfc_enc: fix s/H264/H263/ typo
References: <1323079935-5351-1-git-send-email-jacmet@sunsite.dk> <00c801ccb3f2$b9333460$2b999d20$%debski@samsung.com>
In-Reply-To: <00c801ccb3f2$b9333460$2b999d20$%debski@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06-12-2011 06:40, Kamil Debski wrote:
> Hi Peter,
>
> Thank you for your patch!
> I'll include it with the patches we'll be sending to Mauro.

That's trivial enough ;) I'll just add your ack and put on my next
upstream series.

>
> Best wishes,
> --
> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center
>
>
>> -----Original Message-----
>> From: Peter Korsgaard [mailto:jacmet@gmail.com] On Behalf Of Peter Korsgaard
>> Sent: 05 December 2011 11:12
>> To: k.debski@samsung.com; mchehab@infradead.org; linux-media@vger.kernel.org
>> Cc: Peter Korsgaard
>> Subject: [PATCH] s5p_mfc_enc: fix s/H264/H263/ typo
>>
>> Signed-off-by: Peter Korsgaard<jacmet@sunsite.dk>
>> ---
>>   drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
>> b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
>> index 1e8cdb7..dff9dc7 100644
>> --- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
>> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
>> @@ -61,7 +61,7 @@ static struct s5p_mfc_fmt formats[] = {
>>   		.num_planes = 1,
>>   	},
>>   	{
>> -		.name = "H264 Encoded Stream",
>> +		.name = "H263 Encoded Stream",
>>   		.fourcc = V4L2_PIX_FMT_H263,
>>   		.codec_mode = S5P_FIMV_CODEC_H263_ENC,
>>   		.type = MFC_FMT_ENC,
>> --
>> 1.7.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

