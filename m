Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:39054 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752580AbeEGSVi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 14:21:38 -0400
Received: by mail-pl0-f68.google.com with SMTP id q18-v6so249561plr.6
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 11:21:38 -0700 (PDT)
Subject: Re: [PATCH 0/2] media: imx: add capture support for RGB565_2X8 on
 parallel bus
To: =?UTF-8?Q?Jan_L=c3=bcbbe?= <jlu@pengutronix.de>,
        linux-media@vger.kernel.org
Cc: p.zabel@pengutronix.de
References: <20180503164120.9912-1-jlu@pengutronix.de>
 <ed3906bf-9682-77c6-011a-31bd1b76be7f@gmail.com>
 <1525703026.6317.23.camel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <8003e4cf-4d35-1dd8-aa1e-3428d2f0e7d1@gmail.com>
Date: Mon, 7 May 2018 11:21:34 -0700
MIME-Version: 1.0
In-Reply-To: <1525703026.6317.23.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/07/2018 07:23 AM, Jan Lübbe wrote:
> Hi Steve,
>
> thanks for reviewing!
>
> On Sat, 2018-05-05 at 15:22 -0700, Steve Longerbeam wrote:
>> I reviewed this patch series, and while I don't have any
>> objections to the code-level changes, but my question
>> is more specifically about how the IPU/CSI deals with
>> receiving RGB565 over a parallel bus.
>>
>> My understanding was that if the CSI receives RGB565
>> over a parallel 8-bit sensor bus, the CSI_SENS_DATA_FORMAT
>> register field is programmed to RGB565, and the CSI outputs
>> ARGB8888. Then IDMAC component packing can be setup to
>> write pixels to memory as RGB565. Does that not work?
> This was our first thought too. As far as we can see in our
> experiments, that mode doesn't actually work for the parallel bus.
> Philipp's interpretation is that this mode is only intended for use
> with the MIPI-CSI2 input.

Ok, that was my suspicion on reading this as well. And it's likely
that the other sensor formats on parallel busses require pass-through,
e.g. anything other than UYVY_2x8 and YUYV_2x8 requires
pass-through.

In other words, if the sensor bus is parallel, only 8-bit bus UYVY_2x8
and YUYV_2x8 can be routed to the IC pad or component packed/unpacked
by the IDMAC pad. All other sensor formats on a parallel bus (8 or 16 
bit) must
be sent to IDMAC pad as pass-through.

I think the code can be simplified/made more readable because of this,
something like:

static inline bool is_parallel_bus(struct v4l2_fwnode_endpoint *ep)
{
         return ep->bus_type != V4L2_MBUS_CSI2;
}

static inline bool requires_pass_through(
     struct v4l2_fwnode_endpoint *ep,
     struct v4l2_mbus_framefmt *infmt,
     const struct imx_media_pixfmt *incc) {
         return incc->bayer || (is_parallel_bus(ep) && infmt->code != 
UYVY_2x8 && infmt->code != YUYV_2x8);
}


Then requires_pass_through() can be used everywhere we need to
determine the pass-though requirement.

Also, there's something wrong with the 'switch (image.pix.pixelformat) 
{...}'
block in csi_idmac_setup_channel(). Pass-though, burst size, pass-though 
bits,
should be determined by input media-bus code, not final capture V4L2 pix
format.

Steve

>> Assuming that above does not work (and indeed parallel RGB565
>> must be handled as pass-through), then I think support for capturing
>> parallel RGB555 as pass-through should be added to this series as
>> well.
> I don't have a sensor which produces RGB555, so it wouldn't be able to
> test it.

Understood, but for code readability and consistency I think the code
can be cleaned up as above.


>> Also what about RGB565 over a 16-bit parallel sensor bus? The
>> reference manual hints that perhaps this could be treated as
>> non-passthrough ("on the fly processing"), e.g. could be passed
>> on to the IC pre-processor:
>>
>>       16 bit RGB565
>>           This is the only mode that allows on the fly processing of 16 bit data. In this mode the
>>           CSI is programmed to receive 16 bit generic data. In this mode the interface is
>>           restricted to be in "non-gated mode" and the CSI#_DATA_SOURCE bit has to be set
>>           If the external device is 24bit - the user can connect a 16 bit sample of it (RGB565
>>           format). The IPU has to be configured in the same way as the case of
>>           CSI#_SENS_DATA_FORMAT=RGB565
> I've not looked at this case, as I don't have a sensor with that format
> either. :/

Ok, I was just curious if you knew anything more about this. Let's
ignore it :)

Steve
