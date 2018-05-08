Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:42411 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755790AbeEHSXw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 14:23:52 -0400
Received: by mail-pl0-f68.google.com with SMTP id u6-v6so2707574pls.9
        for <linux-media@vger.kernel.org>; Tue, 08 May 2018 11:23:51 -0700 (PDT)
Subject: Re: [PATCH 0/2] media: imx: add capture support for RGB565_2X8 on
 parallel bus
To: =?UTF-8?Q?Jan_L=c3=bcbbe?= <jlu@pengutronix.de>,
        linux-media@vger.kernel.org
Cc: p.zabel@pengutronix.de
References: <20180503164120.9912-1-jlu@pengutronix.de>
 <ed3906bf-9682-77c6-011a-31bd1b76be7f@gmail.com>
 <1525703026.6317.23.camel@pengutronix.de>
 <8003e4cf-4d35-1dd8-aa1e-3428d2f0e7d1@gmail.com>
 <1525788814.6317.28.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <a0b447df-b805-b14b-8a98-e2b595efa161@gmail.com>
Date: Tue, 8 May 2018 11:23:46 -0700
MIME-Version: 1.0
In-Reply-To: <1525788814.6317.28.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,


On 05/08/2018 07:13 AM, Jan Lübbe wrote:
> Hi,
>
> On Mon, 2018-05-07 at 11:21 -0700, Steve Longerbeam wrote:
>> In other words, if the sensor bus is parallel, only 8-bit bus UYVY_2x8
>> and YUYV_2x8 can be routed to the IC pad or component packed/unpacked
>> by the IDMAC pad. All other sensor formats on a parallel bus (8 or 16
>> bit) must be sent to IDMAC pad as pass-through.
>>
>> I think the code can be simplified/made more readable because of this,
>> something like:
>>
>> static inline bool is_parallel_bus(struct v4l2_fwnode_endpoint *ep)
>> {
>>           return ep->bus_type != V4L2_MBUS_CSI2;
>> }
>>
>> static inline bool requires_pass_through(
>>       struct v4l2_fwnode_endpoint *ep,
>>       struct v4l2_mbus_framefmt *infmt,
>>       const struct imx_media_pixfmt *incc) {
>>           return incc->bayer || (is_parallel_bus(ep) && infmt->code !=
>> UYVY_2x8 && infmt->code != YUYV_2x8);
>> }
>>
>>
>> Then requires_pass_through() can be used everywhere we need to
>> determine the pass-though requirement.
> OK, i've added these helper functions. In csi_link_validate() we don't
> have the infmt handy, but as the downstream elements check if they have
> a native format anyway, this check is redundant and so i've dropped it.

Makes sense.

>
>> Also, there's something wrong with the 'switch (image.pix.pixelformat)
>> {...}' block in csi_idmac_setup_channel(). Pass-though, burst size, pass-though
>> bits, should be determined by input media-bus code, not final capture V4L2 pix
>> format.
> I just followed the existing code there, which already configures all
> of these.

Sorry never mind, I forgot that there is a need to check for planar formats
here.

>>>> Assuming that above does not work (and indeed parallel RGB565
>>>> must be handled as pass-through), then I think support for capturing
>>>> parallel RGB555 as pass-through should be added to this series as
>>>> well.
>>> I don't have a sensor which produces RGB555, so it wouldn't be able to
>>> test it.
>> Understood, but for code readability and consistency I think the code
>> can be cleaned up as above.
> Yes, i've changed that for v2.
>
>

The new macros can be used in more places. I will respond to v2 patch.

Steve
