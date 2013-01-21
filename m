Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36382 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3AUMvP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 07:51:15 -0500
MIME-Version: 1.0
In-Reply-To: <50FD38D1.5020104@redhat.com>
References: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
	<50FD38D1.5020104@redhat.com>
Date: Mon, 21 Jan 2013 10:51:14 -0200
Message-ID: <CA+MoWDrbaPiByV+H5xC2WyhV3XSVugjHkGg03-8H_0EeLE=1wA@mail.gmail.com>
Subject: Re: [PATCH 01/24] use IS_ENABLED() macro
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Nieder <jrnieder@gmail.com>, emilgoode@gmail.com,
	linux-media <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 21, 2013 at 10:47 AM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
> Thanks for the patches I'll pick up 5 - 21 and add them to
> my tree for Mauro.
I have sent V2 of this patches with another subject and with fixed
commit message for two patches.

>
> Regards,
>
> Hans
>
>
>
> On 01/19/2013 05:33 PM, Peter Senna Tschudin wrote:
>>
>> replace:
>>   #if defined(CONFIG_VIDEO_CX88_DVB) || \
>>       defined(CONFIG_VIDEO_CX88_DVB_MODULE)
>> with:
>>   #if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)
>>
>> This change was made for: CONFIG_VIDEO_CX88_DVB,
>> CONFIG_VIDEO_CX88_BLACKBIRD, CONFIG_VIDEO_CX88_VP3054
>>
>> Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>> ---
>>   drivers/media/pci/cx88/cx88.h | 10 ++++------
>>   1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
>> index ba0dba4..feff53c 100644
>> --- a/drivers/media/pci/cx88/cx88.h
>> +++ b/drivers/media/pci/cx88/cx88.h
>> @@ -363,7 +363,7 @@ struct cx88_core {
>>         unsigned int               tuner_formats;
>>
>>         /* config info -- dvb */
>> -#if defined(CONFIG_VIDEO_CX88_DVB) ||
>> defined(CONFIG_VIDEO_CX88_DVB_MODULE)
>> +#if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)
>>         int                        (*prev_set_voltage)(struct dvb_frontend
>> *fe, fe_sec_voltage_t voltage);
>>   #endif
>>         void                       (*gate_ctrl)(struct cx88_core  *core,
>> int open);
>> @@ -562,8 +562,7 @@ struct cx8802_dev {
>>
>>         /* for blackbird only */
>>         struct list_head           devlist;
>> -#if defined(CONFIG_VIDEO_CX88_BLACKBIRD) || \
>> -    defined(CONFIG_VIDEO_CX88_BLACKBIRD_MODULE)
>> +#if IS_ENABLED(CONFIG_VIDEO_CX88_BLACKBIRD)
>>         struct video_device        *mpeg_dev;
>>         u32                        mailbox;
>>         int                        width;
>> @@ -574,13 +573,12 @@ struct cx8802_dev {
>>         struct cx2341x_handler     cxhdl;
>>   #endif
>>
>> -#if defined(CONFIG_VIDEO_CX88_DVB) ||
>> defined(CONFIG_VIDEO_CX88_DVB_MODULE)
>> +#if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)
>>         /* for dvb only */
>>         struct videobuf_dvb_frontends frontends;
>>   #endif
>>
>> -#if defined(CONFIG_VIDEO_CX88_VP3054) || \
>> -    defined(CONFIG_VIDEO_CX88_VP3054_MODULE)
>> +#if IS_ENABLED(CONFIG_VIDEO_CX88_VP3054)
>>         /* For VP3045 secondary I2C bus support */
>>         struct vp3054_i2c_state    *vp3054;
>>   #endif
>>
>



--
Peter
