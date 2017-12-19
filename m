Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:40042 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763240AbdLSN5d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 08:57:33 -0500
Subject: Re: [PATCH V2 1/2] bdisp: Fix a possible sleep-in-atomic bug in
 bdisp_hw_reset
To: Fabien DESSENNE <fabien.dessenne@st.com>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1513425251-4143-1-git-send-email-baijiaju1990@gmail.com>
 <b526fa1a-e670-4abe-078c-2c7c5af9a42c@st.com>
From: Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <0551d83c-47c6-e3e0-77fd-f861c6878cbe@gmail.com>
Date: Tue, 19 Dec 2017 21:57:15 +0800
MIME-Version: 1.0
In-Reply-To: <b526fa1a-e670-4abe-078c-2c7c5af9a42c@st.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 2017/12/19 18:43, Fabien DESSENNE wrote:
> Hi,
>
>
> On 16/12/17 12:54, Jia-Ju Bai wrote:
>> The driver may sleep under a spinlock.
>> The function call path is:
>> bdisp_device_run (acquire the spinlock)
>>     bdisp_hw_reset
>>       msleep --> may sleep
>>
>> To fix it, readl_poll_timeout_atomic is used to replace msleep.
>>
>> This bug is found by my static analysis tool(DSAC) and
>> checked by my code review.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>    drivers/media/platform/sti/bdisp/bdisp-hw.c |   16 ++++++++--------
>>    1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
>> index b7892f3..e94a371 100644
>> --- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
>> +++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
>> @@ -5,6 +5,7 @@
>>     */
>>    
>>    #include <linux/delay.h>
> This delay.h include is no more needed, remove it.
>
>> +#include <linux/iopoll.h>
>>    
>>    #include "bdisp.h"
>>    #include "bdisp-filter.h"
>> @@ -366,7 +367,7 @@ struct bdisp_filter_addr {
>>     */
>>    int bdisp_hw_reset(struct bdisp_dev *bdisp)
>>    {
>> -	unsigned int i;
>> +	u32 tmp;
>>    
>>    	dev_dbg(bdisp->dev, "%s\n", __func__);
>>    
>> @@ -379,15 +380,14 @@ int bdisp_hw_reset(struct bdisp_dev *bdisp)
>>    	writel(0, bdisp->regs + BLT_CTL);
>>    
>>    	/* Wait for reset done */
>> -	for (i = 0; i < POLL_RST_MAX; i++) {
>> -		if (readl(bdisp->regs + BLT_STA1) & BLT_STA1_IDLE)
>> -			break;
>> -		msleep(POLL_RST_DELAY_MS);
>> -	}
>> -	if (i == POLL_RST_MAX)
> As recommended by Mauro, please add this comment:
> Despite the large timeout, most of the time the reset happens without
> needing any delays
>
>> +	if (readl_poll_timeout_atomic(bdisp->regs + BLT_STA1, tmp,
>> +		(tmp & BLT_STA1_IDLE), POLL_RST_DELAY_MS,
>> +			POLL_RST_DELAY_MS * POLL_RST_MAX)) {
> read_poll_timeout expects US timings, not MS.
>
>>    		dev_err(bdisp->dev, "Reset timeout\n");
>> +		return -EAGAIN;
>> +	}
>>    
>> -	return (i == POLL_RST_MAX) ? -EAGAIN : 0;
>> +	return 0;
>>    }
>>    
>>    /**

Hi,

Okay, I have submitted a new patch according to your advice :)


Thanks,
Jia-Ju Bai
