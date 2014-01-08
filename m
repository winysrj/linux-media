Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:11494 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAHSsJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 13:48:09 -0500
Date: Wed, 08 Jan 2014 16:48:00 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
	alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Fw: Isochronous transfer error on USB3
Message-id: <20140108164800.70ea4169@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans/Takashi,

I'm getting an weird behavior with em28xx, especially when the device
is connected into an audio port.

I'm using, on my tests, an em28xx HVR-950 device, using this tree:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/em28xx-v4l2-v6
Where the alsa driver is at:
	http://git.linuxtv.org/mchehab/experimental.git/blob/refs/heads/em28xx-v4l2-v6:/drivers/media/usb/em28xx/em28xx-audio.c

I'm testing it with xawtv3 (http://git.linuxtv.org/xawtv3.git). The
ALSA userspace code there is at:
	http://git.linuxtv.org/xawtv3.git/blob/HEAD:/common/alsa_stream.c

What happens is that, when I require xawtv3 to use any latency lower 
than 65 ms, the audio doesn't work, as it gets lots of underruns per
second. 

FYI, em28xx works at a 48000 KHz sampling rate, and its PM capture Hw
is described as:

static struct snd_pcm_hardware snd_em28xx_hw_capture = {
	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
		SNDRV_PCM_INFO_MMAP           |
		SNDRV_PCM_INFO_INTERLEAVED    |
		SNDRV_PCM_INFO_BATCH	      |
		SNDRV_PCM_INFO_MMAP_VALID,

	.formats = SNDRV_PCM_FMTBIT_S16_LE,

	.rates = SNDRV_PCM_RATE_CONTINUOUS | SNDRV_PCM_RATE_KNOT,

	.rate_min = 48000,
	.rate_max = 48000,
	.channels_min = 2,
	.channels_max = 2,
	.buffer_bytes_max = 62720 * 8,	/* just about the value in usbaudio.c */
	.period_bytes_min = 64,		/* 12544/2, */
	.period_bytes_max = 12544,
	.periods_min = 2,
	.periods_max = 98,		/* 12544, */
};

On my tests, I experimentally discovered that the minimal latency to
avoid ALSA library underruns is:
	- 65ms when using xHCI;
	- 25ms when using EHCI.

Any latency lower than that causes lots of overruns. Very high
latency also causes overruns (but on a lower rate, as the period
is bigger).

I'm wandering if is there anything that could be done either at Kernel
side or at userspace side to automatically get some configuration that
works as-is, without requiring the user to play with the latency parameter
by hand.

The alsa-info data is enclosed.

Thank you!
Mauro

PS.: I'm still trying to understand why the minimal allowed latency is
different when using xHCI, but I suspect that it is because it uses a
different urb->interval than EHCI.

Forwarded message:

Date: Wed, 08 Jan 2014 16:03:51 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: jean-philippe francois <jp.francois@cynove.com>, linux-usb@vger.kernel.org, LMML <linux-media@vger.kernel.org>, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: Isochronous transfer error on USB3


