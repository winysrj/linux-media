Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:43584 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3CGCUq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 21:20:46 -0500
Received: by mail-qa0-f51.google.com with SMTP id cr7so36752qab.17
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 18:20:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5137BEBF.7060608@gmail.com>
References: <1362575757-22839-1-git-send-email-arun.kk@samsung.com>
	<5137BEBF.7060608@gmail.com>
Date: Thu, 7 Mar 2013 07:50:46 +0530
Message-ID: <CAOD6ATpeNvnAsTL+j17d3W-SZr0gXAk07AsXqo+HWW50N7V1_g@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-mfc: Fix encoder control 15 issue
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Mar 7, 2013 at 3:40 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Arun,
>
>
> On 03/06/2013 02:15 PM, Arun Kumar K wrote:
>>
>> mfc-encoder is not working in the latest kernel giving the
>> erorr "Adding control (15) failed". Adding the missing step
>> parameter in this control to fix the issue.
>
>
> Do you mean this problem was not observed in 3.8 kernel and something
> has changed in the v4l2 core so it fails in 3.9-rc now ? Or is it
> related to some change in the driver itself ?

v4l2_ctrl_new() uses check_range() for control range checking (which
is added newly).
This function expects 'step' value for V4L2_CTRL_TYPE_BOOLEAN type control.
If 'step' value doesn't match to '1', it returns -ERANGE error.

Its a change in v4l2 core.

Regards,
Shaik Ameer Basha

>
>
>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>> ---
>>   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> index 2356fd5..4f6b553 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> @@ -232,6 +232,7 @@ static struct mfc_control controls[] = {
>>                 .minimum = 0,
>>                 .maximum = 1,
>>                 .default_value = 0,
>> +               .step = 1,
>>                 .menu_skip_mask = 0,
>>         },
>>         {
>
>
> Regards,
> Sylwester
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
