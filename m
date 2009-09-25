Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:45794 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZIYVDh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2009 17:03:37 -0400
Received: by bwz6 with SMTP id 6so218352bwz.37
        for <linux-media@vger.kernel.org>; Fri, 25 Sep 2009 14:03:40 -0700 (PDT)
Date: Sat, 26 Sep 2009 00:03:42 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: xc2028 sound carrier detection
Message-ID: <20090925210342.GA14181@moon>
References: <20090921223751.GA1303@moon> <20090921215238.2e189d60@pedra.chehab.org> <20090923192810.GA4653@moon> <829197380909231427n1fa9374djf01d06f7c1a682c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <829197380909231427n1fa9374djf01d06f7c1a682c1@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 23, 2009 at 05:27:56PM -0400, Devin Heitmueller wrote:
> On Wed, Sep 23, 2009 at 3:28 PM, Aleksandr V. Piskunov
> <aleksandr.v.piskunov@gmail.com> wrote:
> > Mmm, tested that tuner under windows, it autodetects all 3 sound carrier sub-
> > standards instantly: PAL-BG, PAL-DK, PAL-I.
> >
> > In order to test, I connected ancient Panasonic VCR that has a built-in tuner
> > and can output video to RF-OUT on fixed frequency using PAL standard. Sound
> > carrier frequency can be choosen using hardware switch BG, DK or I.
> >
> > So under windows: tuner produces clear audio in BG, DK and I, hardware switch
> > can be toggled on fly, audio never stops, only a few miliseconds of static on
> > switch.
> >
> > Under linux: audio only works if driver is set to use specific audio carrier
> > sub-standard AND same is selected on PVR. (not to mention extremely unreliable
> > PAL-DK detection by cx25843, only works 50% of times, but thats another issue)
> >
> > Either a more generic firmware exists can be uploaded on xc2028.. or several
> > can be uploaded at once. Any xc2028 gurus out there?
> 
> It's possible that perhaps the Windows driver is relying on the
> cx25843 standard detection and then using that to load the appropriate
> firmware on the 3028.
> 
> I can confirm though Mauro's assertion that the 3028 does use
> different firmware depending on the selected audio standard.  You
> might want to try to get a capture of the device under Windows and see
> what firmware gets loaded.

Ok, done a little research, here are results:

1) Best suitable xc2028 firmware for PAL audio is the one that gets chosen 
for PAL-I, to be more precise its
"Firmware 69, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.00 MHz"
With this firmware loaded, tuner seems to pass everything from +5.5 MHz to
+6.5Mhz straight to cx25843, resulting automatic detection of BG, I and DK audio.
Instant detection on source change, instant playback, same as under windows.
Would be great if more people would try "v4l2-ctl -s pal-i" and give feedback,
especially for stereo sources.

2) Extremely unreliable detection of DK was caused by cx25843 trying to guess
if 6.5MHz carrier is system DK or system L, special register was set to autodetection
which failed half of the times. Will send a patch in a separate mail.
