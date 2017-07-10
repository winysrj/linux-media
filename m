Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753772AbdGJPYo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 11:24:44 -0400
MIME-Version: 1.0
In-Reply-To: <13f2516b-9e2b-4ad6-ecf1-76fc0d744a32@synopsys.com>
References: <cover.1497978962.git.joabreu@synopsys.com> <8ebe3dfcd61a1c8cfa99102c376ad26b2bfbd254.1497978963.git.joabreu@synopsys.com>
 <20170623215814.ase6g4lbukaeqak2@rob-hp-laptop> <13f2516b-9e2b-4ad6-ecf1-76fc0d744a32@synopsys.com>
From: Rob Herring <robh@kernel.org>
Date: Mon, 10 Jul 2017 10:24:22 -0500
Message-ID: <CAL_JsqKoW=VJ=QmLeztYJSnWEhq+KetsZY9xtoyOa8bf0BA=uw@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] dt-bindings: media: Document Synopsys Designware
 HDMI RX
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 26, 2017 at 11:42 AM, Jose Abreu <Jose.Abreu@synopsys.com> wrote:
> Hi Rob,
>
>
> On 23-06-2017 22:58, Rob Herring wrote:
>> On Tue, Jun 20, 2017 at 06:26:12PM +0100, Jose Abreu wrote:
>>> Document the bindings for the Synopsys Designware HDMI RX.
>>>

[...]

>>> +A sample binding is now provided. The compatible string is for a SoC which has
>>> +has a Synopsys Designware HDMI RX decoder inside.
>>> +
>>> +Example:
>>> +
>>> +dw_hdmi_soc: dw-hdmi-soc@0 {
>>> +    compatible = "snps,dw-hdmi-soc";
>> Not documented.
>
> Yes, its a sample binding which reflects a wrapper driver that
> shall instantiate the controller driver (and this wrapper driver
> is not in this patch series), should I remove this?

Ah, I see. Please don't do this wrapper node like what was done on
DWC3. It should be all one node with the SoC specific part being a new
compatible string (and maybe additional properties). If there's really
some custom logic around the IP block, then maybe it makes sense, but
if it is just different clock connections, phys, resets, etc. those
don't need a separate node.

Rob
