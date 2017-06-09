Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbdFIPcL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 11:32:11 -0400
MIME-Version: 1.0
In-Reply-To: <2fa55431-bef2-9340-4ce8-e06f9648e109@xs4all.nl>
References: <20170607144616.15247-1-hverkuil@xs4all.nl> <20170607144616.15247-8-hverkuil@xs4all.nl>
 <20170609140719.o2qzty6eyez66oxy@rob-hp-laptop> <2fa55431-bef2-9340-4ce8-e06f9648e109@xs4all.nl>
From: Rob Herring <robh@kernel.org>
Date: Fri, 9 Jun 2017 10:31:49 -0500
Message-ID: <CAL_JsqLzxMSdQGCiCBa2-VKpe==djCsqP9GxywJ-X-defiRXMQ@mail.gmail.com>
Subject: Re: [PATCH 7/9] dt-bindings: media/s5p-cec.txt: document needs-hpd property
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 9, 2017 at 9:11 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 09/06/17 16:07, Rob Herring wrote:
>> On Wed, Jun 07, 2017 at 04:46:14PM +0200, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> Needed for boards that wire the CEC pin in such a way that it
>>> is unavailable when the HPD is low.
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> Cc: Krzysztof Kozlowski <krzk@kernel.org>
>>> Cc: Andrzej Hajda <a.hajda@samsung.com>
>>> Cc: devicetree@vger.kernel.org
>>> ---
>>>  Documentation/devicetree/bindings/media/s5p-cec.txt | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/s5p-cec.txt b/Documentation/devicetree/bindings/media/s5p-cec.txt
>>> index 4bb08d9d940b..261af4d1a791 100644
>>> --- a/Documentation/devicetree/bindings/media/s5p-cec.txt
>>> +++ b/Documentation/devicetree/bindings/media/s5p-cec.txt
>>> @@ -17,6 +17,12 @@ Required properties:
>>>    - samsung,syscon-phandle - phandle to the PMU system controller
>>>    - hdmi-phandle - phandle to the HDMI controller
>>>
>>> +Optional:
>>> +  - needs-hpd : if present the CEC support is only available when the HPD
>>> +    is high. Some boards only let the CEC pin through if the HPD is high, for
>>> +    example if there is a level converter that uses the HPD to power up
>>> +    or down.
>>
>> Seems like something common. Can you document in a common location?
>
> Should we do the same with hdmi-phandle? It is also used by CEC drivers to find
> the HDMI driver.

Yes.

> Currently only used by s5p-cec and stih-cec, but there will be more.
>
> I guess this would be a sensible place to document this:
>
> Documentation/devicetree/bindings/media/cec.txt

Sounds good. You can do this as a follow-up to this patch if you want.
For this one:

Acked-by: Rob Herring <robh@kernel.org>
