Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:36653 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbeISNPj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 09:15:39 -0400
Received: by mail-io1-f65.google.com with SMTP id q5-v6so3711459iop.3
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 00:38:59 -0700 (PDT)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com. [209.85.166.41])
        by smtp.gmail.com with ESMTPSA id m7-v6sm6558099itb.39.2018.09.19.00.38.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Sep 2018 00:38:57 -0700 (PDT)
Received: by mail-io1-f41.google.com with SMTP id y3-v6so3709717ioc.5
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 00:38:57 -0700 (PDT)
MIME-Version: 1.0
References: <1537307954-9729-1-git-send-email-vgarodia@codeaurora.org> <72fb5d7d570c7f5520cc304bea800ae6@codeaurora.org>
In-Reply-To: <72fb5d7d570c7f5520cc304bea800ae6@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 19 Sep 2018 16:38:45 +0900
Message-ID: <CAPBb6MUk14W5hAM=h5rrZF+8w8RnwpNrBya+BPQ+TPdRp_834A@mail.gmail.com>
Subject: Re: [PATCH v8 0/5] Venus updates - PIL
To: vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

Thanks for this new revision. I don't have much to add, apart from
maybe a few suggestions to make it easier to follow the "story" this
series tells:

* Maybe the no_tz member is appearing too early in the series. For the
first two patches, we still only support loading the firmware through
TrustZone. In patch 3 we initialize no_tz properly, but still cannot
boot without TrustZone, which creates a state where the driver could
parse the firmware node, but would still attempt to use TrustZone.
* I feel like patch 1 should be merged into patch 4, since the
function it introduces is not used before patch 4 anyway.

If you agree I can maybe do the v9 of the series to address the two
points mentioned above, unless Stanimir is already happy with the
state?

In any case, this is doing the job, so:
Tested-by: Alexandre Courbot <acourbot@chromium.org>

On Wed, Sep 19, 2018 at 8:45 AM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> Ignore the v8 of this series. The code that was modified was added to
> wrong
> patchset while handling the git rebase.
> Please review the version 9.
>
> On 2018-09-19 03:29, Vikash Garodia wrote:
> > This series just fixes the compilation for of_dma_configure.
> > Minor #define name improvement and indentations.
> >
> > Stanimir Varbanov (1):
> >   venus: firmware: register separate platform_device for firmware
> > loader
> >
> > Vikash Garodia (4):
> >   venus: firmware: add routine to reset ARM9
> >   venus: firmware: move load firmware in a separate function
> >   venus: firmware: add no TZ boot and shutdown routine
> >   dt-bindings: media: Document bindings for venus firmware device
> >
> >  .../devicetree/bindings/media/qcom,venus.txt       |  13 +-
> >  drivers/media/platform/qcom/venus/core.c           |  24 ++-
> >  drivers/media/platform/qcom/venus/core.h           |   6 +
> >  drivers/media/platform/qcom/venus/firmware.c       | 234
> > +++++++++++++++++++--
> >  drivers/media/platform/qcom/venus/firmware.h       |  17 +-
> >  drivers/media/platform/qcom/venus/hfi_venus.c      |  13 +-
> >  drivers/media/platform/qcom/venus/hfi_venus_io.h   |   8 +
> >  7 files changed, 272 insertions(+), 43 deletions(-)
