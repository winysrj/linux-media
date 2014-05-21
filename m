Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:55524 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaEUJP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 05:15:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHxiT2yEnJjXrGEeciQeG_pX74k9mW4HdbHaSHYuq8VgSQ@mail.gmail.com>
References: <1400581029-3475-1-git-send-email-arun.kk@samsung.com>
	<1400581029-3475-3-git-send-email-arun.kk@samsung.com>
	<CAK9yfHxiT2yEnJjXrGEeciQeG_pX74k9mW4HdbHaSHYuq8VgSQ@mail.gmail.com>
Date: Wed, 21 May 2014 14:45:58 +0530
Message-ID: <CALt3h7_O2xmTvKPyKXJEa6vOQXTEjWDi-Dhnq26bEH-xJ2=qbg@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] s5p-mfc: Support multiple firmware sub-versions
From: Arun Kumar K <arun.kk@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <posciak@chromium.org>,
	Kiran Avnd <avnd.kiran@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On Tue, May 20, 2014 at 5:15 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Arun,
>
> On 20 May 2014 15:47, Arun Kumar K <arun.kk@samsung.com> wrote:
>> For MFC firmwares, improved versions with bug fixes and
>> feature additions are released keeping the firmware version
>> including major and minor number same. The issue came with
>> the release of a new MFCv6 firmware with an interface change.
>> This patch adds the support of accepting multiple firmware
>> binaries for every version with the driver trying to load
>> firmwares starting from latest. This ensures full backward
>> compatibility regardless of which firmware version and kernel
>> version is used.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c        |    9 +++++----
>>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   11 ++++++++++-
>>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |   15 ++++++++++++---
>>  3 files changed, 27 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> index 8da4c23..514e7ec 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> @@ -1343,7 +1343,7 @@ static struct s5p_mfc_variant mfc_drvdata_v5 = {
>>         .port_num       = MFC_NUM_PORTS,
>>         .buf_size       = &buf_size_v5,
>>         .buf_align      = &mfc_buf_align_v5,
>> -       .fw_name        = "s5p-mfc.fw",
>> +       .fw_name[0]     = "s5p-mfc.fw",
>>  };
>>
>>  struct s5p_mfc_buf_size_v6 mfc_buf_size_v6 = {
>> @@ -1370,7 +1370,8 @@ static struct s5p_mfc_variant mfc_drvdata_v6 = {
>>         .port_num       = MFC_NUM_PORTS_V6,
>>         .buf_size       = &buf_size_v6,
>>         .buf_align      = &mfc_buf_align_v6,
>> -       .fw_name        = "s5p-mfc-v6.fw",
>> +       .fw_name[0]     = "s5p-mfc-v6.fw",
>> +       .fw_name[1]     = "s5p-mfc-v6-v2.fw",
>
> Probably a simple 1 line comment about the difference between the
> versions would help.
>

Ok will add.

>>  };
>>
>>  struct s5p_mfc_buf_size_v6 mfc_buf_size_v7 = {
>> @@ -1397,7 +1398,7 @@ static struct s5p_mfc_variant mfc_drvdata_v7 = {
>>         .port_num       = MFC_NUM_PORTS_V7,
>>         .buf_size       = &buf_size_v7,
>>         .buf_align      = &mfc_buf_align_v7,
>> -       .fw_name        = "s5p-mfc-v7.fw",
>> +       .fw_name[0]     = "s5p-mfc-v7.fw",
>>  };
>>
>>  struct s5p_mfc_buf_size_v6 mfc_buf_size_v8 = {
>> @@ -1424,7 +1425,7 @@ static struct s5p_mfc_variant mfc_drvdata_v8 = {
>>         .port_num       = MFC_NUM_PORTS_V8,
>>         .buf_size       = &buf_size_v8,
>>         .buf_align      = &mfc_buf_align_v8,
>> -       .fw_name        = "s5p-mfc-v8.fw",
>> +       .fw_name[0]     = "s5p-mfc-v8.fw",
>>  };
>>
>>  static struct platform_device_id mfc_driver_ids[] = {
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> index 89681c3..de60185 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> @@ -38,6 +38,8 @@
>>  #define MFC_BANK2_ALIGN_ORDER  13
>>  #define MFC_BASE_ALIGN_ORDER   17
>>
>> +#define MFC_FW_MAX_VERSIONS    2
>> +
>>  #include <media/videobuf2-dma-contig.h>
>>
>>  static inline dma_addr_t s5p_mfc_mem_cookie(void *a, void *b)
>> @@ -163,6 +165,11 @@ enum s5p_mfc_decode_arg {
>>         MFC_DEC_RES_CHANGE,
>>  };
>>
>> +enum s5p_mfc_fw_ver {
>> +       MFC_FW_V1,
>> +       MFC_FW_V2,
>> +};
>> +
>>  #define MFC_BUF_FLAG_USED      (1 << 0)
>>  #define MFC_BUF_FLAG_EOS       (1 << 1)
>>
>> @@ -225,7 +232,7 @@ struct s5p_mfc_variant {
>>         u32 version_bit;
>>         struct s5p_mfc_buf_size *buf_size;
>>         struct s5p_mfc_buf_align *buf_align;
>> -       char    *fw_name;
>> +       char    *fw_name[MFC_FW_MAX_VERSIONS];
>>  };
>>
>>  /**
>> @@ -287,6 +294,7 @@ struct s5p_mfc_priv_buf {
>>   * @warn_start:                hardware error code from which warnings start
>>   * @mfc_ops:           ops structure holding HW operation function pointers
>>   * @mfc_cmds:          cmd structure holding HW commands function pointers
>> + * @fw_ver:            loaded firmware sub-version
>>   *
>>   */
>>  struct s5p_mfc_dev {
>> @@ -331,6 +339,7 @@ struct s5p_mfc_dev {
>>         struct s5p_mfc_hw_ops *mfc_ops;
>>         struct s5p_mfc_hw_cmds *mfc_cmds;
>>         const struct s5p_mfc_regs *mfc_regs;
>> +       enum s5p_mfc_fw_ver fw_ver;
>>  };
>>
>>  /**
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
>> index c97c7c8..7aabcdb 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
>> @@ -78,14 +78,23 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
>>  int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
>>  {
>>         struct firmware *fw_blob;
>> -       int err;
>> +       int err = -EINVAL, i;
>
> nit: Please use either
>             int i, err = -EINVAL;
> or
>             int i;
>             int err = -EINVAL;
>

Ok

>>
>>         /* Firmare has to be present as a separate file or compiled
>>          * into kernel. */
>>         mfc_debug_enter();
>>
>> -       err = request_firmware((const struct firmware **)&fw_blob,
>> -                                    dev->variant->fw_name, dev->v4l2_dev.dev);
>> +       for (i = MFC_FW_MAX_VERSIONS - 1; i >= 0; i--) {
>> +               if (!dev->variant->fw_name[i])
>> +                       continue;
>> +               err = request_firmware((const struct firmware **)&fw_blob,
>> +                               dev->variant->fw_name[i], dev->v4l2_dev.dev);
>> +               if (!err) {
>> +                       dev->fw_ver = (enum s5p_mfc_fw_ver) i;
>
> Where is this getting used?
>

Its used in the next patch in the series for init buffer options.

Regards
Arun

>
> --
> With warm regards,
> Sachin
