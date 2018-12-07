Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE599C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 10:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8816E20989
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 10:08:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="jh9WpA31"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8816E20989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbeLGKIa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 05:08:30 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43745 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbeLGKI0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 05:08:26 -0500
Received: by mail-wr1-f65.google.com with SMTP id r10so3199924wrs.10
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 02:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0Zizx2lHMpqH5V3Aj7mmqJM8bK23abmMAS2tz3iI3JI=;
        b=jh9WpA31YXM9TMThAgwh16+3uDH8c0me9zX0HZn3DHGqL4AS/a4uJtmtm9R7MPF/YC
         KRrk4Dyhfaub4u8QW5ujm9lW/S64UQ4U+CVuxBzKIJiElrFAmxfId0snSMH/3egTYkEn
         jEUq70nQToAXlZhSMoB0Zlg4h5yEJprLxVMzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Zizx2lHMpqH5V3Aj7mmqJM8bK23abmMAS2tz3iI3JI=;
        b=HwN5UejXDba3u1CEqYZ03t61c75tsWSlPDK5z1rtoO7Ol/VKLxBGMA9Mrc8s6c1pVY
         JoKD7de9tG4Ll84WrugVOEJmaxeJ1SXwF4fWnw7Fh1UhprK5tuTKeiPbhQ/k1BOtVVjM
         4U+1B7nMIgHt+KAEbqCZ2teXcY7995KFdmPgBEO3bfVkpb56iZGexMO8s8lOW17bWrtz
         UOJQ1F6OwFX0AC21293UMcdaRHzJYazh6XYGnlTvpk6MXK0/AzlxNN6Cp/ec6zwo5v27
         tFPUkTgfNR3RVduxTOd3IhNNABc67ivXFZlL3DCsZzApErLQ7h33+PmIENg0LaQjEZX8
         eqBA==
X-Gm-Message-State: AA+aEWb9j/bFbGosQ+Kt6J7kUNH7gNCG3SlHAA9BoeQ/lDlsIIhXoKDI
        YbhUDy0VkZm3OZ15zadtSWqmxdJQ/R0=
X-Google-Smtp-Source: AFSGD/UNdsmxfJ+u67ShRjDZxPElCTaCrnt2SocFtqXHjFAPnc7kL56JGsGtuG5/KMmFi9zopS+6iA==
X-Received: by 2002:adf:f189:: with SMTP id h9mr1259404wro.35.1544177303069;
        Fri, 07 Dec 2018 02:08:23 -0800 (PST)
Received: from [192.168.27.209] (mx2.mm-sol.com. [217.18.243.227])
        by smtp.googlemail.com with ESMTPSA id v6sm3265923wro.57.2018.12.07.02.08.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 02:08:22 -0800 (PST)
Subject: Re: [PATCH 1/1] media: venus: core: Set dma maximum segment size
To:     Vivek Gautam <vivek.gautam@codeaurora.org>,
        stanimir.varbanov@linaro.org, mchehab@kernel.org
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org,
        acourbot@chromium.org
References: <20181205083151.3685-1-vivek.gautam@codeaurora.org>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <a28d0542-5d63-7c72-0f39-40e4524d9a2a@linaro.org>
Date:   Fri, 7 Dec 2018 12:08:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181205083151.3685-1-vivek.gautam@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Vivek,

Thanks for the patch!

