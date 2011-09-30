Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:63694 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab1I3Muu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 08:50:50 -0400
Received: by yib18 with SMTP id 18so1459482yib.19
        for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 05:50:49 -0700 (PDT)
Message-ID: <4E85BB23.70300@linaro.org>
Date: Fri, 30 Sep 2011 18:20:43 +0530
From: Subash Patel <subash.ramaswamy@linaro.org>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	mchehab@infradead.org, patches@linaro.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/1] [media] MFC: Change MFC firmware binary name
References: <1317380162-16344-1-git-send-email-sachin.kamat@linaro.org> <001201cc7f69$9e690c80$db3b2580$%debski@samsung.com>
In-Reply-To: <001201cc7f69$9e690c80$db3b2580$%debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

There is option in menu->"Device Drivers"->"Generic Driver 
Options"->"External firmware blobs to build into the kernel binary".
I have used this many times instead of /lib/firmware mechanism. If 
someone chooses to add firmware in that way, and gives different name, 
then this code too can break. So I have proposed another way to solve 
that. Have a look into this.

Regards,
Subash

On 09/30/2011 05:38 PM, Kamil Debski wrote:
> Hi Sachin,
>
> Thanks for the patch. I agree with you - MFC module could be used in other
> SoCs as well.
>
>> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
>> Sent: 30 September 2011 12:56
>>
>> This patches renames the MFC firmware binary to avoid SoC name in it.
>>
>> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
>
> Acked-by: Kamil Debski<k.debski@samsung.com>
>
>> ---
>>   drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
>> b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
>> index 5f4da80..f2481a8 100644
>> --- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
>> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
>> @@ -38,7 +38,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev
>> *dev)
>>   	 * into kernel. */
>>   	mfc_debug_enter();
>>   	err = request_firmware((const struct firmware **)&fw_blob,
>> -				     "s5pc110-mfc.fw", dev->v4l2_dev.dev);
>> +				     "s5p-mfc.fw", dev->v4l2_dev.dev);
>>   	if (err != 0) {
>>   		mfc_err("Firmware is not present in the /lib/firmware directory
>> nor compiled in kernel\n");
>>   		return -EINVAL;
>> @@ -116,7 +116,7 @@ int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev)
>>   	 * into kernel. */
>>   	mfc_debug_enter();
>>   	err = request_firmware((const struct firmware **)&fw_blob,
>> -				     "s5pc110-mfc.fw", dev->v4l2_dev.dev);
>> +				     "s5p-mfc.fw", dev->v4l2_dev.dev);
int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
{
         struct firmware *fw_blob;
         size_t bank2_base_phys;
         void *b_base;
         int err;
         /* default name */
         char firmware_name[30] = "s5p-mfc.fw";

         /* Firmare has to be present as a separate file or compiled
          * into kernel. */
         mfc_debug_enter();

#ifdef CONFIG_EXTRA_FIRMWARE
         snprintf(firmware_name, sizeof(firmware_name), "%s",
                                         CONFIG_EXTRA_FIRMWARE);
#endif
         err = request_firmware((const struct firmware **)&fw_blob,
                                      firmware_name, dev->v4l2_dev.dev);
         if (err != 0) {
                 mfc_err("Firmware is not present in the /lib/firmware 
directory nor compiled in kernel\n");
                 return -EINVAL;
         }
<snip>

>>   	if (err != 0) {
>>   		mfc_err("Firmware is not present in the /lib/firmware directory
>> nor compiled in kernel\n");
>>   		return -EINVAL;
>> --
>> 1.7.4.1
>
> Best regards,
> --
> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
