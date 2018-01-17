Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:39774 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751261AbeAQLgd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 06:36:33 -0500
Received: by mail-lf0-f68.google.com with SMTP id m8so21540498lfc.6
        for <linux-media@vger.kernel.org>; Wed, 17 Jan 2018 03:36:33 -0800 (PST)
Subject: Re: [PATCH -next] media: rcar_drif: fix error return code in
 rcar_drif_alloc_dmachannels()
To: Wei Yongjun <weiyongjun1@huawei.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <1516188292-144008-1-git-send-email-weiyongjun1@huawei.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <383f2b67-69a2-3491-f85d-d3bc0b25f6e8@cogentembedded.com>
Date: Wed, 17 Jan 2018 14:36:30 +0300
MIME-Version: 1.0
In-Reply-To: <1516188292-144008-1-git-send-email-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 01/17/2018 02:24 PM, Wei Yongjun wrote:

> Fix to return error code -ENODEV from the dma_request_slave_channel()
> error handling case instead of 0, as done elsewhere in this function.
> rc can be overwrite to 0 by dmaengine_slave_config() in the for loop.

    Overwritten.

> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
[...]

MBR, Sergei
