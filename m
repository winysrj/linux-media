Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34217 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0IRMXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 08:23:30 -0400
Received: by vws3 with SMTP id 3so2156094vws.19
        for <linux-media@vger.kernel.org>; Sat, 18 Sep 2010 05:23:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19604.3118.741829.592934@valen.metzler>
References: <19593.22297.612764.560375@valen.metzler>
	<20100914144339.GA9525@linuxtv.org>
	<19600.3015.410234.367070@valen.metzler>
	<AANLkTikqJoDLRbU6269HF4UD8QoiNPrjPbcNTfZ9j38u@mail.gmail.com>
	<19604.3118.741829.592934@valen.metzler>
Date: Sat, 18 Sep 2010 17:53:29 +0530
Message-ID: <AANLkTimiqHnRzULBY3E=LmWE4oMcD40KzNk8Vn3CPdiB@mail.gmail.com>
Subject: Re: How to handle independent CA devices
From: Manu Abraham <abraham.manu@gmail.com>
To: rjkm <rjkm@metzlerbros.de>
Cc: Johannes Stezenbach <js@linuxtv.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Sep 18, 2010 at 6:17 AM, rjkm <rjkm@metzlerbros.de> wrote:
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


Maybe it wasn't very clear ... (Streaming from one input to the output
and back inside the driver what you are implementing is not what I had
in mind.)

Currently for any independant CA device what you need is a stream to
the bridge where it can route the same to the CI slot.
For a generic device capable of doing any other gimmicks also, what
you need is an input to the bridge.

So, what I was trying to say is that, let's not limit the input path
to CA alone. For explanation sale let's term in as TS_IN

The TS_In interface is a simple interface where an application can
just write to the TS_IN interface, which goes to the DVB_ringbuffer
and hence to the bridge. I think, this is all what it should do.

We have 3 application uses cases here, based on different hardware types.

1. Bridge is reading from TS_IN (from a user space application,
streams from a single TS) for sending stream to CA, the normal way
(All things are fine)

2. Bridge is reading from TS_IN (from a user space application,
streams from multiple TS's) for sending to CA. This is also same as
(1) but just that the user space application is writing a "remuxed"
stream to TS_IN

3. Bridge is reading from TS_IN (from a userspace application) The
bridge has multiple DMA channels. The bridge driver can load page
tables from another channel, whereby the bridge is routing to another
interface itself completely. This is a hardware feature, so we don't
need to get data manually in software from one interface to the other.


All this just needs the input path to be generic. An input interface
such as TS_IN can feed the stream to an onboard decoder or any other
post-processor as described with (3)

Only in the case of (2) the application really needs to do some thing
in real life, ie to "Remux". But you can omit out the application to
handle (2). Where somebody can implement it any later stage of time,
if there's any interest. I guess nGene can do (1) and (2)

So, I wonder whether we should name the interface CA itself, where
otherwise it can suit other application use cases as well. In such a
case it becomes not limited to CA alone, to put short. Implementing a
simple buffering alone (the rest of the necessities with the driver),
will make the interface generic.

Regards,
Manu
