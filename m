Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:46991 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdGGJbG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 05:31:06 -0400
Subject: Re: [PATCH v6 4/4] dt-bindings: media: Document Synopsys Designware
 HDMI RX
To: Sylwester Nawrocki <snawrocki@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
References: <cover.1499176790.git.joabreu@synopsys.com>
 <d6da0a3ec47a46d30b74e9d41fb4bf9ef392d969.1499176790.git.joabreu@synopsys.com>
 <4dc8f06f-b9cf-6d3d-da88-51abb24c1724@kernel.org>
 <e87124d0-d523-5dcd-5ace-6b5896ad585c@synopsys.com>
 <b0ba8226-972e-a997-e456-c342603b2ffd@kernel.org>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Carlos Palminha" <CARLOS.PALMINHA@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        <devicetree@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <258a880c-8b4d-8201-b90a-44ed4d351daa@synopsys.com>
Date: Fri, 7 Jul 2017 10:31:00 +0100
MIME-Version: 1.0
In-Reply-To: <b0ba8226-972e-a997-e456-c342603b2ffd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06-07-2017 21:30, Sylwester Nawrocki wrote:
> On 07/06/2017 12:24 PM, Jose Abreu wrote:
>>>> +- edid-phandle: phandle to the EDID handler block.
>>> Could you make this property optional and when it is missing assume that device
>>> corresponding to the parent node of this node handles EDID? This way we could
>>> avoid having property pointing to the parent node.
>> Hmm, this is for the CEC notifier. Do you mean I should grab the
>> parent device for the notifier? This property is already optional
>> if cec is not enabled though.
>  
> Yes, device associated with the parent node. Something like:
>
>  - edid-phandle - phandle to the EDID handler block; if this property is
>   not specified it is assumed that EDID is handled by device described 
>   by parent node of the HDMI RX node
>
> Not sure if it is any better than always requiring edid-phandle property,
> even when it is pointing to the parent node. We would need a DT maintainer's
> opinion on that.

I will change and resend. I also have to fix a kbuild error when
cec is not enabled.

Best regards,
Jose Miguel Abreu

>
> --
> Thanks,
> Sylwester
