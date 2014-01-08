Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:59874 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbaAHRFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 12:05:19 -0500
To: undisclosed-recipients:;
Date: Wed, 08 Jan 2014 15:05:12 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	jean-philippe francois <jp.francois@cynove.com>,
	linux-usb@vger.kernel.org, LMML <linux-media@vger.kernel.org>,
	Shuah Khan <shuah.kh@samsung.com>
Subject: Re: Isochronous transfer error on USB3
Message-id: <20140108150512.4e9e6f01@samsung.com>
In-reply-to: <20140108143128.618bfca2@samsung.com>
References: <CAGGh5h3TCYiCuubm27h5O7DLknwU9-fUqMjxk_pFEaiXW61mGw@mail.gmail.com>
 <20130311230028.GE5412@xanatos>
 <CAGGh5h1wPQWtvP0rHSjsC-jLJwEX1Leb8eYgK6adP2Hc5skn2Q@mail.gmail.com>
 <CAGGh5h3V5=dGo3dARyrwp9ERhcK_1Nty_gTX27qEr1ZEdQoATg@mail.gmail.com>
 <20130318165124.GD17414@xanatos>
 <20131229025440.526a9feb.m.chehab@samsung.com> <20140102220722.GC9621@xanatos>
 <20140108143128.618bfca2@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 08 Jan 2014 14:31:28 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Thu, 02 Jan 2014 14:07:22 -0800