On 12/5/18 10:31 AM, Vivek Gautam wrote:
> Turning on CONFIG_DMA_API_DEBUG_SG results in the following error:
> 
> [  460.308650] ------------[ cut here ]------------
> [  460.313490] qcom-venus aa00000.video-codec: DMA-API: mapping sg segment longer than device claims to support [len=4194304] [max=65536]
> [  460.326017] WARNING: CPU: 3 PID: 3555 at src/kernel/dma/debug.c:1301 debug_dma_map_sg+0x174/0x254
> [  460.338888] Modules linked in: venus_dec venus_enc videobuf2_dma_sg videobuf2_memops hci_uart btqca bluetooth venus_core v4l2_mem2mem videobuf2_v4l2 videobuf2_common ath10k_snoc ath10k_core ath lzo lzo_compress zramjoydev
> [  460.375811] CPU: 3 PID: 3555 Comm: V4L2DecoderThre Tainted: G        W         4.19.1 #82
> [  460.384223] Hardware name: Google Cheza (rev1) (DT)
> [  460.389251] pstate: 60400009 (nZCv daif +PAN -UAO)
> [  460.394191] pc : debug_dma_map_sg+0x174/0x254
> [  460.398680] lr : debug_dma_map_sg+0x174/0x254
> [  460.403162] sp : ffffff80200c37d0
> [  460.406583] x29: ffffff80200c3830 x28: 0000000000010000
> [  460.412056] x27: 00000000ffffffff x26: ffffffc0f785ea80
> [  460.417532] x25: 0000000000000000 x24: ffffffc0f4ea1290
> [  460.423001] x23: ffffffc09e700300 x22: ffffffc0f4ea1290
> [  460.428470] x21: ffffff8009037000 x20: 0000000000000001
> [  460.433936] x19: ffffff80091b0000 x18: 0000000000000000
> [  460.439411] x17: 0000000000000000 x16: 000000000000f251
> [  460.444885] x15: 0000000000000006 x14: 0720072007200720
> [  460.450354] x13: ffffff800af536e0 x12: 0000000000000000
> [  460.455822] x11: 0000000000000000 x10: 0000000000000000
> [  460.461288] x9 : 537944d9c6c48d00 x8 : 537944d9c6c48d00
> [  460.466758] x7 : 0000000000000000 x6 : ffffffc0f8d98f80
> [  460.472230] x5 : 0000000000000000 x4 : 0000000000000000
> [  460.477703] x3 : 000000000000008a x2 : ffffffc0fdb13948
> [  460.483170] x1 : ffffffc0fdb0b0b0 x0 : 000000000000007a
> [  460.488640] Call trace:
> [  460.491165]  debug_dma_map_sg+0x174/0x254
> [  460.495307]  vb2_dma_sg_alloc+0x260/0x2dc [videobuf2_dma_sg]
> [  460.501150]  __vb2_queue_alloc+0x164/0x374 [videobuf2_common]
> [  460.507076]  vb2_core_reqbufs+0xfc/0x23c [videobuf2_common]
> [  460.512815]  vb2_reqbufs+0x44/0x5c [videobuf2_v4l2]
> [  460.517853]  v4l2_m2m_reqbufs+0x44/0x78 [v4l2_mem2mem]
> [  460.523144]  v4l2_m2m_ioctl_reqbufs+0x1c/0x28 [v4l2_mem2mem]
> [  460.528976]  v4l_reqbufs+0x30/0x40
> [  460.532480]  __video_do_ioctl+0x36c/0x454
> [  460.536610]  video_usercopy+0x25c/0x51c
> [  460.540572]  video_ioctl2+0x38/0x48
> [  460.544176]  v4l2_ioctl+0x60/0x74
> [  460.547602]  do_video_ioctl+0x948/0x3520
> [  460.551648]  v4l2_compat_ioctl32+0x60/0x98
> [  460.555872]  __arm64_compat_sys_ioctl+0x134/0x20c
> [  460.560718]  el0_svc_common+0x9c/0xe4
> [  460.564498]  el0_svc_compat_handler+0x2c/0x38
> [  460.568982]  el0_svc_compat+0x8/0x18
> [  460.572672] ---[ end trace ce209b87b2f3af88 ]---
> 
> From above warning one would deduce that the sg segment will overflow
> the device's capacity. In reality, the hardware can accommodate larger
> sg segments.
> So, initialize the max segment size properly to weed out this warning.
> 
> Based on a similar patch sent by Sean Paul for mdss:
> https://patchwork.kernel.org/patch/10671457/
> 
> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
