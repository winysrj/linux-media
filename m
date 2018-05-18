Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:36869 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751506AbeERI4O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 04:56:14 -0400
Received: by mail-vk0-f52.google.com with SMTP id m144-v6so4382961vke.4
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 01:56:14 -0700 (PDT)
Received: from mail-vk0-f46.google.com (mail-vk0-f46.google.com. [209.85.213.46])
        by smtp.gmail.com with ESMTPSA id 79-v6sm1915313ual.3.2018.05.18.01.56.12
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 May 2018 01:56:12 -0700 (PDT)
Received: by mail-vk0-f46.google.com with SMTP id q189-v6so4373822vkb.0
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 01:56:12 -0700 (PDT)
MIME-Version: 1.0
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
 <20180424124436.26955-2-stanimir.varbanov@linaro.org> <CAAFQd5CYaeUNFMFrQAC2mofd80LKt6zxBRwAje4AoWbhGvGJ0A@mail.gmail.com>
 <ace94242-b4cc-c671-451e-de668273d2ef@linaro.org>
In-Reply-To: <ace94242-b4cc-c671-451e-de668273d2ef@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 18 May 2018 17:56:00 +0900
Message-ID: <CAAFQd5CazCbucV6ep5eS9eBULwJVNUGNfeOSe_AVk_iN21VA8A@mail.gmail.com>
Subject: Re: [PATCH 01/28] venus: hfi_msgs: correct pointer increment
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 18, 2018 at 5:52 PM Stanimir Varbanov <
stanimir.varbanov@linaro.org> wrote:

> Hi Tomasz,

> Thanks for the review!

> On 05/18/2018 11:33 AM, Tomasz Figa wrote:
> > Hi Stanimir,
> >
> > Thanks for the series. I'll be gradually reviewing subsequent patches.
Stay
> > tuned. :)
> >

> Please consider that there is a v2 of this patchset. :)

Thanks for heads up. Looks like I missed it originally. Will move to v2
with my review.

Best regards,
Tomasz
