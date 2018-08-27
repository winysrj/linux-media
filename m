Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43363 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbeH0Oma (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 10:42:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id k5-v6so13191667wre.10
        for <linux-media@vger.kernel.org>; Mon, 27 Aug 2018 03:56:20 -0700 (PDT)
Subject: Re: [PATCH v6 1/4] venus: firmware: add routine to reset ARM9
To: Alexandre Courbot <acourbot@chromium.org>
Cc: vgarodia@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org>
 <1535034528-11590-2-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MUZawT84Wcrhi+MEyn+zSCWOpn_iOZMMudZz+_Urixsrw@mail.gmail.com>
 <51cc9d6b-0483-76a6-d413-3f5cc63f3f56@linaro.org>
 <CAPBb6MWMQeXAabnis0iJxE91MCSscacbim3T_K6VF6OODw5TuQ@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <85ffba9c-8b29-4c7a-7aec-999af94aeda0@linaro.org>
Date: Mon, 27 Aug 2018 13:56:15 +0300
MIME-Version: 1.0
In-Reply-To: <CAPBb6MWMQeXAabnis0iJxE91MCSscacbim3T_K6VF6OODw5TuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/27/2018 06:04 AM, Alexandre Courbot wrote:
> On Fri, Aug 24, 2018 at 5:57 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Hi Alex,
>>
>> On 08/24/2018 10:38 AM, Alexandre Courbot wrote:
>>> On Thu, Aug 23, 2018 at 11:29 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>>>>
>>>> Add routine to reset the ARM9 and brings it out of reset. Also
>>>> abstract the Venus CPU state handling with a new function. This
>>>> is in preparation to add PIL functionality in venus driver.
>>>>
>>>> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
>>>> ---
>>>>  drivers/media/platform/qcom/venus/core.h         |  2 ++
>>>>  drivers/media/platform/qcom/venus/firmware.c     | 33 ++++++++++++++++++++++++
>>>>  drivers/media/platform/qcom/venus/firmware.h     | 11 ++++++++
>>>>  drivers/media/platform/qcom/venus/hfi_venus.c    | 13 +++-------
>>>>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  7 +++++
>>>>  5 files changed, 57 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
>>>> index 2f02365..dfd5c10 100644
>>>> --- a/drivers/media/platform/qcom/venus/core.h
>>>> +++ b/drivers/media/platform/qcom/venus/core.h
>>>> @@ -98,6 +98,7 @@ struct venus_caps {
>>>>   * @dev:               convenience struct device pointer
>>>>   * @dev_dec:   convenience struct device pointer for decoder device
>>>>   * @dev_enc:   convenience struct device pointer for encoder device
>>>> + * @no_tz:     a flag that suggests presence of trustzone
>>>>   * @lock:      a lock for this strucure
>>>>   * @instances: a list_head of all instances
>>>>   * @insts_count:       num of instances
>>>> @@ -129,6 +130,7 @@ struct venus_core {
>>>>         struct device *dev;
>>>>         struct device *dev_dec;
>>>>         struct device *dev_enc;
>>>> +       bool no_tz;
>>>>         struct mutex lock;
>>>>         struct list_head instances;
>>>>         atomic_t insts_count;
>>>> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
>>>> index c4a5778..a9d042e 100644
>>>> --- a/drivers/media/platform/qcom/venus/firmware.c
>>>> +++ b/drivers/media/platform/qcom/venus/firmware.c
>>>> @@ -22,10 +22,43 @@
>>>>  #include <linux/sizes.h>
>>>>  #include <linux/soc/qcom/mdt_loader.h>
>>>>
>>>> +#include "core.h"
>>>>  #include "firmware.h"
>>>> +#include "hfi_venus_io.h"
>>>>
>>>>  #define VENUS_PAS_ID                   9
>>>>  #define VENUS_FW_MEM_SIZE              (6 * SZ_1M)
>>>
>>> This is making a strong assumption about the size of the FW memory
>>> region, which in practice is not always true (I had to reduce it to
>>> 5MB). How about having this as a member of venus_core, which is
>>
>> Why you reduced to 5MB? Is there an issue with 6MB or you don't want to
>> waste reserved memory?
> 
> The DT layout of our board only has 5MB reserved for Venus.
> 
>>> initialized in venus_load_fw() from the actual size of the memory
>>> region? You could do this as an extra patch that comes before this
>>> one.
>>>
>>
>> The size is 6MB by historical reasons and they are no more valid, so I
>> think we could safely decrease to 5MB. I could prepare a patch for that.
> 
> Whether we settle with 6MB or 5MB, that size remains arbitrary and not
> based on the actual firmware size. And __qcom_mdt_load() does check

If we go with 5MB it will not be arbitrary, cause all firmware we have
support to are expecting that size of memory.

> that the firmware fits the memory area. So I don't understand what
> extra safety is added by ensuring the memory region is larger than a
> given number of megabytes?
> 

OK, is that fine for you? Drop size and check does memory region size is
big enough to contain the firmware.

diff --git a/drivers/media/platform/qcom/venus/firmware.c
b/driver/media/platform/qcom/venus/firmware.c
index c4a577848dd7..9bf0d21e02d4 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -25,7 +25,6 @@
 #include "firmware.h"

 #define VENUS_PAS_ID                   9
-#define VENUS_FW_MEM_SIZE              (6 * SZ_1M)

 int venus_boot(struct device *dev, const char *fwname)
 {
@@ -54,25 +53,28 @@ int venus_boot(struct device *dev, const char *fwname)
        mem_phys = r.start;
        mem_size = resource_size(&r);

-       if (mem_size < VENUS_FW_MEM_SIZE)
-               return -EINVAL;
-
-       mem_va = memremap(r.start, mem_size, MEMREMAP_WC);
-       if (!mem_va) {
-               dev_err(dev, "unable to map memory region: %pa+%zx\n",
-                       &r.start, mem_size);
-               return -ENOMEM;
-       }
-
        ret = request_firmware(&mdt, fwname, dev);
        if (ret < 0)
-               goto err_unmap;
+               return ret;

        fw_size = qcom_mdt_get_size(mdt);
        if (fw_size < 0) {
                ret = fw_size;
                release_firmware(mdt);
-               goto err_unmap;
+               return ret;
+       }
+
+       if (mem_size < fw_size) {
+               release_firmware(mdt);
+               return -EINVAL;
+       }
+
+       mem_va = memremap(r.start, mem_size, MEMREMAP_WC);
+       if (!mem_va) {
+               release_firmware(mdt);
+               dev_err(dev, "unable to map memory region: %pa+%zx\n",
+                       &r.start, mem_size);
+               return -ENOMEM;
        }

        ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va,
mem_phys,


-- 
regards,
Stan