Em Wed, 08 Jan 2014 15:05:12 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Wed, 08 Jan 2014 14:31:28 -0200
> Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
> 
> > Em Thu, 02 Jan 2014 14:07:22 -0800
> > Sarah Sharp <sarah.a.sharp@linux.intel.com> escreveu:
> > 
> > > On Sun, Dec 29, 2013 at 02:54:40AM -0200, Mauro Carvalho Chehab wrote:
> > > > It seems that usb_unlink_urb() is causing troubles with xHCI: the
> > > > endpoint stops streaming, but, after that, it doesn't start again,
> > > > and lots of debug messages are produced. I emailed you the full log
> > > > after start streaming in priv (too big for vger), but basically, 
> > > > it produces:
> > > > 
> > > > [ 1635.754546] xhci_hcd 0000:00:14.0: Endpoint 0x81 not halted, refusing to reset.
> > > > [ 1635.754562] xhci_hcd 0000:00:14.0: Endpoint 0x82 not halted, refusing to reset.
> > > > [ 1635.754577] xhci_hcd 0000:00:14.0: Endpoint 0x83 not halted, refusing to reset.
> > > > [ 1635.754594] xhci_hcd 0000:00:14.0: Endpoint 0x84 not halted, refusing to reset.
> > > 
> > > I think that's due to the driver (or userspace) attempting to reset the
> > > endpoint when it didn't actually receive a stall (-EPIPE) status from an
> > > URB.  When that happens, the xHCI host controller endpoint "toggle" bits
> > > get out of sync with the device toggle bits, and the result is that all
> > > transfers will fail to the endpoint from then on until you switch
> > > alternate interface settings or unplug/replug the device.
> > > 
> > > Try this patch:
> > > 
> > > http://marc.info/?l=linux-usb&m=138116117104619&w=2
> > > 
> > > It's still under RFC, and I know it has race conditions, but it will let
> > > you quickly test whether this fixes your issue.
> > 
> > Didn't work fine, or at least it didn't solve all the problems. Also, it
> > started to cause OOPSes due to the race conditions.
> > 
> > > 
> > > This has been a long-standing xHCI driver bug.  I asked my OPW intern to
> > > work on the patch to fix it, but she may be a bit busy with her new job
> > > to finish up the RFC.  I'll probably have to take over finishing the
> > > patch, if this turns out to be your issue.
> > > 
> > > > (Not sure why it is trying to stop all endpoints - as just one endpoint was
> > > > requested to restart).
> > > 
> > > Something is calling into usb_clear_halt() with all the endpoints.
> > > Userspace, perhaps? 
> > 
> > No, userspace is not doing it. The userspace doesn't even know that this
> > device is USB (and were written at the time that all media drivers were
> > PCI only - so it doesn't have any USB specific call on it).
> > 
> > > You could add WARN() calls to usb_clear_halt() to
> > > see what code is resetting the endpoints.  In any case, it's not part of
> > > the USB core code to change configuration or alt settings, since I don't
> > > see any xHCI driver output from the endpoint bandwidth code in this
> > > chunk of the dmesg you sent:
> > 
> > The em28xx-audio.c driver may need to call usb_set_interface() while
> > the video is still streaming, in order to unmute the audio. That happens
> > when the audio device is opened.
> > 
> > With EHCI, this works properly.
> > 
> > > [ 1649.640783] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xb41e8580 (dma).
> > > [ 1649.640784] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xb41e8580
> > > [ 1649.643159] xhci_hcd 0000:00:14.0: Endpoint 0x81 not halted, refusing to reset.
> > > [ 1649.643188] xhci_hcd 0000:00:14.0: Endpoint 0x82 not halted, refusing to reset.
> > > [ 1649.643215] xhci_hcd 0000:00:14.0: Endpoint 0x83 not halted, refusing to reset.
> > > [ 1649.643239] xhci_hcd 0000:00:14.0: Endpoint 0x84 not halted, refusing to reset.
> > > [ 1649.735539] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
> > > 
> > > Sarah Sharp
> > 
> > Btw, sometimes, I get such logs:
> > 
> > [  646.192273] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> > [  646.192292] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> > [  646.192311] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> > [  646.192329] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> > [  646.192351] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> > [  646.192376] xhci_hcd 0000:00:14.0: Miss service interval error, set skip flag
> > 
> > After adding some debug at em28xx-audio, triggering alsa trigger start
> > events, I'm getting those:
> > 
> > [ 3078.971224] snd_em28xx_capture_trigger: start capture
> > [ 3078.971284] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
> > [ 3078.971311] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 4 segments
> > [ 3078.971350] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
> > [ 3078.971387] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 8 segments
> > [ 3079.034626] em28xx_audio_isocirq, 64 packets (first one with size 12)
> > 
> > Here, some audio data arrives.
> > 
> > [ 3079.034665] snd_em28xx_capture_trigger: stop capture
> > 
> > It seems, however, that this didn't arrive in time, and causes an alsa
> > buffer underrun. So, it cancels the existing URBs.
> > 
> > PS.: Even with EHCI, it causes a few ALSA underruns before it gets steady.
> > I suspect that this is due to em28xx time to synchronize audio and video
> > streams.
> > 
> > [ 3079.034736] xhci_hcd 0000:00:14.0: Cancel URB ffff880207900000, dev 4, ep 0x83, starting at offset 0x1ffb13850
> > [ 3079.034755] xhci_hcd 0000:00:14.0: // Ding dong!
> > [ 3079.034783] xhci_hcd 0000:00:14.0: Stopped on Transfer TRB
> > [ 3079.034790] snd_em28xx_capture_trigger: start capture
> > 
> > While xHCI is still canceling the URBs, a new trigger happens, and it
> > calls usb_submit_urb().
> > 
> > [ 3079.034819] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x1ffb13850 (dma).
> > [ 3079.034835] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x1ffb13850
> > ...
> > [ 3079.036341] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xb624b850 (dma).
> > [ 3079.036352] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xb624b850
> > [ 3079.036365] em28xx_audio_isocirq, 64 packets (first one with size 0)
> > 
> > But xHCI only finishes cancelling the first URB here...
> > 
> > [ 3079.036382] xhci_hcd 0000:00:14.0: Cancel URB ffff880207900800, dev 4, ep 0x83, starting at offset 0x1ff937010
> > ...
> > [ 3079.043158] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x1ffb13840
> > [ 3079.043170] em28xx_audio_isocirq, 64 packets (first one with size 0)
> > 
> > And only here, it finishes to cancel the entire operation.
> > 
> > [ 3079.043231] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
> > [ 3079.043299] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 16 segments
> > [ 3079.428996] em28xx_audio_isocirq, 64 packets (first one with size 64)
> > 
> > Finally, after ~400ms after the new usb_submit_urb(), the first audio packet
> > appears...
> > 
> > [ 3079.429069] snd_em28xx_capture_trigger: stop capture
> > 
> > However, this is not fast enough to avoid ALSA buffer underrun. So,
> > the driver cancels the existing URBs...
> > 
> > [ 3079.429204] xhci_hcd 0000:00:14.0: Cancel URB ffff880207900000, dev 4, ep 0x83, starting at offset 0xc5a7f4b0
> > [ 3079.429241] snd_em28xx_capture_trigger: start capture
> > 
> > And submits a new set.
> > 
> > Not sure how to fix it.
> 
> Hmm... calling xawtv with a very high-latency alsa buffer works (the
> default latency is 30ms, with works fine with an EHCI port):
> 
> 	$ xawtv --alsa-latency 500
> 
> Of course, a half-second latency means that audio and video won't be 
> properly synchronized, but at least audio works.
> 
> I'll turn off the USB logs and do more experiences with the latency,
> in order to have an idea on how faster is EHCI to handle the
> ISOC requests, when compared with xHCI.

Ok, at lest on my quad-core 3rd gen i7core notebook, a latency of 65ms
is enough for audio to work on em28xx with xHCI. However, using such
latency on EHCI causes underruns. A latency of 90ms seems to work fine
on both drivers.

I'm starting to wander that maybe xHCI is not using the same urb->interval
than EHCI, and if this could explain those issues.

Regards,
-- 

Cheers,
Mauro
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro


--


upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.62
!!################################

!!Script ran on: Wed Jan  8 18:29:18 UTC 2014


!!Linux Distribution
!!------------------

Fedora release 20 (Heisenbug) Fedora release 20 (Heisenbug) NAME=Fedora ID=fedora PRETTY_NAME="Fedora 20 (Heisenbug)" CPE_NAME="cpe:/o:fedoraproject:fedora:20" HOME_URL="https://fedoraproject.org/" BUG_REPORT_URL="https://bugzilla.redhat.com/" REDHAT_BUGZILLA_PRODUCT="Fedora" REDHAT_BUGZILLA_PRODUCT_VERSION=20 REDHAT_SUPPORT_PRODUCT="Fedora" REDHAT_SUPPORT_PRODUCT_VERSION=20 Fedora release 20 (Heisenbug) Fedora release 20 (Heisenbug)


!!DMI Information
!!---------------

Manufacturer:      SAMSUNG ELECTRONICS CO., LTD.
Product Name:      550P5C/550P7C
Product Version:   P04ABI
Firmware Version:  P04ABI.013.130220.dg


!!Kernel Information
!!------------------

Kernel release:    3.13.0-rc1+
Operating System:  GNU/Linux
Architecture:      x86_64
Processor:         x86_64
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     k3.13.0-rc1+
Library version:    1.0.27.2
Utilities version:  1.0.27.2


!!Loaded ALSA modules
!!-------------------

em28xx_alsa
snd_hda_intel


!!Sound Servers on this system
!!----------------------------

Pulseaudio:
      Installed - Yes (/bin/pulseaudio)
      Running - Yes


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Em28xxAudio    ]: Em28xx-Audio - Em28xx Audio
                      Empia Em28xx Audio
 1 [PCH            ]: HDA-Intel - HDA Intel PCH
                      HDA Intel PCH at 0xf7910000 irq 47


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)


