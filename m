Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9DAC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 06:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D71921726
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 06:10:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QpDVKa0P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfAWGK6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 01:10:58 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39049 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfAWGK5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 01:10:57 -0500
Received: by mail-ot1-f68.google.com with SMTP id n8so945768otl.6
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 22:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tJ8uKtP+GD3ALDGLKkBVTt7dlC2NsD+m/yLfdirg0nE=;
        b=QpDVKa0P06lGxk6pM4lQghnQEWcpCBCb2lR1nG4wo+HKQ/T+/UHMTKHHQaMYpw1u5R
         qVS/du5jqjKOMbvuvxn2cuoe/nADs5nGIZXE0BdJa0TV3v6SgUKpa+6BHCIEBf5HPpSO
         3xskFLeipxJ7N9J3aoYA/a5LBFz3ksFvaxrQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tJ8uKtP+GD3ALDGLKkBVTt7dlC2NsD+m/yLfdirg0nE=;
        b=lT1d3Ey48Pu7oUIV/rDXt1NMj1GlRBh0rNpVXA/PE7MdsrZNblOwrYABhYwM6To2DW
         37qFuoBFOc3SVWAcjtakeoLe9flKS5KJpklTeZ641cfIuD3DKW2DgWptko5WpR599kGW
         tj54LOHCSgfQksJD5d6htTu5l/P1nJLCl2ZEy579fIdy//2MEhvgh3lyxT24esKlXNQI
         xnHv/EC3oVhGrVUXjqTLnfTd6P8IxO660iDDYW4j0dMqTtnWwUlPuAO4IBwC9w3eofQq
         pa39DsBUifIeMHXgJm8xzzIKPOrtoOWNnkNbqphw4q+D/8VUFcnubZ6CEphDsXZ3wYkA
         Jigg==
X-Gm-Message-State: AJcUukeyV8pE2SsJJK+hYjP7bIUvtWqwqOC2Z1BezrvWyZ0h60vnfm+N
        /ztyIPBNeImjawIeg4mp2MbJP7t2x2/20A==
X-Google-Smtp-Source: ALg8bN72rJAq+Ya/tg4tlilcCeaSm5XljwHOtDjdSlY7nF0enAiZHWQyJNK1Exf9Ji1dsNLXllg5Kg==
X-Received: by 2002:a9d:966:: with SMTP id 93mr609282otp.25.1548223856647;
        Tue, 22 Jan 2019 22:10:56 -0800 (PST)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com. [209.85.167.179])
        by smtp.gmail.com with ESMTPSA id i5sm8609459oia.46.2019.01.22.22.10.55
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 22:10:56 -0800 (PST)
Received: by mail-oi1-f179.google.com with SMTP id a77so901013oii.5
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 22:10:55 -0800 (PST)
X-Received: by 2002:aca:5e09:: with SMTP id s9mr551096oib.153.1548223855700;
 Tue, 22 Jan 2019 22:10:55 -0800 (PST)
MIME-Version: 1.0
References: <20190109084616.17162-1-stanimir.varbanov@linaro.org> <20190109084616.17162-2-stanimir.varbanov@linaro.org>
In-Reply-To: <20190109084616.17162-2-stanimir.varbanov@linaro.org>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Wed, 23 Jan 2019 15:10:44 +0900
X-Gmail-Original-Message-ID: <CAPBb6MXr-oLaLUjyPmUf5uFwSLv9WOs17YjnRp_bV8VhZpsosw@mail.gmail.com>
Message-ID: <CAPBb6MXr-oLaLUjyPmUf5uFwSLv9WOs17YjnRp_bV8VhZpsosw@mail.gmail.com>
Subject: Re: [PATCH 1/4] venus: firmware: check fw size against DT memory
 region size
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sorry for the delayed review! >_<

