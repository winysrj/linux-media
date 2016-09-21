Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:28050 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbcIUGdk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 02:33:40 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH -next] [media] pxa_camera: fix error return code in pxa_camera_probe()
References: <1473906105-29387-1-git-send-email-weiyj.lk@gmail.com>
Date: Wed, 21 Sep 2016 08:33:37 +0200
In-Reply-To: <1473906105-29387-1-git-send-email-weiyj.lk@gmail.com> (Wei
        Yongjun's message of "Thu, 15 Sep 2016 02:21:45 +0000")
Message-ID: <87zin1dany.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wei Yongjun <weiyj.lk@gmail.com> writes:

> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> Fix to return error code -ENODEV from dma_request_slave_channel_compat()
> error handling case instead of 0, as done elsewhere in this function.
>
> Also fix to release resources in v4l2_clk_register() error handling.
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