!!Advanced information - PCI Vendor/Device/Subsystem ID's
!!-------------------------------------------------------

00:1b.0 0403: 8086:1e20 (rev 04)
	Subsystem: 144d:c0d1


!!Loaded sound module options
!!---------------------------

!!Module: em28xx_alsa
	debug : 0

!!Module: snd_hda_intel
	align_buffer_size : -1
	bdl_pos_adj : 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	beep_mode : N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	enable_msi : -1
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	jackpoll_ms : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	model : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	patch : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	position_fix : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	power_save : 0
	power_save_controller : Y
	probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	probe_only : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	single_cmd : N
	snoop : Y


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Realtek ALC269VC
Address: 0
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x10ec0269
Subsystem Id: 0x144dc0d1
Revision Id: 0x100202
No Modem Function Group found
Default PCM:
    rates [0x5f0]: 32000 44100 48000 88200 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
State of AFG node 0x01:
  Power states:  D0 D1 D2 D3 CLKSTOP EPSS
  Power: setting=D0, actual=D0
GPIO: io=2, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=1, dir=1, wake=0, sticky=0, data=1, unsol=0
Node 0x02 [Audio Output] wcaps 0x41d: Stereo Amp-Out
  Control: name="Speaker Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x57, nsteps=0x57, stepsize=0x02, mute=0
  Amp-Out vals:  [0x4b 0x4b]
  Converter: stream=8, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
Node 0x03 [Audio Output] wcaps 0x41d: Stereo Amp-Out
  Control: name="Headphone Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Device: name="ALC269VC Analog", type="Audio", device=0
  Amp-Out caps: ofs=0x57, nsteps=0x57, stepsize=0x02, mute=0
  Amp-Out vals:  [0x00 0x00]
  Converter: stream=8, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
Node 0x04 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Audio Output] wcaps 0x611: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  IEC Coding Type: 0x0
  PCM:
    rates [0x5f0]: 32000 44100 48000 88200 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
