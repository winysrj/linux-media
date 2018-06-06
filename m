Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35429 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933145AbeFFQoX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 12:44:23 -0400
Received: by mail-pg0-f66.google.com with SMTP id 15-v6so3288704pge.2
        for <linux-media@vger.kernel.org>; Wed, 06 Jun 2018 09:44:23 -0700 (PDT)
Date: Wed, 6 Jun 2018 09:46:28 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Tomasz Figa <tfiga@chromium.org>, vgarodia@codeaurora.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, andy.gross@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: Re: [PATCH v2 5/5] venus: register separate driver for firmware
 device
Message-ID: <20180606164628.GF510@tuxbook-pro>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-6-git-send-email-vgarodia@codeaurora.org>
 <CAAFQd5D39CkA=GucUs7YOHwsdj0gbk55BiY_gSvArY_RH4uDkg@mail.gmail.com>
 <2cf4f7e8-f9e6-d62b-45a8-2c348af4aafe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cf4f7e8-f9e6-d62b-45a8-2c348af4aafe@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 04 Jun 06:56 PDT 2018, Stanimir Varbanov wrote:
> On 06/04/2018 04:18 PM, Tomasz Figa wrote:
> > On Sat, Jun 2, 2018 at 5:27 AM Vikash Garodia <vgarodia@codeaurora.org> wrote:
[..]
> >> +               venus-firmware {
> >> +                       compatible = "qcom,venus-firmware-no-tz";
> > 
> > I don't think "-no-tz" should be mentioned here in DT, since it's a
> > firmware/software detail.
> 
> I have to agree with Tomasz, non-tz or tz is a software detail and it
> shouldn't be reflected in compatible string.
> 

While it is software, the alternative boot and security configuration
does imply different requirements on how the driver deals with the
hardware. I'm not sure how you expect the kernel to be informed about
the abilities of the boot/security capabilities if it's not passed
through DT.


In the other cases of firmware loading for co-processors this means that
a number of additional resources (clocks, resets) needs to be specified
in the DT node; something it seems like Venus doesn't have to do.

> Also I'm not sure but what will happen if this video-firmware subnode is
> not added, do you expect that backward compatibility is satisfied for
> older venus versions?
> 

I do expect that the driver should be possible to run on a 845 with the
normal TZ based security model we've seen on e.g. 820. I don't know the
details of Venus well enough to see if this differentiation would be
sufficient.

Regards,
Bjorn
