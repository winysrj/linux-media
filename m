Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:54427 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaD3Fth (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 01:49:37 -0400
Received: by mail-oa0-f45.google.com with SMTP id eb12so1427117oac.18
        for <linux-media@vger.kernel.org>; Tue, 29 Apr 2014 22:49:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53608DEB.1020608@gmail.com>
References: <1398257864-12097-1-git-send-email-arun.kk@samsung.com>
	<1398257864-12097-3-git-send-email-arun.kk@samsung.com>
	<CAK9yfHzB11kJbOcL-jHHo_P4D2nXtHuGRM_FT0mNuvV0SLywrQ@mail.gmail.com>
	<53608DEB.1020608@gmail.com>
Date: Wed, 30 Apr 2014 11:19:36 +0530
Message-ID: <CAK9yfHzFsSaWHFzWW--C_4vzaVRCbjeZ0+T6ZTAQn4NwP5oYYw@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] s5p-mfc: Core support to add v8 decoder
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arun Kumar K <arunkk.samsung@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <posciak@chromium.org>,
	Kiran Avnd <avnd.kiran@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 30 April 2014 11:15, Arun Kumar K <arunkk.samsung@gmail.com> wrote:
> Hi Sachin,
>
> Thank you for the review.
>
>
> On 04/29/14 22:45, Sachin Kamat wrote:
>>
>> Hi Arun,
>>
>> On 23 April 2014 18:27, Arun Kumar K <arun.kk@samsung.com> wrote:
>>>
>>> From: Kiran AVND <avnd.kiran@samsung.com>
>>>
>>> This patch adds variant data and core support for
>>> V8 decoder. This patch also adds the register definition
>>> file for new firmware version v8 for MFC.
>>>
>>> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
>>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>>> ---
>>
>> <...>
>>>
>>> +
>>> +/* Returned value register for specific setting */
>>> +#define S5P_FIMV_D_RET_PICTURE_TAG_TOP_V8      0xf674
>>> +#define S5P_FIMV_D_RET_PICTURE_TAG_BOT_V8      0xf678
>>> +#define S5P_FIMV_D_MVC_VIEW_ID_V8              0xf6d8
>>> +
>>> +/* SEI related information */
>>> +#define S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V8     0xf6dc
>>> +
>>> +/* MFCv8 Context buffer sizes */
>>> +#define MFC_CTX_BUF_SIZE_V8            (30 * SZ_1K)    /*  30KB */
>>
>>
>> Please include header file for size macros.
>>
>
> The file linux/sizes.h is included in regs-mfc-v6.h which
> inturn gets included in this file. Isnt that fine?

Direct inclusions are encouraged. Please add it in this file.

>
>
>> <...>
>>>
>>>   };
>>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>>> b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>>> index 48a14b5..f0e63f5 100644
>>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>>> @@ -23,8 +23,7 @@
>>>   #include <media/v4l2-ioctl.h>
>>>   #include <media/videobuf2-core.h>
>>>   #include "regs-mfc.h"
>>> -#include "regs-mfc-v6.h"
>>> -#include "regs-mfc-v7.h"
>>> +#include "regs-mfc-v8.h"
>>>
>>>   /* Definitions related to MFC memory */
>>>
>>> @@ -705,5 +704,6 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
>>>   #define IS_TWOPORT(dev)                (dev->variant->port_num == 2 ? 1
>>> : 0)
>>>   #define IS_MFCV6_PLUS(dev)     (dev->variant->version >= 0x60 ? 1 : 0)
>>>   #define IS_MFCV7(dev)          (dev->variant->version >= 0x70 ? 1 : 0)
>>
>>
>> Is MFC v8 superset of MFC v7?
>>
>
> Yes it is a superset.
> So the last patch in this series renames IS_MFCV7 to IS_MFCV7_PLUS.

Shouldn't that be done first in that case?

-- 
With warm regards,
Sachin
