Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60439 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab0IRL1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 07:27:49 -0400
Received: by qyk33 with SMTP id 33so3149306qyk.19
        for <linux-media@vger.kernel.org>; Sat, 18 Sep 2010 04:27:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19604.3118.741829.592934@valen.metzler>
References: <19593.22297.612764.560375@valen.metzler>
	<20100914144339.GA9525@linuxtv.org>
	<19600.3015.410234.367070@valen.metzler>
	<AANLkTikqJoDLRbU6269HF4UD8QoiNPrjPbcNTfZ9j38u@mail.gmail.com>
	<19604.3118.741829.592934@valen.metzler>
Date: Sat, 18 Sep 2010 12:27:48 +0100
Message-ID: <AANLkTinnHxHMtc+yJHtDYXFyFCdm__HRHU82owz1GQMg@mail.gmail.com>
Subject: Re: How to handle independent CA devices
From: James Courtier-Dutton <james.dutton@gmail.com>
To: rjkm <rjkm@metzlerbros.de>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 18 September 2010 01:47, rjkm <rjkm@metzlerbros.de> wrote:
> Manu Abraham writes:
>
>  > > You still need a mechanism to decide which tuner gets it. First one
>  > > which opens its own ca device?
>  > > Sharing the CI (multi-stream decoding) in such an automatic way
>  > > would also be complicated.
>  > > I think I will only add such a feature if there is very high demand
>  > > and rather look into the separate API solution.
>  >
>  >
>  > It would be advantageous, if we do have just a simple input path,
>  > where it is not restricted for CA/CI alone. I have some hardware over
>  > here, where it has a DMA_TO_DEVICE channel (other than for the SG
>  > table), where it can write a TS to any post-processor connected to it,
>  > such as a CA/CI device, or even a decoder, for example. In short, it
>  > could be anything, to put short.
>  >
>  > In this case, the device can accept processed stream (muxed TS for
>  > multi-TP TS) for CA, or a single TS/PS for decode on a decoder. You
>  > can flip some registers for the device, for it to read from userspace,
>  > or for that DMA channel to read from the hardware page tables of
>  > another DMA channel which is coming from the tuner.
>  >
>  > Maybe, we just need a simple mechanism/ioctl to select the CA/CI input
>  > for the stream to the bridge. ie like a MUX: a 1:n select per adapter,
>  > where the CA/CI device has 1 input and there are 'n' sources.
>
>
> It would be nice to have a more general output device. But I have
> currently no plans to support something like transparent streaming
> from one input to the output and back inside the driver.
>

Could it be handled as a transcode step?

Record the encrypted mux from the DVB card to disk first.
Then do the decrypt step offline or during playback.
During playback, you only wish to watch one channel at a time, and the
CAM will handle that.
Contra to what people think, most CAMs can decrypt the stream some
considerably time after the broadcast of the stream.
