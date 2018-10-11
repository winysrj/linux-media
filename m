Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:36453 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbeJKOW6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 10:22:58 -0400
Received: by mail-io1-f65.google.com with SMTP id p4-v6so5809408iom.3
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2018 23:57:05 -0700 (PDT)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com. [209.85.166.42])
        by smtp.gmail.com with ESMTPSA id q25-v6sm7985337ioi.41.2018.10.10.23.57.03
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Oct 2018 23:57:03 -0700 (PDT)
Received: by mail-io1-f42.google.com with SMTP id y10-v6so5795254ioa.10
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2018 23:57:03 -0700 (PDT)
MIME-Version: 1.0
References: <1539071557-1500-1-git-send-email-mgottam@codeaurora.org>
In-Reply-To: <1539071557-1500-1-git-send-email-mgottam@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Thu, 11 Oct 2018 15:56:52 +0900
Message-ID: <CAPBb6MVHVH=3G0XjuVnr_CFX7HG484of0tFokDkcyk7t9VZkuw@mail.gmail.com>
Subject: Re: [PATCH] media: venus: add support for USERPTR to queue
To: mgottam@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 9, 2018 at 4:52 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>
> Add USERPTR to queue access methods by adding this
> support to io_modes on both the planes.
>
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>

Tested-by: Alexandre Courbot <acourbot@chromium.org>
