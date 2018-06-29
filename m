Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35189 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752260AbeF2HRm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 03:17:42 -0400
Received: by mail-wr0-f195.google.com with SMTP id c13-v6so7778435wrq.2
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2018 00:17:42 -0700 (PDT)
Subject: Re: [PATCHv2 1/3] dt-bindings: display: dw_hdmi.txt: add cec-disable
 property
To: Hans Verkuil <hverkuil@xs4all.nl>, Rob Herring <robh@kernel.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180323125915.13986-1-hverkuil@xs4all.nl>
 <20180323125915.13986-2-hverkuil@xs4all.nl>
 <20180326072830.iphtbw5mkeciv4kj@rob-hp-laptop>
 <05e7ade1-89be-0f0f-18a5-88ff0310a70b@xs4all.nl>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <714ee0ef-25c4-e065-8120-aebc27a1add7@baylibre.com>
Date: Fri, 29 Jun 2018 09:17:39 +0200
MIME-Version: 1.0
In-Reply-To: <05e7ade1-89be-0f0f-18a5-88ff0310a70b@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 03/04/2018 10:27, Hans Verkuil wrote:
> On 27/03/18 00:25, Rob Herring wrote:
>> On Fri, Mar 23, 2018 at 01:59:13PM +0100, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> Some boards have both a DesignWare and their own CEC controller.
>>> The CEC pin is only hooked up to their own CEC controller and not
>>> to the DW controller.
>>>
>>> Add the cec-disable property to disable the DW CEC controller.
>>>
>>> This particular situation happens on Amlogic boards that have their
>>> own meson CEC controller.
>>
>> Seems like we could avoid this by describing how the CEC line is hooked 
>> up which could be needed for other reasons.
> 
> So there are three situations:
> 
> 1) The cec pin is connected to the DW HDMI TX. That's already supported.
> 2) The cec pin is not connected at all, but the CEC IP is instantiated.
>    We need the cec-disable property for that. This simply states that the
>    CEC pin is not connected.
> 3) The cec pin is connected to an HDMI RX. We do not support this at the
>    moment. If we want to support this, then we need a 'hdmi-rx' phandle
>    that points to the HDMI receiver that the CEC pin is associated with.
>    This will be similar to the already existing 'hdmi-phandle' property
>    used to associate a CEC driver with an HDMI transmitter. In hindsight
>    it would have been better if 'hdmi-phandle' was named 'hdmi-tx' :-(
> 
> I can make a binding proposal for 3, but I have no hardware to test it,
> so I think it is better to add this only when someone has hardware. It
> will require quite a few changes to the driver and likely also the CEC core.

Can't we simply add a property to override the HW config fields in this case ?
It will be then usable with any feature the is enabled by reading the config
bits like AHB Audio, I2c, CEC, ... and maybe many more in the future.

Neil

> 
> Regards,
> 
> 	Hans
> 
>>
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> Acked-by: Neil Armstrong <narmstrong@baylibre.com>
>>> ---
>>>  Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt | 3 +++
>>>  1 file changed, 3 insertions(+)
> 