On Wed, Jan 9, 2019 at 5:46 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> By historical reasons we defined firmware memory size to be 6MB even
> that the firmware size for all supported Venus versions is 5MBs. Correct
> that by compare the required firmware size returned from mdt loader and
> the one provided by DT reserved memory region. We proceed further if the
> required firmware size is smaller than provided by DT memory region.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/core.h     |  1 +
>  drivers/media/platform/qcom/venus/firmware.c | 54 +++++++++++---------
>  2 files changed, 31 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index 6382cea29185..79c7e816c706 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -134,6 +134,7 @@ struct venus_core {
>         struct video_firmware {
>                 struct device *dev;
>                 struct iommu_domain *iommu_domain;
> +               size_t mapped_mem_size;
>         } fw;
>         struct mutex lock;
>         struct list_head instances;
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index c29acfd70c1b..6b509ffd022a 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -35,14 +35,15 @@
>
>  static void venus_reset_cpu(struct venus_core *core)
>  {
> +       u32 fw_size = core->fw.mapped_mem_size;
>         void __iomem *base = core->base;
>
>         writel(0, base + WRAPPER_FW_START_ADDR);
> -       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_FW_END_ADDR);
> +       writel(fw_size, base + WRAPPER_FW_END_ADDR);
>         writel(0, base + WRAPPER_CPA_START_ADDR);
> -       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_CPA_END_ADDR);
> -       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_NONPIX_START_ADDR);
> -       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_NONPIX_END_ADDR);
> +       writel(fw_size, base + WRAPPER_CPA_END_ADDR);
> +       writel(fw_size, base + WRAPPER_NONPIX_START_ADDR);
> +       writel(fw_size, base + WRAPPER_NONPIX_END_ADDR);
>         writel(0x0, base + WRAPPER_CPU_CGC_DIS);
>         writel(0x0, base + WRAPPER_CPU_CLOCK_CONFIG);
>
> @@ -74,6 +75,9 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
>         void *mem_va;
>         int ret;
>
> +       *mem_phys = 0;
> +       *mem_size = 0;
> +
>         dev = core->dev;
>         node = of_parse_phandle(dev->of_node, "memory-region", 0);
>         if (!node) {
> @@ -85,28 +89,30 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
>         if (ret)
>                 return ret;
>
> +       ret = request_firmware(&mdt, fwname, dev);
> +       if (ret < 0)
> +               return ret;
> +
> +       fw_size = qcom_mdt_get_size(mdt);
> +       if (fw_size < 0) {
> +               ret = fw_size;
> +               goto err_release_fw;
> +       }
> +
>         *mem_phys = r.start;
>         *mem_size = resource_size(&r);
>
> -       if (*mem_size < VENUS_FW_MEM_SIZE)
> -               return -EINVAL;
> +       if (*mem_size < fw_size || fw_size > VENUS_FW_MEM_SIZE) {

Do we still need to check for fw_size > VENUS_FW_MEM_SIZE ? If we
don't then we can remove the definition of VENUS_FW_MEM_SIZE
altogether.

> +               ret = -EINVAL;
> +               goto err_release_fw;
> +       }
>
>         mem_va = memremap(r.start, *mem_size, MEMREMAP_WC);
>         if (!mem_va) {
>                 dev_err(dev, "unable to map memory region: %pa+%zx\n",
>                         &r.start, *mem_size);
> -               return -ENOMEM;
> -       }
> -
> -       ret = request_firmware(&mdt, fwname, dev);
> -       if (ret < 0)
> -               goto err_unmap;
> -
> -       fw_size = qcom_mdt_get_size(mdt);
> -       if (fw_size < 0) {
> -               ret = fw_size;
> -               release_firmware(mdt);
> -               goto err_unmap;
> +               ret = -ENOMEM;
> +               goto err_release_fw;
>         }
>
>         if (core->use_tz)
> @@ -116,10 +122,9 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
>                 ret = qcom_mdt_load_no_init(dev, mdt, fwname, VENUS_PAS_ID,
>                                             mem_va, *mem_phys, *mem_size, NULL);
>
> -       release_firmware(mdt);
> -
> -err_unmap:
>         memunmap(mem_va);
> +err_release_fw:
> +       release_firmware(mdt);
>         return ret;
>  }
>
> @@ -135,6 +140,7 @@ static int venus_boot_no_tz(struct venus_core *core, phys_addr_t mem_phys,
>                 return -EPROBE_DEFER;
>
>         iommu = core->fw.iommu_domain;
> +       core->fw.mapped_mem_size = mem_size;
>
>         ret = iommu_map(iommu, VENUS_FW_START_ADDR, mem_phys, mem_size,
>                         IOMMU_READ | IOMMU_WRITE | IOMMU_PRIV);
> @@ -151,7 +157,7 @@ static int venus_boot_no_tz(struct venus_core *core, phys_addr_t mem_phys,
>  static int venus_shutdown_no_tz(struct venus_core *core)
>  {
>         struct iommu_domain *iommu;
> -       size_t unmapped;
> +       size_t unmapped, mapped = core->fw.mapped_mem_size;

mapped should probably be const here.

With these minor comments:

Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
Tested-by: Alexandre Courbot <acourbot@chromium.org>

For the 4 patches in this series. I could see the improvement in
decoder performance introduced by patches 2 and 3, thanks!
