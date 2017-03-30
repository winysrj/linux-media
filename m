Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36476 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933024AbdC3K0m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:26:42 -0400
MIME-Version: 1.0
In-Reply-To: <58DCB178.6070909@bfs.de>
References: <20170330062517.GA25231@SEL-JYOUN-D1> <58DCB178.6070909@bfs.de>
From: DaeSeok Youn <daeseok.youn@gmail.com>
Date: Thu, 30 Mar 2017 19:26:40 +0900
Message-ID: <CAHb8M2CN3SE8SmJVRBri9NG71X35Gksxde4RN+7D-+Aoicy3Eg@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: atomisp: use local variable to reduce the
 number of reference
To: wharms@bfs.de
Cc: mchehab@kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        SIMRAN SINGHAL <singhalsimran0@gmail.com>,
        linux-media@vger.kernel.org, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-03-30 16:19 GMT+09:00 walter harms <wharms@bfs.de>:
>
>
> Am 30.03.2017 08:25, schrieb Daeseok Youn:
>> Define new local variable to reduce the number of reference.
>> The new local variable is added to save the addess of dfs
>> and used in atomisp_freq_scaling() function.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 37 ++++++++++++----------
>>  1 file changed, 20 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
>> index eebfccd..d76a95c 100644
>> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
>> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
>> @@ -251,6 +251,7 @@ int atomisp_freq_scaling(struct atomisp_device *isp,
>>  {
>>       /* FIXME! Only use subdev[0] status yet */
>>       struct atomisp_sub_device *asd = &isp->asd[0];
>> +     const struct atomisp_dfs_config *dfs;
>>       unsigned int new_freq;
>>       struct atomisp_freq_scaling_rule curr_rules;
>>       int i, ret;
>> @@ -268,20 +269,22 @@ int atomisp_freq_scaling(struct atomisp_device *isp,
>>           ATOMISP_USE_YUVPP(asd))
>>               isp->dfs = &dfs_config_cht_soc;
>>
>> -     if (isp->dfs->lowest_freq == 0 || isp->dfs->max_freq_at_vmin == 0 ||
>> -         isp->dfs->highest_freq == 0 || isp->dfs->dfs_table_size == 0 ||
>> -         !isp->dfs->dfs_table) {
>> +     dfs = isp->dfs;
>> +
>> +     if (dfs->lowest_freq == 0 || dfs->max_freq_at_vmin == 0 ||
>> +         dfs->highest_freq == 0 || dfs->dfs_table_size == 0 ||
>> +         !dfs->dfs_table) {
>>               dev_err(isp->dev, "DFS configuration is invalid.\n");
>>               return -EINVAL;
>>       }
>>
>>       if (mode == ATOMISP_DFS_MODE_LOW) {
>> -             new_freq = isp->dfs->lowest_freq;
>> +             new_freq = dfs->lowest_freq;
>>               goto done;
>>       }
>>
>>       if (mode == ATOMISP_DFS_MODE_MAX) {
>> -             new_freq = isp->dfs->highest_freq;
>> +             new_freq = dfs->highest_freq;
>>               goto done;
>>       }
>>
>> @@ -307,26 +310,26 @@ int atomisp_freq_scaling(struct atomisp_device *isp,
>>       }
>>
>>       /* search for the target frequency by looping freq rules*/
>> -     for (i = 0; i < isp->dfs->dfs_table_size; i++) {
>> -             if (curr_rules.width != isp->dfs->dfs_table[i].width &&
>> -                 isp->dfs->dfs_table[i].width != ISP_FREQ_RULE_ANY)
>> +     for (i = 0; i < dfs->dfs_table_size; i++) {
>> +             if (curr_rules.width != dfs->dfs_table[i].width &&
>> +                 dfs->dfs_table[i].width != ISP_FREQ_RULE_ANY)
>>                       continue;
>> -             if (curr_rules.height != isp->dfs->dfs_table[i].height &&
>> -                 isp->dfs->dfs_table[i].height != ISP_FREQ_RULE_ANY)
>> +             if (curr_rules.height != dfs->dfs_table[i].height &&
>> +                 dfs->dfs_table[i].height != ISP_FREQ_RULE_ANY)
>>                       continue;
>> -             if (curr_rules.fps != isp->dfs->dfs_table[i].fps &&
>> -                 isp->dfs->dfs_table[i].fps != ISP_FREQ_RULE_ANY)
>> +             if (curr_rules.fps != dfs->dfs_table[i].fps &&
>> +                 dfs->dfs_table[i].fps != ISP_FREQ_RULE_ANY)
>>                       continue;
>> -             if (curr_rules.run_mode != isp->dfs->dfs_table[i].run_mode &&
>> -                 isp->dfs->dfs_table[i].run_mode != ISP_FREQ_RULE_ANY)
>> +             if (curr_rules.run_mode != dfs->dfs_table[i].run_mode &&
>> +                 dfs->dfs_table[i].run_mode != ISP_FREQ_RULE_ANY)
>>                       continue;
>>               break;
>>       }
>
>>
>> -     if (i == isp->dfs->dfs_table_size)
>> -             new_freq = isp->dfs->max_freq_at_vmin;
>> +     if (i == dfs->dfs_table_size)
>> +             new_freq = dfs->max_freq_at_vmin;
>>       else
>> -             new_freq = isp->dfs->dfs_table[i].isp_freq;
>> +             new_freq = dfs->dfs_table[i].isp_freq;
>>
>
> you can eliminate the last block by setting
>
>  new_freq = dfs->max_freq_at_vmin;
>
>   for(i=0;....) {
>         ....
>         new_freq = dfs->dfs_table[i].isp_freq;
>         break;
> }
Yes, it could be. I will make another patch to improve it as your comment.
>
> unfortunately i have no good idea how to make the loop more readable.
I am not sure whether the for-loop is possible to improve for
readability or not. :-)

Thanks for comment.
Regards,
Daeseok.
>
>
> re,
>  wh
>
>
>>  done:
>>       dev_dbg(isp->dev, "DFS target frequency=%d.\n", new_freq);
