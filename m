Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:34835 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZATC3K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 21:29:10 -0500
Subject: Re: Regression since 2.6.25 kernel: Crash of userspace program
 leaves DVB device unusable
From: Andy Walls <awalls@radix.net>
To: Brendon Higgins <blhiggins@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200901191943.06631.blhiggins@gmail.com>
References: <200901031200.56314.blhiggins@gmail.com>
	 <200901191337.31272.blhiggins@gmail.com>
	 <1232338898.3242.27.camel@palomino.walls.org>
	 <200901191943.06631.blhiggins@gmail.com>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 21:29:31 -0500
Message-Id: <1232418571.22378.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-01-19 at 19:43 +1000, Brendon Higgins wrote:
> Andy Walls wrote (Monday 19 January 2009):
> > On Mon, 2009-01-19 at 13:37 +1000, Brendon Higgins wrote:
> > > > [snip]
> >
> > Well, you have the clues actually; they're in your log files.
> 
> Thanks Andy for prompting me to look at things again. I've discovered 
> something interesting about the way runvdr, a script which tries to keep vdr 
> alive (might be Debian custom, I'm not sure), interacts with the modules. When 
> vdr crashes, runvdr attempts to remove and re-load the dvb modules before 
> restarting vdr. Presumably this is a workaround for any modules left in a bad 
> state.
> 
> Interestingly though, the script doesn't take the module dependency tree into 
> account, only the first level branches, and so most of its rmmod commands fail 
> since the modules are in use by other modules. In my case it attempts to 
> remove videobuf_dvb, cx88_dvb, and dvb_core, in that order. Only rmmod 
> cx88_dvb succeeds.
> 
> Now the really interesting part: soon after that, runvdr tries to modprobe all 
> those modules back in again. Trying to modprobe videobuf_dvb and dvb_core does 
> nothing since they weren't unloaded. But trying to modprobe cx88_dvb fails: 
> "FATAL: Error inserting cx88_dvb 
> (/lib/modules/2.6.28/kernel/drivers/media/video/cx88/cx88-dvb.ko): No such 
> device"
> 
> Only after "rmmod cx8802" can cx88_dvb be loaded successfully.
> 
> Finally I've found a way to reproduce the bug on command! Hurrah!
> 
> Summary procedure, starting with a working dvb:
> 1) rmmod cx88_dvb
> 2) modprobe cx88_dvb
> Error: No such device.
> 3) rmmod cx8802
> 4) modprobe cx88_dvb
> Success (and cx8802 is pulled in automatically)
> 
> So it seems there might be some sort of module interdependency not being taken 
> care of. 

Yes.  Mauro did some work to decouple these modules in very recent
changes.  I did some follow-up changes to fix frontend allocations.  You
may want to try the latest v4l-dvb repository.


> I'll try to report the runvdr tree problem to the relevant place 
> later.
> 
> > At the time of the crash, what shows up in dmesg, /var/log/messages, and
> > any log that VDR creates?
> 
> Here's what's in /var/log/syslog when I perform the above procedure (with my 
> best-guess labels as to when I did what):
> 
> rmmod cx88_dvb:
> Jan 19 19:24:27 phi kernel: [15162.725955] cx88/2: unregistering cx8802 
> driver, type: dvb access: shared
> Jan 19 19:24:27 phi kernel: [15162.725967] cx88[0]/2: subsystem: 18ac:db10, 
> board: DViCO FusionHDTV DVB-T Plus [card=21]
> Jan 19 19:24:27 phi kernel: [15162.725972] cx88[0]/2-dvb: cx8802_dvb_remove
> 
> modprobe cx88_dvb:
> Jan 19 19:24:32 phi kernel: [15167.399736] cx88/2: cx2388x dvb driver version 
> 0.0.6 loaded
> Jan 19 19:24:32 phi kernel: [15167.399744] cx88/2: registering cx8802 driver, 
> type: dvb access: shared
> Jan 19 19:24:32 phi kernel: [15167.399752] cx88[0]/2: subsystem: 18ac:db10, 
> board: DViCO FusionHDTV DVB-T Plus [card=21]
> Jan 19 19:24:32 phi kernel: [15167.399757] cx88[0]/2-dvb: cx8802_dvb_probe
> Jan 19 19:24:32 phi kernel: [15167.399761] cx88[0]/2-dvb:  ->being probed by 
> Card=21 Name=cx88[0], PCI 01:06
> Jan 19 19:24:32 phi kernel: [15167.399766] cx88[0]/2: cx2388x based DVB/ATSC 
> card
> Jan 19 19:24:32 phi kernel: [15167.399771] cx8802_dvb_probe() failed to get 
> frontend(1)

