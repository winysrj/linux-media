Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:39247 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709Ab1LARfm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 12:35:42 -0500
MIME-Version: 1.0
In-Reply-To: <201112011824.54207.laurent.pinchart@ideasonboard.com>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
 <1322698500-29924-3-git-send-email-saaguirre@ti.com> <201112011824.54207.laurent.pinchart@ideasonboard.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Thu, 1 Dec 2011 11:35:20 -0600
Message-ID: <CAKnK67R_sTToETijbBsyKXfdfvKv68vaF-_Ur5uYy=yKJ4hiEA@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] mfd: twl6040: Fix wrong TWL6040_GPO3 bitfield value
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@iki.fi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review.

On Thu, Dec 1, 2011 at 11:24 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Sergio,
>
> On Thursday 01 December 2011 01:14:51 Sergio Aguirre wrote:
>> The define should be the result of 1 << Bit number.
>>
>> Bit number for GPOCTL.GPO3 field is 2, which results
>> in 0x4 value.
>>
>> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
>> ---
>>  include/linux/mfd/twl6040.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
>> index 2463c261..2a7ff16 100644
>> --- a/include/linux/mfd/twl6040.h
>> +++ b/include/linux/mfd/twl6040.h
>> @@ -142,7 +142,7 @@
>>
>>  #define TWL6040_GPO1                 0x01
>>  #define TWL6040_GPO2                 0x02
>> -#define TWL6040_GPO3                 0x03
>> +#define TWL6040_GPO3                 0x04
>
> What about defining the fields as (1 << x) instead then ?

I thought about that, but I guess I just wanted to keep it
consistent with the rest of the file.

Maybe I can create a separate patch for changing all these bitwise
flags to use BIT() macros instead.

Thanks and Regards,
Sergio

>
>>
>>  /* ACCCTL (0x2D) fields */
>
> --
> Regards,
>
> Laurent Pinchart
