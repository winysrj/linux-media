Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:55364 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750779AbdH2RCp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 13:02:45 -0400
Subject: Re: [PATCH v4 04/21] doc: media/v4l-drivers: Add Qualcomm Camera
 Subsystem driver document
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
 <1502199018-28250-5-git-send-email-todor.tomov@linaro.org>
 <de3c02a1-5c04-977d-fd51-186a5d39c32a@zonque.org>
 <7483f716-4240-899f-f9c5-23c6408f39ff@linaro.org>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <97228890-39c1-6c85-ed74-0e1e62b83868@zonque.org>
Date: Tue, 29 Aug 2017 19:02:42 +0200
MIME-Version: 1.0
In-Reply-To: <7483f716-4240-899f-f9c5-23c6408f39ff@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On 08/28/2017 09:10 AM, Todor Tomov wrote:
> On 25.08.2017 17:10, Daniel Mack wrote:
>> I have a userspace test setup that works fine for USB webcams, but when
>> operating on any of the video devices exposed by this driver, the
>> lowlevel functions such as .s_power of the ISPIF, CSID, CSIPHY and the
>> sensor driver layers aren't called into.
> 
> Have you activated the media controller links? The s_power is called
> when the subdev is part of a pipeline in which the video device node
> is opened. You can see example configurations for the Qualcomm CAMSS
> driver on:
> https://github.com/96boards/documentation/blob/master/ConsumerEdition/DragonBoard-410c/Guides/CameraModule.md
> This will probably answer most of your questions.

Yes, it does, thank you! I didn't expect the necessity for any manual
setup on this level due to this sentence in the documentation:

> Runtime configuration of the hardware (updating settings while
> streaming) is not required to implement the currently supported
> functionality.

I hence assumed there is a fixed mapping that is partly derived from DTS
information etc. Anyway, this seems to work now, so thanks a bunch for
the pointer!

Another thing that confused me for a while is the CCI driver, which also
exposes media pads. I have the cameras connected to a regular I2C bus
however, and it seems to work fine. That just leaves the question why
this CCI driver exists at all.

I also have some more questions, but they are even more platform
specific, so I'll rather post them in the 96boards forum.


Thanks again!
Daniel
