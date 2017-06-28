Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35814 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751541AbdF1UZM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 16:25:12 -0400
MIME-Version: 1.0
In-Reply-To: <f8c63e5a-a650-c564-378a-fbe769f2a26d@linaro.org>
References: <20170627150310.719212-1-arnd@arndb.de> <20170627150310.719212-3-arnd@arndb.de>
 <f8c63e5a-a650-c564-378a-fbe769f2a26d@linaro.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 28 Jun 2017 22:25:10 +0200
Message-ID: <CAK8P3a2ckb8MGhvnfLbFM1gf7T95i0Xi+00_GDBtu2LSoA8m_g@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] venus: fix compile-test build on non-qcom ARM platform
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 27, 2017 at 9:45 PM, Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
> Hi Arnd,
>
> On 27.06.2017 18:02, Arnd Bergmann wrote:
>>
>> If QCOM_MDT_LOADER is enabled, but ARCH_QCOM is not, we run into
>> a build error:
>>
>> ERROR: "qcom_mdt_load" [drivers/media/platform/qcom/venus/venus-core.ko]
>> undefined!
>> ERROR: "qcom_mdt_get_size"
>> [drivers/media/platform/qcom/venus/venus-core.ko] undefined!
>
>
> Ahh, thanks for the fix, these two will also pursuing me in my dreams.

I just came after me as well, as I hit another corner case, we need this
fixup on top, I'll send a replacement:

Subject: [PATCH] fixup! [media] venus: fix compile-test  build on
non-qcom ARM platform

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/platform/qcom/venus/firmware.c
b/drivers/media/platform/qcom/venus/firmware.c
index 76edb9f60311..3794b9e3250b 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -40,7 +40,7 @@ int venus_boot(struct device *parent, struct device
*fw_dev, const char *fwname)
  void *mem_va;
  int ret;

- if (!qcom_scm_is_available())
+ if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) || !qcom_scm_is_available())
  return -EPROBE_DEFER;

  fw_dev->parent = parent;
