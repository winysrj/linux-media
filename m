Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:41825 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751445Ab2JSRRe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 13:17:34 -0400
Date: Fri, 19 Oct 2012 10:18:27 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Cc: intel-gfx@lists.freedesktop.org, bhelgaas@google.com,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	linux-pci@vger.kernel.org
Subject: Re: [Intel-gfx] GPU RC6 breaks PCIe to PCI bridge connected to CPU
 PCIe slot on SandyBridge systems
Message-ID: <20121019101827.2362eaf1@jbarnes-desktop>
In-Reply-To: <2233216.7bl6QCud67@f17simon>
References: <1704067.2NCOGYajHN@f17simon>
	<CAKMK7uHHn0H1usv=7Msdvg6vW4PDRaFvtRG7m=c9ENw+c_PE4g@mail.gmail.com>
	<3896332.1fABn9rFR8@f17simon>
	<2233216.7bl6QCud67@f17simon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RC6 plus CPU C6 would also put the whole package into a low power
state.  It's possible we're missing some initialization to keep things
up for other system activity like bus mastering on PCIe?

Just thinking out loud here, unfortunately I don't know of any settings
that might control this.  But package level changes are one other
thing that would be affected by RC6 enabling.

Jesse

On Fri, 19 Oct 2012 17:10:17 +0100
Simon Farnsworth <simon.farnsworth@onelan.co.uk> wrote:

> Mauro, Linux-Media
> 
> I have an issue where an SAA7134-based TV capture card connected via a PCIe to
> PCI bridge chip works when the GPU is kept out of RC6 state, but sometimes
> "skips" updating lines of the capture when the GPU is in RC6. We've confirmed
> that a CX23418 based chip doesn't have the problem, so the question is whether
> the SAA7134 and the saa7134 driver are at fault, or whether it's the PCIe bus.
> 
> This manifests as a regression, as I had no problems with kernel 3.3 (which
> never enabled RC6 on the Intel GPU), but I do have problems with 3.5 and with
> current Linus git master. I'm happy to try anything, 
> 
> I've attached lspci -vvxxxxx output (suitable for feeding to lspci -F) for
> when the corruption is present (lspci.faulty) and when it's not
> (lspci.working). The speculation is that the SAA7134 is somehow more
> sensitive to the changes in timings that RC6 introduces than the CX23418, and
> that someone who understands the saa7134 driver might be able to make it less
> sensitive.
> 
> Details of the most recent tests follow:
> 
> On Friday 19 October 2012 15:52:32 Simon Farnsworth wrote:
> > On Friday 19 October 2012 16:26:08 Daniel Vetter wrote:
> > > Ok, this is really freaky stuff. One thing to triage: Is it just
> > > sufficient to put the gpu into rc6 to corrupt the dma transfers, or is
> > > some light X/gpu load required? In either case, rc6 being able to
> > > corrupt random dma transfers (or at least prevent them from reaching
> > > their destination) would be a fitting explanation for the leftover rc6
> > > issues on snb ...
> > > 
> > In an attempt to have this happen with the GPU as idle as possible, I did the
> > following (note that I'm on a gigabit Ethernet segment, so I can burn network
> > bandwidth while testing):
> > 
> > 1. Start X.org with -noreset, and don't start any X clients.
> > 2. Run "xset dpms force off ; xrandr --output DP2 --off" (DP2 is the connected output).
> > 3. On the affected machine, run "gst-launch v4l2src ! gdppay ! tcpclientsink host=f17simon port=65512"
> > 4. On my desktop, run "gst-launch tcpserversrc host=0.0.0.0 port=65512 ! gdpdepay ! xvimagesink"
> > 
> > I see the corruption continue to happen, even though the GPU should be idle
> > and in RC6 state most of the time (confirmed by reading
> > /sys/class/drm/card0/power/rc6_residency_ms and seeing it increase between
> > reads). When I run intel_forcewaked from intel_gpu_tools, the corruption goes
> > away, and I can confirm by reading /sys/class/drm/card0/power/rc6_residency_ms
> > that the GPU does not enter RC6. Killing intel_forcewaked makes the corruption
> > reappear while streaming over the network (X11 idle).
> > 
> As a follow up - Daniel requested via IRC that I try with a different capture
> card; I've switched to a HVR-1600 (cx18 driver instead of saa7134), and I've
> also tried with the X server forcibly quiesced via kill -STOP.
> 
> Quiescing the X server doesn't help; however, the HVR-1600 does not show the
> problem. This suggests that it's an interaction between the SAA7134 based TV
> card, the bridge chip, and the different PCIe timings when the GPU is in RC6.


-- 
Jesse Barnes, Intel Open Source Technology Center
