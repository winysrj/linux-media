Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751586AbdCTRG5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 13:06:57 -0400
MIME-Version: 1.0
In-Reply-To: <7884402a-652b-02c0-a572-d205dc651a8b@xs4all.nl>
References: <20170311112328.11802-1-hverkuil@xs4all.nl> <20170311112328.11802-7-hverkuil@xs4all.nl>
 <20170320164119.cxmson67wdyoww2k@rob-hp-laptop> <7884402a-652b-02c0-a572-d205dc651a8b@xs4all.nl>
From: Rob Herring <robh@kernel.org>
Date: Mon, 20 Mar 2017 11:57:14 -0500
Message-ID: <CAL_JsqL=6s5ci2Q0V_Sc0OrCaYrFDErQ1i_ChCH0+NUkWpsKXQ@mail.gmail.com>
Subject: Re: [PATCHv5 06/16] atmel-isi: document device tree bindings
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 20, 2017 at 11:49 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 03/20/2017 05:41 PM, Rob Herring wrote:
>> On Sat, Mar 11, 2017 at 12:23:18PM +0100, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>

>>> +    ov2640: camera@30 {
>>> +            compatible = "ovti,ov2640";
>>> +            reg = <0x30>;
>>> +            pinctrl-names = "default";
>>> +            pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
>>> +            resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
>>
>> reset-gpios?
>>
>>> +            pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
>>
>> powerdown-gpios?
>
> I can't change this: these two properties have been in use for a long time for the ov2640
> driver.

NM. I was thinking this was the ov7670 you just added.

Rob
