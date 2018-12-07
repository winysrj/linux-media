Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_MIXED_ES autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA76BC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F7E02146F
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NXdkoIOp";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="P9Pps7bS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F7E02146F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbeLGN1L (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:27:11 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44064 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeLGN1L (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:27:11 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 23E6E60ADD; Fri,  7 Dec 2018 13:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544189230;
        bh=wdC2HuPCuuXgoXAUu8EnRSc0IveHwdGl06tG74aKC7s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NXdkoIOppFAHWYUr32ndMl8a0XfN5Y89z4cndGOfMSEKnFcm8aKZ2cAfquYC6VWGt
         TcoWuU4eKGGEW00Q25JmOPSnR6XFvV+j2Kf0oBg0ge7dVUJxBjyFN+SuXWLf/Dc0NG
         NOe26adttei2KN4OEMF18QcmK0vIG+ssgQNX7P9k=
Received: from [10.79.40.233] (blr-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: vivek.gautam@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E136360115;
        Fri,  7 Dec 2018 13:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544189227;
        bh=wdC2HuPCuuXgoXAUu8EnRSc0IveHwdGl06tG74aKC7s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=P9Pps7bShrwa5ZR1AJ7EXRWHIcmxJVrc+6yWPVRheUcsmR/x7Sr78niSkhMCNLUvL
         pQ1ORxqtLoozZdbCX09fOuTQ83ZWcjoDHaBz4ZPDjO0GuB/Aq76teVWF7UhuHkGuHh
         G6Lt1JJCoaAQYvhsxXsupYVihqkyLeFGprJnx1SQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E136360115
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=vivek.gautam@codeaurora.org
Subject: Re: [PATCH 1/1] media: venus: core: Set dma maximum segment size
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        mchehab@kernel.org
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org,
        acourbot@chromium.org
References: <20181205083151.3685-1-vivek.gautam@codeaurora.org>
 <a28d0542-5d63-7c72-0f39-40e4524d9a2a@linaro.org>
From:   Vivek Gautam <vivek.gautam@codeaurora.org>
Message-ID: <97d486e6-d940-5db0-eeff-077d694334a2@codeaurora.org>
Date:   Fri, 7 Dec 2018 18:57:02 +0530
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <a28d0542-5d63-7c72-0f39-40e4524d9a2a@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 12/7/2018 3:38 PM, Stanimir Varbanov wrote:
> Hi Vivek,
>
> Thanks for the patch!
>
> On 12/5/18 10:31 AM, Vivek Gautam wrote:
>> Turning on CONFIG_DMA_API_DEBUG_SG results in the following error:
>>
>> [  460.308650] ------------[ cut here ]------------
>> [  460.313490] qcom-venus aa00000.video-codec: DMA-API: mapping sg segment longer than device claims to support [len=4194304] [max=65536]
>> [  460.326017] WARNING: CPU: 3 PID: 3555 at src/kernel/dma/debug.c:1301 debug_dma_map_sg+0x174/0x254
>> [  460.338888] Modules linked in: venus_dec venus_enc videobuf2_dma_sg videobuf2_memops hci_uart btqca bluetooth venus_core v4l2_mem2mem videobuf2_v4l2 videobuf2_common ath10k_snoc ath10k_core ath lzo lzo_compress zramjoydev
>> [  460.375811] CPU: 3 PID: 3555 Comm: V4L2DecoderThre Tainted: G        W         4.19.1 #82
>> [  460.384223] Hardware name: Google Cheza (rev1) (DT)
>> [  460.389251] pstate: 60400009 (nZCv daif +PAN -UAO)
>> [  460.394191] pc : debug_dma_map_sg+0x174/0x254
>> [  460.398680] lr : debug_dma_map_sg+0x174/0x254
>> [  460.403162] sp : ffffff80200c37d0
>> [  460.406583] x29: ffffff80200c3830 x28: 0000000000010000
>> [  460.412056] x27: 00000000ffffffff x26: ffffffc0f785ea80
>> [  460.417532] x25: 0000000000000000 x24: ffffffc0f4ea1290
>> [  460.423001] x23: ffffffc09e700300 x22: ffffffc0f4ea1290
>> [  460.428470] x21: ffffff8009037000 x20: 0000000000000001
>> [  460.433936] x19: ffffff80091b0000 x18: 0000000000000000
>> [  460.439411] x17: 0000000000000000 x16: 000000000000f251
>> [  460.444885] x15: 0000000000000006 x14: 0720072007200720
>> [  460.450354] x13: ffffff800af536e0 x12: 0000000000000000
>> [  460.455822] x11: 0000000000000000 x10: 0000000000000000
>> [  460.461288] x9 : 537944d9c6c48d00 x8 : 537944d9c6c48d00
>> [  460.466758] x7 : 0000000000000000 x6 : ffffffc0f8d98f80
>> [  460.472230] x5 : 0000000000000000 x4 : 0000000000000000
>> [  460.477703] x3 : 000000000000008a x2 : ffffffc0fdb13948
>> [  460.483170] x1 : ffffffc0fdb0b0b0 x0 : 000000000000007a
>> [  460.488640] Call trace:
>> [  460.491165]  debug_dma_map_sg+0x174/0x254
>> [  460.495307]  vb2_dma_sg_alloc+0x260/0x2dc [videobuf2_dma_sg]
>> [  460.501150]  __vb2_queue_alloc+0x164/0x374 [videobuf2_common]
>> [  460.507076]  vb2_core_reqbufs+0xfc/0x23c [videobuf2_common]
>> [  460.512815]  vb2_reqbufs+0x44/0x5c [videobuf2_v4l2]
>> [  460.517853]  v4l2_m2m_reqbufs+0x44/0x78 [v4l2_mem2mem]
>> [  460.523144]  v4l2_m2m_ioctl_reqbufs+0x1c/0x28 [v4l2_mem2mem]
>> [  460.528976]  v4l_reqbufs+0x30/0x40
>> [  460.532480]  __video_do_ioctl+0x36c/0x454
>> [  460.536610]  video_usercopy+0x25c/0x51c
>> [  460.540572]  video_ioctl2+0x38/0x48
>> [  460.544176]  v4l2_ioctl+0x60/0x74
>> [  460.547602]  do_video_ioctl+0x948/0x3520
>> [  460.551648]  v4l2_compat_ioctl32+0x60/0x98
>> [  460.555872]  __arm64_compat_sys_ioctl+0x134/0x20c
>> [  460.560718]  el0_svc_common+0x9c/0xe4
>> [  460.564498]  el0_svc_compat_handler+0x2c/0x38
>> [  460.568982]  el0_svc_compat+0x8/0x18
>> [  460.572672] ---[ end trace ce209b87b2f3af88 ]---
>>
>>  From above warning one would deduce that the sg segment will overflow
>> the device's capacity. In reality, the hardware can accommodate larger
>> sg segments.
>> So, initialize the max segment size properly to weed out this warning.
>>
>> Based on a similar patch sent by Sean Paul for mdss:
>> https://patchwork.kernel.org/patch/10671457/
>>
>> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
>> ---
>>   drivers/media/platform/qcom/venus/core.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
> Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>


Thanks Stan.


Best regards
Vivek

