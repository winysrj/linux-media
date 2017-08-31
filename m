Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34105 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751286AbdHaOKk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 10:10:40 -0400
Received: by mail-oi0-f42.google.com with SMTP id w10so6429006oie.1
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 07:10:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170831110156.11018-5-hverkuil@xs4all.nl>
References: <20170831110156.11018-1-hverkuil@xs4all.nl> <20170831110156.11018-5-hverkuil@xs4all.nl>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 31 Aug 2017 16:10:38 +0200
Message-ID: <CACRpkdYQSYMQHgrOimV6iVRdrjhAXvXdzsfnNr8abykOyZP8yw@mail.gmail.com>
Subject: Re: [PATCHv4 4/5] cec-gpio: add HDMI CEC GPIO driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 31, 2017 at 1:01 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Add a simple HDMI CEC GPIO driver that sits on top of the cec-pin framework.
>
> While I have heard of SoCs that use the GPIO pin for CEC (apparently an
> early RockChip SoC used that), the main use-case of this driver is to
> function as a debugging tool.
>
> By connecting the CEC line to a GPIO pin on a Raspberry Pi 3 for example
> it turns it into a CEC debugger and protocol analyzer.
>
> With 'cec-ctl --monitor-pin' the CEC traffic can be analyzed.
>
> But of course it can also be used with any hardware project where the
> HDMI CEC line is hooked up to a pull-up gpio line.
>
> In addition this has (optional) support for tracing HPD changes if the
> HPD is connected to a GPIO.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

This looks nice!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