This happens in one of the functions that was recently modified.  Trying
the latest v4l-dvb repo may give different results.  I don't have any
cx8802 hardware, so I can't test your procedure.

> Jan 19 19:24:32 phi kernel: [15167.399775] cx88[0]/2: dvb_register failed (err 
> = -22)
> Jan 19 19:24:32 phi kernel: [15167.399779] cx88[0]/2: cx8802 probe failed, err 
> = -22





> rmmod cx8802:
> Jan 19 19:25:06 phi kernel: [15200.890797] cx88-mpeg driver manager 
> 0000:01:06.2: PCI INT A disabled
> 
> modprobe cx88_dvb:
> Jan 19 19:25:07 phi kernel: [15201.996410] cx88/2: cx2388x MPEG-TS Driver 
> Manager version 0.0.6 loaded
> Jan 19 19:25:07 phi kernel: [15201.996464] cx88[0]/2: cx2388x 8802 Driver 
> Manager
> Jan 19 19:25:07 phi kernel: [15201.996489] cx88-mpeg driver manager 
> 0000:01:06.2: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
> Jan 19 19:25:07 phi kernel: [15201.996502] cx88[0]/2: found at 0000:01:06.2, 
> rev: 5, irq: 16, latency: 32, mmio: 0xfb000000
> Jan 19 19:25:07 phi kernel: [15201.996516] cx8802_probe() allocating 1 
> frontend(s)
> Jan 19 19:25:07 phi kernel: [15202.001647] cx88/2: cx2388x dvb driver version 
> 0.0.6 loaded
> Jan 19 19:25:07 phi kernel: [15202.001655] cx88/2: registering cx8802 driver, 
> type: dvb access: shared
> Jan 19 19:25:07 phi kernel: [15202.001661] cx88[0]/2: subsystem: 18ac:db10, 
> board: DViCO FusionHDTV DVB-T Plus [card=21]
> Jan 19 19:25:07 phi kernel: [15202.001667] cx88[0]/2-dvb: cx8802_dvb_probe
> Jan 19 19:25:07 phi kernel: [15202.001671] cx88[0]/2-dvb:  ->being probed by 
> Card=21 Name=cx88[0], PCI 01:06
> Jan 19 19:25:07 phi kernel: [15202.001676] cx88[0]/2: cx2388x based DVB/ATSC 
> card
> Jan 19 19:25:07 phi kernel: [15202.002518] DVB: registering new adapter 
> (cx88[0])
> Jan 19 19:25:07 phi kernel: [15202.002526] DVB: registering adapter 0 frontend 
> 0 (Zarlink MT352 DVB-T)...
> 
> Note the "failed to get frontend(1)" in the first modprobe.
> 
> > Since modprobe after the crash failed with -ENODEV ["...cx88-dvb.ko): No
> > such device], a quick grep through cx88-dvb.c in the source shows that
> > that can only happen in a few places.  It should be easy to spot in the
> > logs.  Adding an
> >
> > 	options cx88_dvb debug=1
> >
> > line to /etc/modprobe.conf would make things easier to see in the logs
> > as well.
> 
> Thanks, I didn't know about that. The above syslog info ought to have been 
> produced with that option in effect.
> 
> > Also what is the source of your cx88 driver: Debian Testing or the
> > v4l-dvb repo?
> 
> It comes in the stock kernels that I built and tested (2.6.26 was the Debian 
> pre-packaged kernel, the others were built from kernel.org source via make-
> kpkg).
> 
> > > Or care?
> >
> > The issue is usually not one of caring, but one of having
> > time, the specific hardware, and ability to reporduce the problem.
> 
> Of course. When your first two emails about a problem get no response, it 
> starts looking like a plausible explanation, you know?

Yes.

Now that you have repeatable steps someone with hardware should be able
to fix the problem.  I don't have cx8802 hardware.

Regards,
Andy


> Peace,
> Brendon
> 

