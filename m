Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:44425 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab2KZPJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 10:09:16 -0500
Received: by mail-yh0-f46.google.com with SMTP id m54so1015519yhm.19
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2012 07:09:16 -0800 (PST)
Message-ID: <50B38619.40106@gmail.com>
Date: Mon, 26 Nov 2012 10:09:13 -0500
From: Bob Lightfoot <boblfoot@gmail.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Poor HVR 1600 Video Quality - Feedback for Andy Walls 2012-11-26
References: <50B1047B.4040901@gmail.com>  <CAGoCfiwpj5ua79wOp8_CZfD_O9EOG7PAA4wE3L4n3-d-+FEhVg@mail.gmail.com>  <50B199A9.8050909@gmail.com> <1353891244.2496.37.camel@palomino.walls.org>
In-Reply-To: <1353891244.2496.37.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/25/2012 07:54 PM, Andy Walls wrote:
> So here's what you need to do:
> 
> 1. provide the output of v4l2-ctl -d /dev/video2 --log-status, so I
> can see the analog tuner assembly that your unit has.
> 
Here is the output with the S-Video Input in use.  If I need to
snapshot with the coax input in use that will take a little more time.
Status Log:

   cx18-0: =================  START STATUS CARD #0  =================
   cx18-0: Version: 1.4.0  Card: Hauppauge HVR-1600
   tveeprom 4-0050: Hauppauge model 74041, rev C6B2, serial# 5267091
   tveeprom 4-0050: MAC address is 00:0d:fe:50:5e:93
   tveeprom 4-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
   tveeprom 4-0050: TV standards NTSC(M) (eeprom 0x08)
   tveeprom 4-0050: audio processor is CX23418 (idx 38)
   tveeprom 4-0050: decoder processor is CX23418 (idx 31)
   tveeprom 4-0050: has no radio, has IR receiver, has IR transmitter
   cx18-0 843: Video signal:              present
   cx18-0 843: Detected format:           NTSC-M
   cx18-0 843: Specified standard:        NTSC-M
   cx18-0 843: Specified video input:     S-Video (Luma In1, Chroma In5)
   cx18-0 843: Specified audioclock freq: 48000 Hz
   cx18-0 843: Detected audio mode:       mono
   cx18-0 843: Detected audio standard:   BTSC
   cx18-0 843: Audio muted:               no
   cx18-0 843: Audio microcontroller:     stopped
   cx18-0 843: Configured audio standard: automatic detection
   cx18-0 843: Configured audio system:   BTSC
   cx18-0 843: Specified audio input:     External
   cx18-0 843: Preferred audio mode:      stereo
   cx18-0 gpio-reset-ctrl: GPIO:  direction 0x00003001, value 0x00003001
   tuner 5-0061: Tuner mode:      analog TV
   tuner 5-0061: Frequency:       67.25 MHz
   tuner 5-0061: Standard:        0x0000b000
   cs5345 4-004c: Input:  2
   cs5345 4-004c: Volume: 0 dB
   cx18-0: Video Input: S-Video 1
   cx18-0: Audio Input: Line In 1
   cx18-0: GPIO:  direction 0x00003001, value 0x00003001
   cx18-0: Tuner: TV
   cx18-0: Stream: MPEG-2 Program Stream
   cx18-0: VBI Format: Private packet, IVTV format
   cx18-0: Video:  720x480, 30 fps
   cx18-0: Video:  MPEG-2, 4x3, Variable Bitrate, 4400000, Peak 6600000
   cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure
   cx18-0: Audio:  48 kHz, MPEG-1/2 Layer II, 224 kbps, Stereo, No
Emphasis, No CRC
   cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D
Horizontal, 0
   cx18-0: Temporal Filter: Manual, 8
   cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
   cx18-0: Status flags: 0x00200001
   cx18-0: Stream encoder MPEG: status 0x0000, 0% of 2048 KiB (64
buffers) in use
   cx18-0: Stream encoder YUV: status 0x0000, 0% of 2025 KiB (20
buffers) in use
   cx18-0: Stream encoder VBI: status 0x0000, 0% of 1015 KiB (20
buffers) in use
   cx18-0: Stream encoder PCM audio: status 0x0000, 0% of 1024 KiB
