Return-path: <linux-media-owner@vger.kernel.org>
Received: from dudelab.org ([212.12.33.202]:25344 "EHLO mail.dudelab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0AQNdE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 08:33:04 -0500
Received: from abrasax.taupan.ath.cx (p5DE8BB2A.dip.t-dialin.net [93.232.187.42])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "Friedrich Delgado Friedrichs", Issuer "User CA" (verified OK))
	by mail.dudelab.org (Postfix) with ESMTP id 3121F228148
	for <linux-media@vger.kernel.org>; Sun, 17 Jan 2010 14:34:13 +0100 (CET)
Date: Sun, 17 Jan 2010 14:33:00 +0100
From: Friedrich Delgado Friedrichs <friedel@nomaden.org>
To: linux-media@vger.kernel.org
Subject: Hauppauge Win TV HVR-1300: streaming and grabbing fail after a
 while, changing resolution renders card inoperable
Message-ID: <20100117133300.GA3668@taupan.ath.cx>
Reply-To: friedel@nomaden.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I have a Hauppauge HVR-1300 which I currently intend to use for
capturing analog cable tv, because of the hardware mpeg encoder.

There are three problems, which might or might not be related:

1) mpeg stream from hardware encoder breaks off or is corrupted (I
can't tell which) after a while

2) screengrabber image gets corrupted after a while

3) changing resolutions causes mpeg encoder stream to become
completely inoperable

I've made sure to reproduce all problems with an untainted 2.6.32
kernel (package linux-image-2.6.32-trunk-amd64 version 2.6.32-5 from
ubuntu).

1) mpeg stream from hardware encoder breaking:

After setting a channel with

ivtv-tune -d /dev/video1 -t europe-west -c E6

I can play the mpeg stream e.g. with

mplayer -nofs -vo x11 /dev/video1 -cache 8192

but after a while (ranging from a few seconds to several minutes (up
to five, I think)) the video stream seems to break off. mplayer shows
a freezed frame, there's no sound. Sometimes mplayer will terminate
with "end of file".

The same happens when I do

cat /dev/video1 > test.mpg

and play test.mpg with mplayer, however the test.mpg file still grows,
so there's some output from the device, mplayer apparently just isn't
able to play it. I still get end of file with this file, even though
mplayer displays it's 7 minutes or longer, just the first minute will
be played.

I've unloaded the modules and reloaded them with

modprobe cx2341x debug=1
modprobe cx88_blackbird debug=1 video_debug=1 mpegbufs=32

in order to get some debug output in dmesg. dmesg output was
pastebinned at http://pastebin.com/f60ad5dcc since it's too long for
this list.

(In case you're curious about the backtrace in the beginning, I
uploaded the start of syslog at http://pastebin.com/f3bac25d7 I'd also
like to know if it might indicate problems.)

2) corrupted image from screengrabber:

There are also problems with the framegrabber on /dev/video0. When I
watch analog tv directly (with mythtv or tvtime), after a while (again
a few seconds up to a few minutes), the picture shrinks to an area in
the upper right corner. In the lower parts there are sometimes moving
artefacts.

If I run a tail -f on syslog I see nothing, but this time I didn't
give any debug options to the modules (also I was using an older
kernel, tainted by the fglrx driver. If you want, I can reproduce this
with the untainted 2.6.32 again.)

I've uploaded a screenshot from tvtime to
http://dudelab.org/~taupan/tvtime-output-22:45:53.jpg

xawtv display looks very weird... as if every eighth line was shifted
by about a 16th of its width or so. Example image at
http://dudelab.org/~taupan/snap-viva-20100117-142327-1.jpeg

(I used roughly the same xawtv configuration with an ancient hauppauge
card from 1997 which I used successfully until recently.)

3) broken resolution switching:

When I switch resolutions in mythtv recording profile, but also via
e.g.

v4l2-ctl -d /dev/video1 --set-fmt-video=width=720,height=568

I seem to totally break the encoder. There's no stream any more,

~> cat /dev/video1
cat: /dev/video1: Input/output error

And switching the resolution back doesn't help. Unloading the modules
doesn't help either, I have to reboot the box.

dmesg output pastebinned at http://pastebin.com/f4e27757a

Tests were done with a 2.6.32 kernel from ubuntu.

Please ask if there's any information you can't easily infer from this
mail or the attached logs.

Kind regards
     Friedel
--
        Friedrich Delgado Friedrichs <friedel@nomaden.org>
                             TauPan on Ircnet and Freenode ;)