Node 0x07 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x08 [Audio Input] wcaps 0x10051b: Stereo Amp-In
  Control: name="Capture Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Capture Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Device: name="ALC269VC Analog", type="Audio", device=0
  Amp-In caps: ofs=0x17, nsteps=0x3f, stepsize=0x02, mute=1
  Amp-In vals:  [0x27 0x27]
  Converter: stream=4, channel=0
  SDI-Select: 0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 1
     0x23
Node 0x09 [Audio Input] wcaps 0x10051b: Stereo Amp-In
  Amp-In caps: ofs=0x17, nsteps=0x3f, stepsize=0x02, mute=1
  Amp-In vals:  [0x97 0x97]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 1
     0x22
Node 0x0a [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Control: name="Internal Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Control: name="Internal Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Control: name="Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Connection: 5
     0x18 0x19 0x1a 0x1b 0x1d
Node 0x0c [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x02 0x0b
Node 0x0d [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x03 0x0b
Node 0x0e [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x0f [Audio Mixer] wcaps 0x20010a: Mono Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00] [0x00]
  Connection: 2
     0x02 0x0b
Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Pin Complex] wcaps 0x40040b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Pincap 0x00000020: IN
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x14 [Pin Complex] wcaps 0x40058d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x00010014: OUT EAPD Detect
  EAPD 0x2: EAPD
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 2
     0x0c* 0x0d
Node 0x15 [Pin Complex] wcaps 0x40058d: Stereo Amp-Out
  Control: name="Headphone Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Control: name="Headphone Jack", index=0, device=0
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0001001c: OUT HP EAPD Detect
  EAPD 0x2: EAPD
  Pin Default 0x0321101f: [Jack] HP Out at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=01, enabled=1
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 2
     0x0c 0x0d*
Node 0x16 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x17 [Pin Complex] wcaps 0x40050c: Mono Amp-Out
  Control: name="Bass Speaker Playback Switch", index=0, device=0
    ControlAmp: chs=1, dir=Out, idx=0, ofs=0
  Control: name="Speaker Surround Phantom Jack", index=0, device=0
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00]
  Pincap 0x00000010: OUT
  Pin Default 0x90170120: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x2, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 1
     0x0f
Node 0x18 [Pin Complex] wcaps 0x40058f: Stereo Amp-In Amp-Out
  Control: name="Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Mic Jack", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x00003734: IN OUT Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x03a11830: [Jack] Mic at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x3, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=02, enabled=1
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 2
     0x0c* 0x0d
Node 0x19 [Pin Complex] wcaps 0x40058f: Stereo Amp-In Amp-Out
  Control: name="Internal Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Internal Mic Phantom Jack", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x00003734: IN OUT Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x90a70940: [Fixed] Mic at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x4, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 2
     0x0c* 0x0d
Node 0x1a [Pin Complex] wcaps 0x40058f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000373c: IN OUT HP Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 2
     0x0c* 0x0d
Node 0x1b [Pin Complex] wcaps 0x40058f: Stereo Amp-In Amp-Out
  Control: name="Speaker Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Control: name="Speaker Front Phantom Jack", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00003734: IN OUT Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x90170110: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 2
     0x0c* 0x0d
Node 0x1c [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x1d [Pin Complex] wcaps 0x400400: Mono
  Pincap 0x00000020: IN
  Pin Default 0x4006a21d: [N/A] Line Out at Ext N/A
    Conn = Digital, Color = UNKNOWN
    DefAssociation = 0x1, Sequence = 0xd
  Pin-ctls: 0x20: IN
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
Node 0x1e [Pin Complex] wcaps 0x400781: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D1 D2 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 1
     0x06
Node 0x1f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
  Processing caps: benign=0, ncoeff=37
Node 0x21 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x22 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Connection: 7
     0x18 0x19 0x1a 0x1b 0x1d 0x0b 0x12
Node 0x23 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Connection: 6
     0x18 0x19 0x1a 0x1b 0x1d 0x0b
Codec: Intel PantherPoint HDMI
Address: 3
AFG Function Id: 0x1 (unsol 0)
Vendor Id: 0x80862806
Subsystem Id: 0x80860101
Revision Id: 0x100000
No Modem Function Group found
Default PCM:
    rates [0x0]:
    bits [0x0]:
    formats [0x0]:
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
State of AFG node 0x01:
  Power states:  D0 D3 CLKSTOP EPSS
  Power: setting=D0, actual=D0, Clock-stop-OK
GPIO: io=0, o=0, i=0, unsolicited=0, wake=0
Node 0x02 [Audio Output] wcaps 0x6611: 8-Channels Digital
  Converter: stream=0, channel=0
  Digital: Enabled
  Digital category: 0x0
  IEC Coding Type: 0x0
  PCM:
    rates [0x7f0]: 32000 44100 48000 88200 96000 176400 192000
    bits [0x1e]: 16 20 24 32
    formats [0x5]: PCM AC3
  Power states:  D0 D3 EPSS
  Power: setting=D0, actual=D0
Node 0x03 [Audio Output] wcaps 0x6611: 8-Channels Digital
  Converter: stream=0, channel=0
  Digital: Enabled
  Digital category: 0x0
  IEC Coding Type: 0x0
  PCM:
    rates [0x7f0]: 32000 44100 48000 88200 96000 176400 192000
    bits [0x1e]: 16 20 24 32
    formats [0x5]: PCM AC3
  Power states:  D0 D3 EPSS
  Power: setting=D0, actual=D0
Node 0x04 [Audio Output] wcaps 0x6611: 8-Channels Digital
  Converter: stream=0, channel=0
  Digital: Enabled
  Digital category: 0x0
  IEC Coding Type: 0x0
  PCM:
    rates [0x7f0]: 32000 44100 48000 88200 96000 176400 192000
    bits [0x1e]: 16 20 24 32
    formats [0x5]: PCM AC3
  Power states:  D0 D3 EPSS
  Power: setting=D0, actual=D0
Node 0x05 [Pin Complex] wcaps 0x40778d: 8-Channels Digital Amp-Out CP
  Control: name="HDMI/DP,pcm=3 Jack", index=0, device=0
  Control: name="IEC958 Playback Con Mask", index=0, device=0
  Control: name="IEC958 Playback Pro Mask", index=0, device=0
  Control: name="IEC958 Playback Default", index=0, device=0
  Control: name="IEC958 Playback Switch", index=0, device=0
  Control: name="ELD", index=0, device=3
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x09000094: OUT Detect HBR HDMI DP
  Pin Default 0x18560010: [Jack] Digital Out at Int HDMI
    Conn = Digital, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=01, enabled=1
  Power states:  D0 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 1
     0x02
Node 0x06 [Pin Complex] wcaps 0x40778d: 8-Channels Digital Amp-Out CP
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x80]
  Pincap 0x09000094: OUT Detect HBR HDMI DP
  Pin Default 0x58560020: [N/A] Digital Out at Int HDMI
    Conn = Digital, Color = Unknown
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 1
     0x03
Node 0x07 [Pin Complex] wcaps 0x40778d: 8-Channels Digital Amp-Out CP
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x80]
  Pincap 0x09000094: OUT Detect HBR HDMI DP
  Pin Default 0x58560030: [N/A] Digital Out at Int HDMI
    Conn = Digital, Color = Unknown
    DefAssociation = 0x3, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D3 EPSS
  Power: setting=D0, actual=D0
  Connection: 1
     0x04
