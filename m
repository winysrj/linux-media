Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:42188 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752207AbdLPLyG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 06:54:06 -0500
Subject: Re: [PATCH 1/2] bdisp: Fix a possible sleep-in-atomic bug in
 bdisp_hw_reset
To: Fabien DESSENNE <fabien.dessenne@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <1513086445-29265-1-git-send-email-baijiaju1990@gmail.com>
 <0370257c-ce0c-792f-6c85-50ebc18975f9@st.com>
From: Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <abd7b14d-cda6-ab67-3c5b-7cbd0dbaa336@gmail.com>
Date: Sat, 16 Dec 2017 19:53:55 +0800
MIME-Version: 1.0
In-Reply-To: <0370257c-ce0c-792f-6c85-50ebc18975f9@st.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 2017/12/15 22:51, Fabien DESSENNE wrote:
> Hi
>
> On 12/12/17 14:47, Jia-Ju Bai wrote:
>> The driver may sleep under a spinlock.
>> The function call path is:
>> bdisp_device_run (acquire the spinlock)
>>     bdisp_hw_reset
>>       msleep --> may sleep
>>
>> To fix it, msleep is replaced with mdelay.
> May I suggest you to use readl_poll_timeout_atomic (instead of the whole
> "for" block): this fixes the problem and simplifies the code?

Okay, I have submitted a patch according to your advice.
You can have a look :)


Thanks,
Jia-Ju Bai


>> This bug is found by my static analysis tool(DSAC) and checked by my code review.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>    drivers/media/platform/sti/bdisp/bdisp-hw.c |    2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
>> index b7892f3..4b62ceb 100644
>> --- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
>> +++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
>> @@ -382,7 +382,7 @@ int bdisp_hw_reset(struct bdisp_dev *bdisp)
>>    	for (i = 0; i < POLL_RST_MAX; i++) {
>>    		if (readl(bdisp->regs + BLT_STA1) & BLT_STA1_IDLE)
>>    			break;
>> -		msleep(POLL_RST_DELAY_MS);
>> +		mdelay(POLL_RST_DELAY_MS);
>>    	}
>>    	if (i == POLL_RST_MAX)
>>    		dev_err(bdisp->dev, "Reset timeout\n");
