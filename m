Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbeGPO2e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 10:28:34 -0400
MIME-Version: 1.0
References: <1530797585-8555-1-git-send-email-todor.tomov@linaro.org>
 <1530797585-8555-9-git-send-email-todor.tomov@linaro.org> <20180711160713.GA29354@rob-hp-laptop>
 <CAA3CUABj_udpu1yAGGd070_uLNYLbTYEHb_sbHLheUErkPnYtQ@mail.gmail.com>
In-Reply-To: <CAA3CUABj_udpu1yAGGd070_uLNYLbTYEHb_sbHLheUErkPnYtQ@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Mon, 16 Jul 2018 08:00:47 -0600
Message-ID: <CAL_JsqLm7bMf5PgQa0vQR4ERApzdv+wOHfayOG7GdMtDKDJdbw@mail.gmail.com>
Subject: Re: [PATCH v2 08/34] media: camss: Unify the clock names
To: Todor Tomov <todor.tomov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 16, 2018 at 2:53 AM Todor Tomov <todor.tomov@linaro.org> wrote:
>
> Hi Rob,
>
> Thank you for review.
>
> On 11 July 2018 at 19:07, Rob Herring <robh@kernel.org> wrote:
> > On Thu, Jul 05, 2018 at 04:32:39PM +0300, Todor Tomov wrote:
> >> Unify the clock names - use names closer to the clock
> >> definitions.
> >
> > Why? You can't just change names. You are breaking an ABI.
>
> Main reason is that this change allows more logical names and
> handling in the driver when support for 8996 is added.
> To clarify by example:
> - we used to have "camss_vfe_vfe" in 8916;
> - now we will have "vfe0" in 8916 and "vfe0" and "vfe1" in 8996.
>
> To achieve this I have changed the names to match more closely
> the definitions in the clock driver, which are based on the
> documentation. Yes, I should have done this the first time...
>
> I have used to update the dt and kernel code together. Yes, the
> change breaks the ABI but does this cause difficulties in practice?

That's up to the platform maintainers to decide. As a user of these
boards, yes, it would bother me. However, camera I don't care so much
about.

In any case, the commit message should make this crystal clear and
justify why breaking compatibility is okay.

Rob
