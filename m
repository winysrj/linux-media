Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m512k5v5023668
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 22:46:05 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m512jZEB025548
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 22:45:36 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K2dZa-0004IH-NN
	for video4linux-list@redhat.com; Sun, 01 Jun 2008 02:45:33 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sun, 01 Jun 2008 02:45:30 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sun, 01 Jun 2008 02:45:30 +0000
To: video4linux-list@redhat.com
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Sun, 1 Jun 2008 02:45:22 +0000 (UTC)
Message-ID: <loom.20080601T023335-56@post.gmane.org>
References: <c5bea28d26aa1caa1e85da.20080531171359.qnavryt4@webmail.dslextreme.com>
	<20080531231049.725bf4d2@tux>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] PowerColor RA330 (Real Angel 330) fixes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Dâniel Fraga <fragabr <at> gmail.com> writes:

> 	Hi Daniel. Regarding your patch (patch1.diff), I have the
> following problems if I apply it:
> 
> 1) the sound from TV/radio doesn't work

Are you sure you applied it against the current Mercurial tip? I also had no TV
sound when the MTS bit was 1, but I leave it 0, and have sound. FM worked,
regardless.

> 2) the s-video input image worked with tvtime but didn't work with
> mencoder (it recorded everything as a black screen). Without your patch
> (and using v25 firmware, mencoder works fine). I record using:
> 
> mencoder -tv device=/dev/video1:input=2:norm=pal-m:amode=1 -ovc lavc
> -lavcopts vcodec=mpeg4:mbd=1 -oac mp3lame
> -o /home/fraga/src/tvrecord-${TODAY}-${NOW}.avi tv://

I used this line to test TV:
mplayer tv://54 -tv
chanlist=us-cable:normid=7:input=1:amode=1:immediatemode=0:alsa -vo xv -ao alsa

To test S-Video, I simply replaced "input=1" with "input=3" in the same line.

> 	I'm using the following firmware:
> 
> e7ffa23f8898839ebeb6e2e8b65f829e  xc3028-v27.fw

I get:
$ md5sum /lib/firmware/xc3028-v27.fw
293dc5e915d9a0f74a368f8a2ce3cc10  /lib/firmware/xc3028-v27.fw

It's from the download now referenced in the current extraction script.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
