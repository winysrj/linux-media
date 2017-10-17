Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:53339 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934817AbdJQV0u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 17:26:50 -0400
Subject: Re: [PATCH v3 1/2] staging: Introduce NVIDIA Tegra20 video decoder
 driver
To: Rob Herring <robh@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1507752381.git.digetx@gmail.com>
 <3d432aa2617977a2b0a8621a1fc2f36f751133e1.1507752381.git.digetx@gmail.com>
 <20171017201354.efgjrwvakkseyvr7@rob-hp-laptop> <20171017202407.GA10482@ulmo>
 <CAL_JsqKtFD9OgO2privwfBAZeCn3zg1JienmefPk=X2W-+ahJQ@mail.gmail.com>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <ca4fa045-17f0-9142-6bca-bbf472c1f3bb@gmail.com>
Date: Wed, 18 Oct 2017 00:26:45 +0300
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKtFD9OgO2privwfBAZeCn3zg1JienmefPk=X2W-+ahJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.10.2017 00:13, Rob Herring wrote:
> On Tue, Oct 17, 2017 at 3:24 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>> On Tue, Oct 17, 2017 at 03:13:54PM -0500, Rob Herring wrote:
>> [...]
>>>> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-vde.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-vde.txt
>> [...]
>>>> +- resets : Must contain an entry for each entry in reset-names.
>>>> +  See ../reset/reset.txt for details.
>>>> +- reset-names : Must include the following entries:
>>>> +  - vde
>>>
>>> -names is pointless when there is only one.
>>
>> I'd prefer to keep it. In the past we occasionally had to add clocks or
>> resets to a device tree node where only one had been present (and hence
>> no -names property) and that caused some awkwardness because verbiage
>> had to be added to the bindings that clarified that one particular entry
>> (the original one) always had to come first.
> 
> The order should be specified regardless of -names and the original
> one has to come first if you add any. That's not awkwardness, but how
> bindings work.

Probably it would be okay to remove '-names' from the binding doc, but keep them
in the actual DT, wouldn't it?
