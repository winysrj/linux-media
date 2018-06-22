Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:39244 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754648AbeFVXRP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 19:17:15 -0400
Received: by mail-pg0-f67.google.com with SMTP id n2-v6so152879pgq.6
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2018 16:17:15 -0700 (PDT)
Date: Fri, 22 Jun 2018 16:19:34 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Tomasz Figa <tfiga@chromium.org>
Cc: vgarodia@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, andy.gross@linaro.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: Re: [PATCH v2 3/5] venus: add check to make scm calls
Message-ID: <20180622231934.GO3402@tuxbook-pro>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-4-git-send-email-vgarodia@codeaurora.org>
 <CAAFQd5BSgB0OoqUFckJLXto9FNMYCTQ8ubDftaC-LvFm+A-gxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5BSgB0OoqUFckJLXto9FNMYCTQ8ubDftaC-LvFm+A-gxA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 04 Jun 05:58 PDT 2018, Tomasz Figa wrote:

> Hi Vikash,
> 
> On Sat, Jun 2, 2018 at 5:27 AM Vikash Garodia <vgarodia@codeaurora.org> wrote:
> [snip]
> > +int venus_boot(struct venus_core *core)
> > +{
> > +       phys_addr_t mem_phys;
> > +       size_t mem_size;
> > +       int ret;
> > +       struct device *dev;
> > +
> > +       if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER))
> > +               return -EPROBE_DEFER;
> 
> Why are we deferring probe here? The option will not magically become
> enabled after probe is retried.
> 

The original code should have read:

	if (IS_ENABLED(CONFIG_QCOM_MDT_LOADER) && !qcom_scm_is_available())
		return -EPROBE_DEFER;

The code does depend on CONFIG_QCOM_MDT_LOADER regardless of it using
scm for firmware verification.

Regards,
Bjorn
