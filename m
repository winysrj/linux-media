Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:57739 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932178AbdGJPyP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 11:54:15 -0400
Subject: Re: [PATCH v4 4/4] dt-bindings: media: Document Synopsys Designware
 HDMI RX
To: Rob Herring <robh@kernel.org>, Jose Abreu <Jose.Abreu@synopsys.com>
References: <cover.1497978962.git.joabreu@synopsys.com>
 <8ebe3dfcd61a1c8cfa99102c376ad26b2bfbd254.1497978963.git.joabreu@synopsys.com>
 <20170623215814.ase6g4lbukaeqak2@rob-hp-laptop>
 <13f2516b-9e2b-4ad6-ecf1-76fc0d744a32@synopsys.com>
 <CAL_JsqKoW=VJ=QmLeztYJSnWEhq+KetsZY9xtoyOa8bf0BA=uw@mail.gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <c38bba94-f050-5738-d955-a1d75aad333e@synopsys.com>
Date: Mon, 10 Jul 2017 16:54:09 +0100
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKoW=VJ=QmLeztYJSnWEhq+KetsZY9xtoyOa8bf0BA=uw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,


On 10-07-2017 16:24, Rob Herring wrote:
> On Mon, Jun 26, 2017 at 11:42 AM, Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>> Hi Rob,
>>
>>
>> On 23-06-2017 22:58, Rob Herring wrote:
>>> On Tue, Jun 20, 2017 at 06:26:12PM +0100, Jose Abreu wrote:
>>>> Document the bindings for the Synopsys Designware HDMI RX.
>>>>
> [...]
>
>>>> +A sample binding is now provided. The compatible string is for a SoC which has
>>>> +has a Synopsys Designware HDMI RX decoder inside.
>>>> +
>>>> +Example:
>>>> +
>>>> +dw_hdmi_soc: dw-hdmi-soc@0 {
>>>> +    compatible = "snps,dw-hdmi-soc";
>>> Not documented.
>> Yes, its a sample binding which reflects a wrapper driver that
>> shall instantiate the controller driver (and this wrapper driver
>> is not in this patch series), should I remove this?
> Ah, I see. Please don't do this wrapper node like what was done on
> DWC3. It should be all one node with the SoC specific part being a new
> compatible string (and maybe additional properties). If there's really
> some custom logic around the IP block, then maybe it makes sense, but
> if it is just different clock connections, phys, resets, etc. those
> don't need a separate node.

Ok. I guess I can just drop the SoC specific bindings as this was
more of a sample as how the EDID handle can be specified. I just
sent v8 now with the new bindings :) Thanks!

Best regards,
Jose Miguel Abreu

>
> Rob
