Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751899AbdGFUbA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 16:31:00 -0400
Subject: Re: [PATCH v6 4/4] dt-bindings: media: Document Synopsys Designware
 HDMI RX
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org
References: <cover.1499176790.git.joabreu@synopsys.com>
 <d6da0a3ec47a46d30b74e9d41fb4bf9ef392d969.1499176790.git.joabreu@synopsys.com>
 <4dc8f06f-b9cf-6d3d-da88-51abb24c1724@kernel.org>
 <e87124d0-d523-5dcd-5ace-6b5896ad585c@synopsys.com>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <b0ba8226-972e-a997-e456-c342603b2ffd@kernel.org>
Date: Thu, 6 Jul 2017 22:30:55 +0200
MIME-Version: 1.0
In-Reply-To: <e87124d0-d523-5dcd-5ace-6b5896ad585c@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/06/2017 12:24 PM, Jose Abreu wrote:
>>> +- edid-phandle: phandle to the EDID handler block.
>>
>> Could you make this property optional and when it is missing assume that device
>> corresponding to the parent node of this node handles EDID? This way we could
>> avoid having property pointing to the parent node.
>
> Hmm, this is for the CEC notifier. Do you mean I should grab the
> parent device for the notifier? This property is already optional
> if cec is not enabled though.
 
Yes, device associated with the parent node. Something like:

 - edid-phandle - phandle to the EDID handler block; if this property is
  not specified it is assumed that EDID is handled by device described 
  by parent node of the HDMI RX node

Not sure if it is any better than always requiring edid-phandle property,
even when it is pointing to the parent node. We would need a DT maintainer's
opinion on that.

--
Thanks,
Sylwester