> Sarah Sharp <sarah.a.sharp@linux.intel.com> escreveu:
> 
> > On Sun, Dec 29, 2013 at 02:54:40AM -0200, Mauro Carvalho Chehab wrote:
> > > It seems that usb_unlink_urb() is causing troubles with xHCI: the
> > > endpoint stops streaming, but, after that, it doesn't start again,
> > > and lots of debug messages are produced. I emailed you the full log
> > > after start streaming in priv (too big for vger), but basically, 
> > > it produces:
> > > 
> > > [ 1635.754546] xhci_hcd 0000:00:14.0: Endpoint 0x81 not halted, refusing to reset.
> > > [ 1635.754562] xhci_hcd 0000:00:14.0: Endpoint 0x82 not halted, refusing to reset.
> > > [ 1635.754577] xhci_hcd 0000:00:14.0: Endpoint 0x83 not halted, refusing to reset.
> > > [ 1635.754594] xhci_hcd 0000:00:14.0: Endpoint 0x84 not halted, refusing to reset.
> > 
> > I think that's due to the driver (or userspace) attempting to reset the
> > endpoint when it didn't actually receive a stall (-EPIPE) status from an
> > URB.  When that happens, the xHCI host controller endpoint "toggle" bits
> > get out of sync with the device toggle bits, and the result is that all
> > transfers will fail to the endpoint from then on until you switch
> > alternate interface settings or unplug/replug the device.
> > 
> > Try this patch:
> > 
> > http://marc.info/?l=linux-usb&m=138116117104619&w=2
> > 
> > It's still under RFC, and I know it has race conditions, but it will let
> > you quickly test whether this fixes your issue.
> 
> Didn't work fine, or at least it didn't solve all the problems. Also, it
> started to cause OOPSes due to the race conditions.
> 
> > 
> > This has been a long-standing xHCI driver bug.  I asked my OPW intern to
> > work on the patch to fix it, but she may be a bit busy with her new job
> > to finish up the RFC.  I'll probably have to take over finishing the
> > patch, if this turns out to be your issue.
> > 
> > > (Not sure why it is trying to stop all endpoints - as just one endpoint was
> > > requested to restart).
> > 
> > Something is calling into usb_clear_halt() with all the endpoints.
> > Userspace, perhaps? 
> 
> No, userspace is not doing it. The userspace doesn't even know that this
> device is USB (and were written at the time that all media drivers were
> PCI only - so it doesn't have any USB specific call on it).
> 
> > You could add WARN() calls to usb_clear_halt() to
> > see what code is resetting the endpoints.  In any case, it's not part of
> > the USB core code to change configuration or alt settings, since I don't
> > see any xHCI driver output from the endpoint bandwidth code in this
> > chunk of the dmesg you sent:
> 
> The em28xx-audio.c driver may need to call usb_set_interface() while
> the video is still streaming, in order to unmute the audio. That happens
> when the audio device is opened.
> 
> With EHCI, this works properly.
> 
> > [ 1649.640783] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xb41e8580 (dma).
> > [ 1649.640784] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xb41e8580
> > [ 1649.643159] xhci_hcd 0000:00:14.0: Endpoint 0x81 not halted, refusing to reset.
> > [ 1649.643188] xhci_hcd 0000:00:14.0: Endpoint 0x82 not halted, refusing to reset.
> > [ 1649.643215] xhci_hcd 0000:00:14.0: Endpoint 0x83 not halted, refusing to reset.
> > [ 1649.643239] xhci_hcd 0000:00:14.0: Endpoint 0x84 not halted, refusing to reset.
> > [ 1649.735539] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
> > 
> > Sarah Sharp
> 
> Btw, sometimes, I get such logs:
> 
> [  646.192273] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> [  646.192292] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> [  646.192311] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> [  646.192329] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> [  646.192351] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> [  646.192376] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> 
> After adding some debug at em28xx-audio, triggering alsa trigger start
> events, I'm getting those:
> 
> [ 3078.971224] snd_em28xx_capture_trigger: start capture
> [ 3078.971284] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
> [ 3078.971311] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 4 segments
> [ 3078.971350] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
> [ 3078.971387] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 8 segments
> [ 3079.034626] em28xx_audio_isocirq, 64 packets (first one with size 12)
> 
> Here, some audio data arrives.
> 
> [ 3079.034665] snd_em28xx_capture_trigger: stop capture
> 
> It seems, however, that this didn't arrive in time, and causes an alsa
> buffer underrun. So, it cancels the existing URBs.
> 
> PS.: Even with EHCI, it causes a few ALSA underruns before it gets steady.
> I suspect that this is due to em28xx time to synchronize audio and video
> streams.
> 
> [ 3079.034736] xhci_hcd 0000:00:14.0: Cancel URB ffff880207900000, dev 4, ep 0x83, starting at offset 0x1ffb13850
> [ 3079.034755] xhci_hcd 0000:00:14.0: // Ding dong!
> [ 3079.034783] xhci_hcd 0000:00:14.0: Stopped on Transfer TRB
> [ 3079.034790] snd_em28xx_capture_trigger: start capture
> 
> While xHCI is still canceling the URBs, a new trigger happens, and it
> calls usb_submit_urb().
> 
> [ 3079.034819] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x1ffb13850 (dma).
> [ 3079.034835] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x1ffb13850
> ...
> [ 3079.036341] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xb624b850 (dma).
> [ 3079.036352] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xb624b850
> [ 3079.036365] em28xx_audio_isocirq, 64 packets (first one with size 0)
> 
> But xHCI only finishes cancelling the first URB here...
> 
> [ 3079.036382] xhci_hcd 0000:00:14.0: Cancel URB ffff880207900800, dev 4, ep 0x83, starting at offset 0x1ff937010
> ...
> [ 3079.043158] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x1ffb13840
> [ 3079.043170] em28xx_audio_isocirq, 64 packets (first one with size 0)
> 
> And only here, it finishes to cancel the entire operation.
> 
> [ 3079.043231] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
> [ 3079.043299] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 16 segments
> [ 3079.428996] em28xx_audio_isocirq, 64 packets (first one with size 64)
> 
> Finally, after ~400ms after the new usb_submit_urb(), the first audio packet
> appears...
> 
> [ 3079.429069] snd_em28xx_capture_trigger: stop capture
> 
> However, this is not fast enough to avoid ALSA buffer underrun. So,
> the driver cancels the existing URBs...
> 
> [ 3079.429204] xhci_hcd 0000:00:14.0: Cancel URB ffff880207900000, dev 4, ep 0x83, starting at offset 0xc5a7f4b0
> [ 3079.429241] snd_em28xx_capture_trigger: start capture
> 
> And submits a new set.
> 
> Not sure how to fix it.

Hmm... calling xawtv with a very high-latency alsa buffer works (the
default latency is 30ms, with works fine with an EHCI port):

	$ xawtv --alsa-latency 500

Of course, a half-second latency means that audio and video won't be 
properly synchronized, but at least audio works.

I'll turn off the USB logs and do more experiences with the latency,
in order to have an idea on how faster is EHCI to handle the
ISOC requests, when compared with xHCI.

Regards,
Mauro
-- 

Cheers,
Mauro
