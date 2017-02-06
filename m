Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751810AbdBFVba (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 16:31:30 -0500
MIME-Version: 1.0
In-Reply-To: <00bc695f-d412-7796-93a9-8d67a8f66370@xs4all.nl>
References: <20170130140628.18088-1-hverkuil@xs4all.nl> <20170130140628.18088-9-hverkuil@xs4all.nl>
 <20170201165059.2qw3gnuyornvfl46@rob-hp-laptop> <00bc695f-d412-7796-93a9-8d67a8f66370@xs4all.nl>
From: Rob Herring <robh@kernel.org>
Date: Mon, 6 Feb 2017 15:31:07 -0600
Message-ID: <CAL_Jsq+NANxTFROAnKh_C4RDwzRQQSFv0UNQ+poGPAXxNT1-Mw@mail.gmail.com>
Subject: Re: [PATCHv2 08/16] atmel-isi: document device tree bindings
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 6, 2017 at 6:20 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 02/01/2017 05:50 PM, Rob Herring wrote:
>> On Mon, Jan 30, 2017 at 03:06:20PM +0100, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> Document the device tree bindings for this driver.

>>> +isi: isi@f0034000 {
>>> +    compatible = "atmel,at91sam9g45-isi";
>>> +    reg = <0xf0034000 0x4000>;
>>> +    interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
>>> +    pinctrl-names = "default";
>>> +    pinctrl-0 = <&pinctrl_isi_data_0_7>;
>>> +    clocks = <&isi_clk>;
>>> +    clock-names = "isi_clk";
>>> +    status = "ok";
>>> +    port {
>>> +            #address-cells = <1>;
>>> +            #size-cells = <0>;
>>> +            isi_0: endpoint {
>>> +                    reg = <0>;
>>
>> Drop reg.
>
> Is that because that is the default?

Essentially, yes. You only need reg if you have more than one of something.

Rob
