Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760712AbdJQVNc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 17:13:32 -0400
MIME-Version: 1.0
In-Reply-To: <20171017202407.GA10482@ulmo>
References: <cover.1507752381.git.digetx@gmail.com> <3d432aa2617977a2b0a8621a1fc2f36f751133e1.1507752381.git.digetx@gmail.com>
 <20171017201354.efgjrwvakkseyvr7@rob-hp-laptop> <20171017202407.GA10482@ulmo>
From: Rob Herring <robh@kernel.org>
Date: Tue, 17 Oct 2017 16:13:10 -0500
Message-ID: <CAL_JsqKtFD9OgO2privwfBAZeCn3zg1JienmefPk=X2W-+ahJQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] staging: Introduce NVIDIA Tegra20 video decoder driver
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Dmitry Osipenko <digetx@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 17, 2017 at 3:24 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Tue, Oct 17, 2017 at 03:13:54PM -0500, Rob Herring wrote:
> [...]
>> > diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-vde.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-vde.txt
> [...]
>> > +- resets : Must contain an entry for each entry in reset-names.
>> > +  See ../reset/reset.txt for details.
>> > +- reset-names : Must include the following entries:
>> > +  - vde
>>
>> -names is pointless when there is only one.
>
> I'd prefer to keep it. In the past we occasionally had to add clocks or
> resets to a device tree node where only one had been present (and hence
> no -names property) and that caused some awkwardness because verbiage
> had to be added to the bindings that clarified that one particular entry
> (the original one) always had to come first.

The order should be specified regardless of -names and the original
one has to come first if you add any. That's not awkwardness, but how
bindings work.

Rob
