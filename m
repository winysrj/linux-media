Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36080 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752224AbdDLO3j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 10:29:39 -0400
Received: by mail-oi0-f44.google.com with SMTP id r203so33402391oib.3
        for <linux-media@vger.kernel.org>; Wed, 12 Apr 2017 07:29:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7f1ddce2-e3b9-97d2-d816-55f47c76d087@xs4all.nl>
References: <CAF_dkJAwwj0mpOztkTNTrDC1YQkgh=HvZGh=tv3SYsuvUzTb+g@mail.gmail.com>
 <2ea495f2-022d-a9ee-11a0-28fbcba5db57@xs4all.nl> <CAF_dkJCqcVuSsey697OkA6-E563qEr=fYFWM26V1ZOSdnu4RGQ@mail.gmail.com>
 <7f1ddce2-e3b9-97d2-d816-55f47c76d087@xs4all.nl>
From: Patrick Doyle <wpdster@gmail.com>
Date: Wed, 12 Apr 2017 10:29:08 -0400
Message-ID: <CAF_dkJCm3mqj5koZ-yWsmmJ9gJxMFsdzPEJBNztOxcng6swB9A@mail.gmail.com>
Subject: Re: Looking for device driver advice
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you again Hans.

On Wed, Apr 12, 2017 at 9:58 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 04/12/2017 03:13 PM, Patrick Doyle wrote:
>> The SAMA5 has a downsampler built into its LCD engine.  Suppose I
>> wanted to treat that downsampler as an independent device and pass
>> image buffers through that downsampler (the LCD display output is
>> disabled in hardware when the device is configured in this mode)....
>> do you have any recommendations as to how I might structure a device
>> driver to do that.  At it's core, it would DMA a buffer from memory,
>> through the downsampler, and back into memory.  Is that something I
>> might also wire in as a pseudo-subdev of the ISC?  Or is there a
>> better abstraction for arbitrary image processing pipeline elements?
>
> I think this is out of scope of V4L2. Check with Atmel/Microchip.

The V4L2 tie-in is in answering the question: Is there a standard V4L2
way to perform arbitrary video processing functions (such as
downsampling) with an arbitrary device.  If the answer is "no", that's
fine.  If the answer is, "yes, here is how Xilinx does it for their IP
modules", then I'll go look at some Xilinx stuff (which I'm going to
do anyway).

--wpd