Node 0x08 [Vendor Defined Widget] wcaps 0xf00000: Mono
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116,  3 Jan  8 16:21 /dev/snd/controlC0
crw-rw----+ 1 root audio 116,  9 Jan  8 15:41 /dev/snd/controlC1
crw-rw----+ 1 root audio 116,  8 Jan  8 15:41 /dev/snd/hwC1D0
crw-rw----+ 1 root audio 116,  7 Jan  8 15:41 /dev/snd/hwC1D3
crw-rw----+ 1 root audio 116,  2 Jan  8 16:21 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116,  6 Jan  8 15:51 /dev/snd/pcmC1D0c
crw-rw----+ 1 root audio 116,  5 Jan  8 16:21 /dev/snd/pcmC1D0p
crw-rw----+ 1 root audio 116,  4 Jan  8 15:51 /dev/snd/pcmC1D3p
crw-rw----+ 1 root audio 116,  1 Jan  8 15:41 /dev/snd/seq
crw-rw----+ 1 root audio 116, 33 Jan  8 15:41 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x. 2 root root  80 Jan  8 16:21 .
drwxr-xr-x. 3 root root 260 Jan  8 16:21 ..
lrwxrwxrwx. 1 root root  12 Jan  8 16:21 pci-0000:00:1a.0-usb-0:1.2 -> ../controlC0
lrwxrwxrwx. 1 root root  12 Jan  8 15:41 pci-0000:00:1b.0 -> ../controlC1


!!ALSA configuration files
!!------------------------

!!System wide config file (/etc/asound.conf)

#
# Place your global alsa-lib configuration here...
#


