Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:40085 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751392AbdHaOTT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 10:19:19 -0400
Subject: Re: [PATCHv4 4/5] cec-gpio: add HDMI CEC GPIO driver
To: Linus Walleij <linus.walleij@linaro.org>
References: <20170831110156.11018-1-hverkuil@xs4all.nl>
 <20170831110156.11018-5-hverkuil@xs4all.nl>
 <CACRpkdYQSYMQHgrOimV6iVRdrjhAXvXdzsfnNr8abykOyZP8yw@mail.gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7a7ad8d3-a52a-de47-4f50-62cd64aa52e3@xs4all.nl>
Date: Thu, 31 Aug 2017 16:19:17 +0200
MIME-Version: 1.0
In-Reply-To: <CACRpkdYQSYMQHgrOimV6iVRdrjhAXvXdzsfnNr8abykOyZP8yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/08/17 16:10, Linus Walleij wrote:
> On Thu, Aug 31, 2017 at 1:01 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add a simple HDMI CEC GPIO driver that sits on top of the cec-pin framework.
>>
>> While I have heard of SoCs that use the GPIO pin for CEC (apparently an
>> early RockChip SoC used that), the main use-case of this driver is to
>> function as a debugging tool.
>>
>> By connecting the CEC line to a GPIO pin on a Raspberry Pi 3 for example
>> it turns it into a CEC debugger and protocol analyzer.
>>
>> With 'cec-ctl --monitor-pin' the CEC traffic can be analyzed.
>>
>> But of course it can also be used with any hardware project where the
>> HDMI CEC line is hooked up to a pull-up gpio line.
>>
>> In addition this has (optional) support for tracing HPD changes if the
>> HPD is connected to a GPIO.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This looks nice!
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thank you for the gpio crash course! :-)

	Hans
