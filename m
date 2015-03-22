Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:35447 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbbCVXOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 19:14:12 -0400
Received: by qcbkw5 with SMTP id kw5so133011150qcb.2
        for <linux-media@vger.kernel.org>; Sun, 22 Mar 2015 16:14:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1260119380.6141581427063838962.JavaMail.httpd@webmail-52.iol.local>
References: <1260119380.6141581427063838962.JavaMail.httpd@webmail-52.iol.local>
Date: Sun, 22 Mar 2015 19:14:11 -0400
Message-ID: <CAGoCfiwTW-ZjmMDKkD69pNzm4wSVf0-Fiaz5a8L5Lmsd8OwzsQ@mail.gmail.com>
Subject: Re: DVB-T Receivers Latency
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "pier.cvn@libero.it" <pier.cvn@libero.it>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pier,

On Sun, Mar 22, 2015 at 6:37 PM, pier.cvn@libero.it <pier.cvn@libero.it> wrote:
> Hello,
>
> I was wondering if anyone had any idea of how much latency a DVB-T receiver
> can add, in the path between radiofrequency and the MPEG-TS stream. I have
> 100ms of unwanted latency I can't explain in an application I'm developing, so
> I was faulting either the tx modulator or the rx demodulator latency for it. In
> my specific case I'm using a 292e as receiver, that seems to have DSP filters
> in it, and could very well be the cause of this tenth of a second delay.

The receiver itself is unlikely to add any appreciable amount of
latency.  Those devices typically only have a few kilobytes of onboard
SRAM for buffering to the USB host controller, enough to hold a couple
of dozen packets.  For a stream that is measured in Mbit/second, it's
a trivial amount of buffering.  If we're talking about latency
introduced by the DSP doing demodulation, we would be measuring
latency in microseconds, not tens or hundreds of milliseconds.

It's much more likely any buffering you are seeing which is
introducing latency is in either the driver, the DVB core, or the
application itself.  I don't know how you are measuring, but if you're
actually *watching* the video as a means of measuring latency, then
the latency is almost certainly in the MPEG decoder.  If you're using
instrumentation though that looks at the actual MPEG packets, then
it's likely you would have already ruled that out.

> I was going to buy a couple more receivers to measure the differences, but I
> was wondering if anyone had any analytic input before wasting money that way.

I wouldn't bother.  All of the USB devices are going to provide
comparable behavior.  The PCI/PCIe devices if anything are going to
have a higher latency because they might have shared memory for the
ring buffers, and thus can have a much larger FIFO.  There is likely
tuning you can do to reduce the latency, but it's all in the kernel
and software stack, not the DVB-T receiver hardware itself.

If you can describe your methodology for how you are measuring latency
in greater detail, I might be able to point you in the right
direction.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
