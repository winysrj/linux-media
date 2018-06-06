Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751914AbeFFMyH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Jun 2018 08:54:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DGKnU15pjF2+eyMUaSuE0FCr2FMF90WrJb+kXt80xBCw@mail.gmail.com>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-6-git-send-email-vgarodia@codeaurora.org>
 <20180605210758.GA19888@rob-hp-laptop> <CAAFQd5DGKnU15pjF2+eyMUaSuE0FCr2FMF90WrJb+kXt80xBCw@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Wed, 6 Jun 2018 07:53:45 -0500
Message-ID: <CAL_Jsq+c1EbDGKhKov8cgB5r7SAeXZkXzJ96za2e3ukc8yOyZA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] venus: register separate driver for firmware device
To: Tomasz Figa <tfiga@google.com>
Cc: Vikash Garodia <vgarodia@codeaurora.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-soc@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 5, 2018 at 11:46 PM, Tomasz Figa <tfiga@google.com> wrote:
> Hi Rob,
>
> On Wed, Jun 6, 2018 at 6:08 AM Rob Herring <robh@kernel.org> wrote:
>>
>> On Sat, Jun 02, 2018 at 01:56:08AM +0530, Vikash Garodia wrote:
>> > A separate child device is added for video firmware.
>> > This is needed to
>> > [1] configure the firmware context bank with the desired SID.
>> > [2] ensure that the iova for firmware region is from 0x0.
>> >
>> > Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
>> > ---
>> >  .../devicetree/bindings/media/qcom,venus.txt       |  8 +++-
>> >  drivers/media/platform/qcom/venus/core.c           | 48 +++++++++++++++++++---
>> >  drivers/media/platform/qcom/venus/firmware.c       | 20 ++++++++-
>> >  drivers/media/platform/qcom/venus/firmware.h       |  2 +
>> >  4 files changed, 71 insertions(+), 7 deletions(-)
>> >
>> > diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
>> > index 00d0d1b..701cbe8 100644
>> > --- a/Documentation/devicetree/bindings/media/qcom,venus.txt
>> > +++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
>> > @@ -53,7 +53,7 @@
>> >
>> >  * Subnodes
>> >  The Venus video-codec node must contain two subnodes representing
>> > -video-decoder and video-encoder.
>> > +video-decoder and video-encoder, one optional firmware subnode.
>> >
>> >  Every of video-encoder or video-decoder subnode should have:
>> >
>> > @@ -79,6 +79,8 @@ Every of video-encoder or video-decoder subnode should have:
>> >                   power domain which is responsible for collapsing
>> >                   and restoring power to the subcore.
>> >
>> > +The firmware sub node must contain the iommus specifiers for ARM9.
>> > +
>> >  * An Example
>> >       video-codec@1d00000 {
>> >               compatible = "qcom,msm8916-venus";
>> > @@ -105,4 +107,8 @@ Every of video-encoder or video-decoder subnode should have:
>> >                       clock-names = "core";
>> >                       power-domains = <&mmcc VENUS_CORE1_GDSC>;
>> >               };
>> > +             venus-firmware {
>> > +                     compatible = "qcom,venus-firmware-no-tz";
>> > +                     iommus = <&apps_smmu 0x10b2 0x0>;
>>
>> This mostly looks like you are adding a node in order to create a
>> platform device. DT is not the only way to create platform devices and
>> shouldn't be used when the device is not really a separate h/w device.
>> Plus it seems like it is debatable that you even need a driver.
>>
>> For iommus, just move it up to the parent (or add to existing prop).
>
> As far as I understood the issue from reading this series and also
> talking a bit with Stanimir, there are multiple (physical?) ports from
> the Venus hardware block and that includes one dedicated for firmware
> loading, which has IOVA range restrictions up to 6 MiBs or something
> like that.
>
> If we add the firmware port to the iommus property of the main node,
> we would bind it to the same IOVA address space as the other ports and
> so it would be part of the main full 32-bit IOMMU domain.

Sounds like an OS limitation, not a DT problem.

That being said, I suppose we can live with having this sub-node if we
can't fix or work-around this limitation.

Rob
