Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44016 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932650AbdC3H4R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 03:56:17 -0400
Subject: Re: [PATCHv2 1/2] serio.h: add SERIO_RAINSHADOW_CEC ID
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <20170203152633.33323-1-hverkuil@xs4all.nl>
 <20170203152633.33323-2-hverkuil@xs4all.nl>
 <03557e88-4f32-9d6c-20a8-62ae53fd3607@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        linux-input <linux-input@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <aae072f1-0abd-60b1-3679-b169425dedb1@xs4all.nl>
Date: Thu, 30 Mar 2017 09:56:14 +0200
MIME-Version: 1.0
In-Reply-To: <03557e88-4f32-9d6c-20a8-62ae53fd3607@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping?

	Hans

On 06/03/17 15:31, Hans Verkuil wrote:
> Dmitry,
> 
> Can I have your Ack for this patch? I'd like to get this driver in for 4.12.
> 
> You can also take this for 4.12 yourself, but serio.h doesn't change often
> so the chance of conflicts is small.
> 
> Regards,
> 
>     Hans
> 
> On 03/02/17 16:26, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add a new serio ID for the RainShadow Tech USB HDMI CEC adapter.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  include/uapi/linux/serio.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/include/uapi/linux/serio.h b/include/uapi/linux/serio.h
>> index f2447a8..f42e919 100644
>> --- a/include/uapi/linux/serio.h
>> +++ b/include/uapi/linux/serio.h
>> @@ -79,5 +79,6 @@
>>  #define SERIO_WACOM_IV    0x3e
>>  #define SERIO_EGALAX    0x3f
>>  #define SERIO_PULSE8_CEC    0x40
>> +#define SERIO_RAINSHADOW_CEC    0x41
>>
>>  #endif /* _UAPI_SERIO_H */
>>
> 
