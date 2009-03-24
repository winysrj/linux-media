Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40070 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbZCXAX4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 20:23:56 -0400
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
From: Andy Walls <awalls@radix.net>
To: Corey Taylor <johnfivealive@yahoo.com>
Cc: Brandon Jenkins <bcjenkins@tvwhere.com>,
	linux-media@vger.kernel.org
In-Reply-To: <871136.15243.qm@web56908.mail.re3.yahoo.com>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
	 <412bdbff0903161118o2d038bdetc4d52851e35451df@mail.gmail.com>
	 <63160.21731.qm@web56906.mail.re3.yahoo.com>
	 <1237251478.3303.37.camel@palomino.walls.org>
	 <954486.20343.qm@web56908.mail.re3.yahoo.com>
	 <1237425168.3303.94.camel@palomino.walls.org>
	 <de8cad4d0903220853v4b871e91x7de6efebfb376034@mail.gmail.com>
	 <871136.15243.qm@web56908.mail.re3.yahoo.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 20:25:11 -0400
Message-Id: <1237854311.3312.30.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-03-23 at 06:52 -0700, Corey Taylor wrote:
> > Andy,
> 
> > I am noticing an improvement in pixelation by setting the bufsize to
> > 64k. I will monitor over the next week and report back. I am running 3
> > HVR-1600s and the IRQs are coming up shared with the USB which also
> > supports my HD PVR capture device. Monday nights are usually one of
> > the busier nights for recording so I will know how well this holds up.
> 
> > Thanks for the tip!
> 
> > Brandon
> 
> Hi Andy and Brandon, I too tried various different bufsizes as
> suggested and I still see very noticeable pixelation/tearing
> regardless of the setting.

Hmmm.  If you can find the time to do any of the following tests, it may
help narrow down what is (or cannot be) wrong:

1. When running a digital capture in MythTV, run "femon" in another
window.  Do you get notable variations in Signal or SNR or momentary
jumps in BER or UNC?

2. Do you have any "hiccups" or artifacts with analog video captures
(Tuner or Svideo or Composite)?

3. If analong signals come from the cable company, with the cable
connected to the analog tuner input, do any channels show any ghosting,
herring bone, or faint images of other channels?

4. With a UHF antenna connected to the digital input, and pointed to the
closest major broadcaster, does ATSC 8-VSB suffer the same artifacts as
QAM (provided you can get a decent signal)?





> I even upgraded my motherboard this past weekend to an Asus AM2+ board
> with
> Phenon II X3 CPU. Still the same problems with the card in a brand new
> setup.

OK.  CPU isn't a bottleneck anymore.  :)

It still could be a signal level, driver or kernel problem.


> I also tried modifying the cx18 source code as Andy suggested and that
> made more debug warning show up in my syslog, but still did not
> resolve the issue. Haven't tried this yet with the new motherboard
> though.



> Is it possible that this card is more sensitive to hiccups in the
> signal coming from the cable line? Or interference from other close-by
> cables and electronic equipment?

Ground loops (noise on the cable shield) can be a problem.  Hopefully
looking at femon output can give us a sense of if that is a problem.

You can always check this list of tips for improving signal quality:

http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality



> When recording/watching Live TV through MythTV, I see that ffmpeg is
> constantly outputting various errors related to the video stream. I
> can post those here if you think it's relevant.

Those errors have their source in one of 2 places:

1. Incoming buffers from the CX23418 are being missed by the cx18 driver
due to system inability to service the interrupt in a reasonable time.
The result is lost TS buffers.

2. There are periods of high bit errors or loss of lock with
demodulating the signal.  The result is lost parts of the TS.


(BTW, I do a lot of testing with ATSC 8-VSB and none with QAM - no
cable.)


> Shoud I just return this card and get one with a different chipset? Or
> do you think driver updates can solve the issue?
> 
> I'm happy to hold on to this card if it means I can contribute in some
> way to fixing the problem, if it's fixable : )


If you want you can turn on maximum debugging (the debug=511 module
option) and run a digital capture.  If you can, try and find
in /var/log/messages the timestaps that correspond roughly to about when
artifacts happen.  (With that much logging, playback performance may
just be horrible though.) 

Then zip up the likely enormous log file and send it to me.

Regards,
Andy