!!Aplay/Arecord output
!!--------------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 1: PCH [HDA Intel PCH], device 0: ALC269VC Analog [ALC269VC Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: PCH [HDA Intel PCH], device 3: HDMI 0 [HDMI 0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Em28xxAudio [Em28xx Audio], device 0: Em28xx Audio [Empia 28xx Capture]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: PCH [HDA Intel PCH], device 0: ALC269VC Analog [ALC269VC Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Em28xxAudio]

Card hw:0 'Em28xxAudio'/'Empia Em28xx Audio'
  Mixer name	: ''
  Components	: ''
  Controls      : 24
  Simple ctrls  : 12
Simple mixer control 'Master',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 31 [100%] Playback [off]
  Front Right: 31 [100%] Playback [off]
Simple mixer control 'PCM',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 31 [100%] Playback [off]
  Front Right: 31 [100%] Playback [off]
Simple mixer control 'Surround',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 31 [100%] Playback [on]
  Front Right: 31 [100%] Playback [on]
Simple mixer control 'LFE',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 31 [100%] Playback [on]
  Front Right: 31 [100%] Playback [on]
Simple mixer control 'Line',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 31 [100%] Playback [off]
  Front Right: 31 [100%] Playback [off]
Simple mixer control 'Line In',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 31 [100%] Playback [off]
  Front Right: 31 [100%] Playback [off]
Simple mixer control 'CD',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 31 [100%] Playback [off]
  Front Right: 31 [100%] Playback [off]
Simple mixer control 'Microphone',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 31 [100%] Playback [off]
  Front Right: 31 [100%] Playback [off]
Simple mixer control 'Video',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 23 [74%] Playback [on]
  Front Right: 31 [100%] Playback [on]
Simple mixer control 'Phone',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 31 [100%] Playback [off]
  Front Right: 31 [100%] Playback [off]
Simple mixer control 'Mono',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 31 [100%] Playback [off]
  Front Right: 31 [100%] Playback [off]
Simple mixer control 'AUX',0
  Capabilities: volume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 31
  Front Left: 31 [100%] Playback [off]
  Front Right: 31 [100%] Playback [off]

!!-------Mixer controls for card 1 [PCH]

Card hw:1 'PCH'/'HDA Intel PCH at 0xf7910000 irq 47'
  Mixer name	: 'Intel PantherPoint HDMI'
  Components	: 'HDA:10ec0269,144dc0d1,00100202 HDA:80862806,80860101,00100000'
  Controls      : 31
  Simple ctrls  : 12
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 87
  Mono: Playback 75 [86%] [-9.00dB] [on]
Simple mixer control 'Headphone',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 87
  Mono:
  Front Left: Playback 0 [0%] [-65.25dB] [off]
  Front Right: Playback 0 [0%] [-65.25dB] [off]
Simple mixer control 'Speaker',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 87
  Mono:
  Front Left: Playback 87 [100%] [0.00dB] [on]
  Front Right: Playback 87 [100%] [0.00dB] [on]
Simple mixer control 'Bass Speaker',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 254 [100%] [-0.20dB]
  Front Right: Playback 254 [100%] [-0.20dB]
Simple mixer control 'Mic',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off]
Simple mixer control 'Mic Boost',0
  Capabilities: volume
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]
Simple mixer control 'IEC958',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [off]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 63
  Front Left: Capture 39 [62%] [12.00dB] [on]
  Front Right: Capture 39 [62%] [12.00dB] [on]
Simple mixer control 'Auto-Mute Mode',0
  Capabilities: enum
  Items: 'Disabled' 'Enabled'
  Item0: 'Enabled'
Simple mixer control 'Internal Mic',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off]
Simple mixer control 'Internal Mic Boost',0
  Capabilities: volume
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]


!!Alsactl output
!!--------------

