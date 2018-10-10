Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:55159 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbeJJOWX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 10:22:23 -0400
Received: by mail-it1-f195.google.com with SMTP id l191-v6so6505277ita.4
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2018 00:01:38 -0700 (PDT)
Received: from mail-it1-f170.google.com (mail-it1-f170.google.com. [209.85.166.170])
        by smtp.gmail.com with ESMTPSA id x21-v6sm8335968ita.6.2018.10.10.00.01.36
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Oct 2018 00:01:37 -0700 (PDT)
Received: by mail-it1-f170.google.com with SMTP id q70-v6so6521802itb.3
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2018 00:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <1538996944-15042-1-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1538996944-15042-1-git-send-email-vgarodia@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 10 Oct 2018 16:01:24 +0900
Message-ID: <CAPBb6MV3ih-tOr=kt6NvYD4ZQPrs2eRpzdnCOZLhEhXeYMatrQ@mail.gmail.com>
Subject: Re: [PATCH v2] venus: vdec: fix decoded data size
To: vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 8, 2018 at 8:09 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> Existing code returns the max of the decoded size and buffer size.
> It turns out that buffer size is always greater due to hardware
> alignment requirement. As a result, payload size given to client
> is incorrect. This change ensures that the bytesused is assigned
> to actual payload size, when available.
>
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>

Tested-by: Alexandre Courbot <acourbot@chromium.org>
