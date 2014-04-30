Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47862 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaD3FpW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 01:45:22 -0400
Message-ID: <53608DEB.1020608@gmail.com>
Date: Wed, 30 Apr 2014 11:15:15 +0530
From: Arun Kumar K <arunkk.samsung@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>,
	Arun Kumar K <arun.kk@samsung.com>
CC: linux-media <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <posciak@chromium.org>,
	Kiran Avnd <avnd.kiran@samsung.com>
Subject: Re: [PATCH 2/3] [media] s5p-mfc: Core support to add v8 decoder
References: <1398257864-12097-1-git-send-email-arun.kk@samsung.com>	<1398257864-12097-3-git-send-email-arun.kk@samsung.com> <CAK9yfHzB11kJbOcL-jHHo_P4D2nXtHuGRM_FT0mNuvV0SLywrQ@mail.gmail.com>
In-Reply-To: <CAK9yfHzB11kJbOcL-jHHo_P4D2nXtHuGRM_FT0mNuvV0SLywrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thank you for the review.

On 04/29/14 22:45, Sachin Kamat wrote:
> Hi Arun,
>
> On 23 April 2014 18:27, Arun Kumar K <arun.kk@samsung.com> wrote:
>> From: Kiran AVND <avnd.kiran@samsung.com>
>>
>> This patch adds variant data and core support for
>> V8 decoder. This patch also adds the register definition
>> file for new firmware version v8 for MFC.
>>
>> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
> <...>
>> +
>> +/* Returned value register for specific setting */
>> +#define S5P_FIMV_D_RET_PICTURE_TAG_TOP_V8      0xf674
>> +#define S5P_FIMV_D_RET_PICTURE_TAG_BOT_V8      0xf678
>> +#define S5P_FIMV_D_MVC_VIEW_ID_V8              0xf6d8
>> +
>> +/* SEI related information */
>> +#define S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V8     0xf6dc
>> +
>> +/* MFCv8 Context buffer sizes */
>> +#define MFC_CTX_BUF_SIZE_V8            (30 * SZ_1K)    /*  30KB */
>
> Please include header file for size macros.
>

The file linux/sizes.h is included in regs-mfc-v6.h which
inturn gets included in this file. Isnt that fine?

> <...>
>>   };
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> index 48a14b5..f0e63f5 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> @@ -23,8 +23,7 @@
>>   #include <media/v4l2-ioctl.h>
>>   #include <media/videobuf2-core.h>
>>   #include "regs-mfc.h"
>> -#include "regs-mfc-v6.h"
>> -#include "regs-mfc-v7.h"
>> +#include "regs-mfc-v8.h"
>>
>>   /* Definitions related to MFC memory */
>>
>> @@ -705,5 +704,6 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
>>   #define IS_TWOPORT(dev)                (dev->variant->port_num == 2 ? 1 : 0)
>>   #define IS_MFCV6_PLUS(dev)     (dev->variant->version >= 0x60 ? 1 : 0)
>>   #define IS_MFCV7(dev)          (dev->variant->version >= 0x70 ? 1 : 0)
>
> Is MFC v8 superset of MFC v7?
>

Yes it is a superset.
So the last patch in this series renames IS_MFCV7 to IS_MFCV7_PLUS.

Regards
Arun

>> +#define IS_MFCV8(dev)          (dev->variant->version >= 0x80 ? 1 : 0)
>