--startcollapse--
state.Em28xxAudio {
	control.1 {
		iface MIXER
		name 'Video Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.2 {
		iface MIXER
		name 'Video Volume'
		value.0 23
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
	control.3 {
		iface MIXER
		name 'Line In Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.4 {
		iface MIXER
		name 'Line In Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
	control.5 {
		iface MIXER
		name 'Phone Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.6 {
		iface MIXER
		name 'Phone Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
	control.7 {
		iface MIXER
		name 'Microphone Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.8 {
		iface MIXER
		name 'Microphone Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
	control.9 {
		iface MIXER
		name 'CD Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.10 {
		iface MIXER
		name 'CD Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
	control.11 {
		iface MIXER
		name 'AUX Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.12 {
		iface MIXER
		name 'AUX Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
	control.13 {
		iface MIXER
		name 'PCM Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.14 {
		iface MIXER
		name 'PCM Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
	control.15 {
		iface MIXER
		name 'Master Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.16 {
		iface MIXER
		name 'Master Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
	control.17 {
		iface MIXER
		name 'Line Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.18 {
		iface MIXER
		name 'Line Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
	control.19 {
		iface MIXER
		name 'Mono Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.20 {
		iface MIXER
		name 'Mono Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
	control.21 {
		iface MIXER
		name 'LFE Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.22 {
		iface MIXER
		name 'LFE Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
	control.23 {
		iface MIXER
		name 'Surround Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.24 {
		iface MIXER
		name 'Surround Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
		}
	}
}
state.PCH {
	control.1 {
		iface MIXER
		name 'Headphone Playback Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 87'
			dbmin -6525
			dbmax 0
			dbvalue.0 -6525
			dbvalue.1 -6525
		}
	}
	control.2 {
		iface MIXER
		name 'Headphone Playback Switch'
		value.0 false
		value.1 false
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.3 {
		iface MIXER
		name 'Speaker Playback Volume'
		value.0 87
		value.1 87
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 87'
			dbmin -6525
			dbmax 0
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.4 {
		iface MIXER
		name 'Speaker Playback Switch'
		value.0 true
		value.1 true
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.5 {
		iface MIXER
		name 'Bass Speaker Playback Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.6 {
		iface MIXER
		name 'Internal Mic Playback Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
			dbmin -3450
			dbmax 1200
			dbvalue.0 -3450
			dbvalue.1 -3450
		}
	}
	control.7 {
		iface MIXER
		name 'Internal Mic Playback Switch'
		value.0 false
		value.1 false
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.8 {
		iface MIXER
		name 'Mic Playback Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
			dbmin -3450
			dbmax 1200
			dbvalue.0 -3450
			dbvalue.1 -3450
		}
	}
	control.9 {
		iface MIXER
		name 'Mic Playback Switch'
		value.0 false
		value.1 false
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.10 {
		iface MIXER
		name 'Auto-Mute Mode'
		value Enabled
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Disabled
			item.1 Enabled
		}
	}
	control.11 {
		iface MIXER
		name 'Capture Volume'
		value.0 39
		value.1 39
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 63'
			dbmin -1725
			dbmax 3000
			dbvalue.0 1200
			dbvalue.1 1200
		}
	}
	control.12 {
		iface MIXER
		name 'Capture Switch'
		value.0 true
		value.1 true
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.13 {
		iface MIXER
		name 'Internal Mic Boost Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 3'
			dbmin 0
			dbmax 3000
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.14 {
		iface MIXER
		name 'Mic Boost Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 3'
			dbmin 0
			dbmax 3000
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.15 {
		iface MIXER
		name 'Master Playback Volume'
		value 75
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 87'
			dbmin -6525
			dbmax 0
			dbvalue.0 -900
		}
	}
	control.16 {
		iface MIXER
		name 'Master Playback Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.17 {
		iface CARD
		name 'Internal Mic Phantom Jack'
		value true
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.18 {
		iface CARD
		name 'Mic Jack'
		value false
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.19 {
		iface CARD
		name 'Headphone Jack'
		value false
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.20 {
		iface CARD
		name 'Speaker Front Phantom Jack'
		value true
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.21 {
		iface CARD
		name 'Speaker Surround Phantom Jack'
		value true
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.22 {
		iface PCM
		name 'Playback Channel Map'
		value.0 0
		value.1 0
		value.2 0
		value.3 0
		comment {
			access read
			type INTEGER
			count 4
			range '0 - 36'
		}
	}
	control.23 {
		iface PCM
		name 'Capture Channel Map'
		value.0 0
		value.1 0
		comment {
			access read
			type INTEGER
			count 2
			range '0 - 36'
		}
	}
	control.24 {
		iface CARD
		name 'HDMI/DP,pcm=3 Jack'
		value false
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.25 {
		iface MIXER
		name 'IEC958 Playback Con Mask'
		value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
		comment {
			access read
			type IEC958
			count 1
		}
	}
	control.26 {
		iface MIXER
		name 'IEC958 Playback Pro Mask'
		value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
		comment {
			access read
			type IEC958
			count 1
		}
	}
	control.27 {
		iface MIXER
		name 'IEC958 Playback Default'
		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
		comment {
			access 'read write'
			type IEC958
			count 1
		}
	}
	control.28 {
		iface MIXER
		name 'IEC958 Playback Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.29 {
		iface PCM
		device 3
		name ELD
		value ''
		comment {
			access 'read volatile'
			type BYTES
			count 0
		}
	}
	control.30 {
		iface PCM
		device 3
		name 'Playback Channel Map'
		value.0 0
		value.1 0
		value.2 0
		value.3 0
		value.4 0
		value.5 0
		value.6 0
		value.7 0
		comment {
			access 'read write'
			type INTEGER
			count 8
			range '0 - 36'
		}
	}
	control.31 {
		iface MIXER
		name 'PCM Playback Volume'
		value.0 254
		value.1 254
		comment {
			access 'read write user'
			type INTEGER
			count 2
			range '0 - 255'
			tlv '0000000100000008ffffec1400000014'
			dbmin -5100
			dbmax 0
			dbvalue.0 -20
			dbvalue.1 -20
		}
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
fuse
ccm
nf_conntrack_netbios_ns
nf_conntrack_broadcast
ipt_MASQUERADE
ip6t_REJECT
xt_conntrack
ebtable_nat
ebtable_broute
bridge
stp
llc
ebtable_filter
ebtables
ip6table_nat
nf_conntrack_ipv6
nf_defrag_ipv6
nf_nat_ipv6
ip6table_mangle
ip6table_security
ip6table_raw
ip6table_filter
ip6_tables
iptable_nat
nf_conntrack_ipv4
nf_defrag_ipv4
nf_nat_ipv4
nf_nat
nf_conntrack
iptable_mangle
iptable_security
iptable_raw
bnep
vfat
fat
arc4
iwldvm
mac80211
iwlwifi
cfg80211
x86_pkg_temp_thermal
coretemp
kvm_intel
kvm
crc32_pclmul
crc32c_intel
ghash_clmulni_intel
netconsole
rc_hauppauge
em28xx_rc
rc_core
lgdt330x
snd_hda_codec_hdmi
snd_hda_codec_realtek
em28xx_dvb
dvb_core
snd_hda_intel
snd_hda_codec
em28xx_alsa
snd_hwdep
snd_seq
snd_seq_device
snd_pcm
snd_page_alloc
snd_timer
snd
nfsd
auth_rpcgss
tuner_xc2028
tuner
tvp5150
em28xx_v4l
uvcvideo
em28xx
videobuf2_vmalloc
tveeprom
videobuf2_memops
v4l2_common
videobuf2_core
videodev
media
btusb
bluetooth
joydev
serio_raw
iTCO_wdt
iTCO_vendor_support
rfkill
soundcore
r8169
mii
shpchp
mei_me
mei
microcode
i2c_i801
lpc_ich
mfd_core
nfs_acl
lockd
sunrpc
nouveau
i915
ttm
i2c_algo_bit
drm_kms_helper
drm
i2c_core
mxm_wmi
wmi
video


!!Sysfs Files
!!-----------

/sys/class/sound/hwC1D0/init_pin_configs:
0x12 0x411111f0
0x14 0x411111f0
0x15 0x0321101f
0x17 0x90170120
0x18 0x03a11830
0x19 0x90a70940
0x1a 0x411111f0
0x1b 0x90170110
0x1d 0x4006a21d
0x1e 0x411111f0

/sys/class/sound/hwC1D0/driver_pin_configs:

/sys/class/sound/hwC1D0/user_pin_configs:

/sys/class/sound/hwC1D0/init_verbs:

/sys/class/sound/hwC1D0/hints:

/sys/class/sound/hwC1D3/init_pin_configs:
0x05 0x18560010
0x06 0x58560020
0x07 0x58560030

/sys/class/sound/hwC1D3/driver_pin_configs:

/sys/class/sound/hwC1D3/user_pin_configs:

/sys/class/sound/hwC1D3/init_verbs:

/sys/class/sound/hwC1D3/hints:


!!ALSA/HDA dmesg
!!--------------

[   24.204127] em28xx: Registered (Em28xx Audio Extension) extension
[   24.207614] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[   24.209216] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   24.213022] em2882/3 #0: Binding DVB extension
[   24.222898] ALSA sound/pci/hda/patch_realtek.c:419 SKU: Nid=0x1d sku_cfg=0x4006a21d
[   24.222901] ALSA sound/pci/hda/patch_realtek.c:421 SKU: port_connectivity=0x1
[   24.222902] ALSA sound/pci/hda/patch_realtek.c:422 SKU: enable_pcbeep=0x0
[   24.222903] ALSA sound/pci/hda/patch_realtek.c:423 SKU: check_sum=0x00000006
[   24.222904] ALSA sound/pci/hda/patch_realtek.c:424 SKU: customization=0x000000a2
[   24.222905] ALSA sound/pci/hda/patch_realtek.c:425 SKU: external_amp=0x3
[   24.222906] ALSA sound/pci/hda/patch_realtek.c:426 SKU: platform_type=0x1
[   24.222908] ALSA sound/pci/hda/patch_realtek.c:427 SKU: swap=0x0
[   24.222909] ALSA sound/pci/hda/patch_realtek.c:428 SKU: override=0x1
[   24.223221] ALSA sound/pci/hda/hda_auto_parser.c:393 autoconfig: line_outs=2 (0x1b/0x17/0x0/0x0/0x0) type:speaker
[   24.223223] ALSA sound/pci/hda/hda_auto_parser.c:397    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   24.223224] ALSA sound/pci/hda/hda_auto_parser.c:401    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[   24.223225] ALSA sound/pci/hda/hda_auto_parser.c:402    mono: mono_out=0x0
[   24.223226] ALSA sound/pci/hda/hda_auto_parser.c:406    inputs:
[   24.223228] ALSA sound/pci/hda/hda_auto_parser.c:410      Internal Mic=0x19
[   24.223230] ALSA sound/pci/hda/hda_auto_parser.c:410      Mic=0x18
[   24.223232] ALSA sound/pci/hda/patch_realtek.c:491 realtek: No valid SSID, checking pincfg 0x4006a21d for NID 0x1d
[   24.223234] ALSA sound/pci/hda/patch_realtek.c:507 realtek: Enabling init ASM_ID=0xa21d CODEC_ID=10ec0269
[   24.236439] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[   24.237093] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input10
[   24.237688] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input9
[   24.257693] xc2028: Xcv2028/3028 init called!
--
[  873.141600] URB ffff88022219f800 submitted while active
[  873.141619] Modules linked in: fuse ccm nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw bnep vfat fat arc4 iwldvm mac80211 iwlwifi cfg80211 x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel netconsole rc_hauppauge em28xx_rc rc_core lgdt330x snd_hda_codec_hdmi snd_hda_codec_realtek em28xx_dvb dvb_core snd_hda_intel snd_hda_codec em28xx_alsa snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd
[  873.143618]  nfsd auth_rpcgss tuner_xc2028 tuner tvp5150 em28xx_v4l uvcvideo em28xx videobuf2_vmalloc tveeprom videobuf2_memops v4l2_common videobuf2_core videodev media btusb bluetooth joydev serio_raw iTCO_wdt iTCO_vendor_support rfkill soundcore r8169 mii shpchp mei_me mei microcode i2c_i801 lpc_ich mfd_core nfs_acl lockd sunrpc nouveau i915 ttm i2c_algo_bit drm_kms_helper drm i2c_core mxm_wmi wmi video
[  873.145388] CPU: 4 PID: 2103 Comm: kworker/4:0 Not tainted 3.13.0-rc1+ #22