(256 buffers) in use
   cx18-0: Read MPEG/VBI: 0/0 bytes
   cx18-0: ==================  END STATUS CARD #0  ==================

> 2. Test the unit under the previous Linux kernel version with which
> you were *sure* the unit worked properly.  Or test with Windows as
> Devin suggested.  We're trying to eliminate a bad HVR-1600 card
> here, so if you can test it in that very same machine, all the
> better.
> 
> Also, if you can provide us with the two kernel versions, working
> and non-working, we can narrow down if a kernel change caused the
> problem for you.
> 
I do not have the ability to revert to a known working state without
potentially messing thigns up in a serious way.  I know the last known
good working state was prior to 2012-08-10.  I've tried reverting to
kernels that were current at that time and the problem still persist.
 It also is worth noting that the "good" video at that time still had
the occaisional artifact along the edges which does not happen using
the SVideo portion of the card now.

> 3. Test with as few cards in the PC chassis as possible.  This
> will eliminate some EMI and power supply problems.  It's a shot in
> the dark, but easy enough for you to try.
> 
I just finished a weeks vacation and after the honey-do list had
Friday, Saturday and Sunday to play on the video tower.  Pulled
everything apart and cleaned it all.  The pictures I took involved
removing and reseating all the cards so this did not help.  It will be
December before I have time to pull cards and try this as you suggest.
Must earn a paycheck.

> 4. If you do decide to much around in the PC, pull out all the PCI 
> cards, blow the dust out of all the slots, reseat the cards, and
> retest. I am amazed at how often that actually helps with various
> problems.
> 
> 
> 
> I would point you to an email where I added all sorts of extra
> controls to the cx18 driver in a patchset, for the express purpose
> of debugging sync problems:
> 
> http://www.gossamer-threads.com/lists/ivtv/users/40227?do=post_view_threaded#40227
>
>  and ask you to fiddle around with them.
> 
> Unfortunately the patches, which are still here:
> 
> http://linuxtv.org/hg/~awalls/v4l-dvb-ctls/
> 
> are very old and don't apply cleanly to newer versions of the cx18 
> driver. :(
> 
> 
> My suspicion is either
> 
> a. you have a marginal CX23418 chip and something on you card or in
> your chassis is allowing a DC charge to build up on the CVBS line
> between the tuner and the CX23418
> 
> or
> 
> b. a recent kernel change broke the ananlog tuner configuration for
> the tuner on your board.

I can agree that your theories are correct.  For now SVideo is working
so much better than coax ever did with mythtv that I an hesitant to
disturb things until my next vacation week in December.
> 
> 
> Centos and other enterprise distros and clone usually run pretty
> old kernels.  You may be running into a bug which was found and
> fixed years ago.
> 
> Have you tried with a modern LiveCD of Fedora or Ubuntu or Knoppix
> or something?  (I don't know which one has HVR-1600 support built
> into a live CD.)
> 
That sounds like a great idea.  I may just try and download a
mythbuntu live cd/dvd and boot it.  Should have the necessary drivers
since even my old Centos Kernels support the HVR-1600 natively
{allegely} :)

> Regards, Andy
> 

Thanks to you and Devin for the time to respond.  Sorry I don't have
more time to dedicate to this at this moment.  Suffice to say the
video quality from SVideo looks tons better than I've ever seen from
coax with this card.  So for time being thats going to be the solution.

Thanks again.

Bob Lightfoot
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJQs4YYAAoJEKqgpLIhfz3XARYH/2WdS+62TeWiIJIcUyQOUyO5
IhBgodbCBSs8KNSBVKzKGXOgbimcwbHmkixMV0lse6d47o2itSBWc+H2UMMnqCTr
nuUXrjJ17+0+yeceePXUyk7OqQxGGjr7I0VBxiLB3saTr65n3DxwDu2A6TijBZuM
13WlVRASmTj37VzfZdZDfWgsAOcgV+GpKvqszvjm1JF0XXpiRVfOPO2/AtcDr921
MAiBCXFN7T9yToMWySgLf8+ZL9/SRgI+iUhdxV2KYAhd9kZ0r9nKGs7CPxrEeK8h
wSM1FO9i15agNXrp6oAcNJM9IHRlLXV3VtmSd0KfKVBL7wp25XJzFKVCura3hgw=
=YwZm
-----END PGP SIGNATURE-----
