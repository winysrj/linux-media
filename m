Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59485 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0IOEFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 00:05:15 -0400
Received: by vws3 with SMTP id 3so637519vws.19
        for <linux-media@vger.kernel.org>; Tue, 14 Sep 2010 21:05:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19600.3015.410234.367070@valen.metzler>
References: <19593.22297.612764.560375@valen.metzler>
	<20100914144339.GA9525@linuxtv.org>
	<19600.3015.410234.367070@valen.metzler>
Date: Wed, 15 Sep 2010 09:35:13 +0530
Message-ID: <AANLkTikqJoDLRbU6269HF4UD8QoiNPrjPbcNTfZ9j38u@mail.gmail.com>
Subject: Re: How to handle independent CA devices
From: Manu Abraham <abraham.manu@gmail.com>
To: rjkm <rjkm@metzlerbros.de>
Cc: Johannes Stezenbach <js@linuxtv.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Ralph,

On Wed, Sep 15, 2010 at 5:26 AM, rjkm <rjkm@metzlerbros.de> wrote:
> Hi Johannes,
>
>
> Johannes Stezenbach writes:
>  > > So, I would like to hear your opinions about how to handle such CA devices
>  > > regarding device names/types, the DVB API and user libraries.
>  >
>  > it looks like there isn't much interest from DVB developers
>  > in that topic...  I'll try...
>  >
>  >
>  > IMHO there are three sub topics:
>  >
>  > 1. be compatible with existing applications
>  >    (I guess this means: feed stream from frontend through CI transparently)
>  > 2. create an API which would also work for CI-only
>  >    devices like this Hauppauge WinTV-CI USB thingy
>  > 3. how to switch between these modes?
>  >
>  > This sec0 device is history (unused and deprecated for years), right?
>
> Yes, the former DiSEqC, etc. device. I only use it because it is is
> unused and I do not have to change anything in dvb-core this way.
> But trivial to change it or add ci0.
>
>
>  > How about the following:
>  > Rename it to ci0.  When ci0 is closed the stream is routed
>  > transparently from frontend through CI, if it's opened one needs to
>  > read/write the stream from userspace.
>
>
> You still need a mechanism to decide which tuner gets it. First one
> which opens its own ca device?
> Sharing the CI (multi-stream decoding) in such an automatic way
> would also be complicated.
> I think I will only add such a feature if there is very high demand
> and rather look into the separate API solution.


It would be advantageous, if we do have just a simple input path,
where it is not restricted for CA/CI alone. I have some hardware over
here, where it has a DMA_TO_DEVICE channel (other than for the SG
table), where it can write a TS to any post-processor connected to it,
such as a CA/CI device, or even a decoder, for example. In short, it
could be anything, to put short.

In this case, the device can accept processed stream (muxed TS for
multi-TP TS) for CA, or a single TS/PS for decode on a decoder. You
can flip some registers for the device, for it to read from userspace,
or for that DMA channel to read from the hardware page tables of
another DMA channel which is coming from the tuner.

Maybe, we just need a simple mechanism/ioctl to select the CA/CI input
for the stream to the bridge. ie like a MUX: a 1:n select per adapter,
where the CA/CI device has 1 input and there are 'n' sources.

Best Regards,
Manu
