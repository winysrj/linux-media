Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m83GmHhB008926
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 12:48:18 -0400
Received: from n43.bullet.mail.ukl.yahoo.com (n43.bullet.mail.ukl.yahoo.com
	[87.248.110.176])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m83Gm6h6022866
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 12:48:07 -0400
From: Lars Oliver Hansen <lolh@ymail.com>
To: Markus Rechberger <mrechberger@gmail.com>
In-Reply-To: <d9def9db0809021639u1e5774dek7014597cf3364707@mail.gmail.com>
References: <1220396812.3752.46.camel@lars-laptop>
	<d9def9db0809021639u1e5774dek7014597cf3364707@mail.gmail.com>
Date: Wed, 03 Sep 2008 18:48:04 +0200
Message-Id: <1220460484.6279.29.camel@lars-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: em28xx-based KWorld 310U delivers no signal, 2 drivers tried
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

Hi,

Am Mittwoch, den 03.09.2008, 01:39 +0200 schrieb Markus Rechberger:

> 2008/9/3 Lars Oliver Hansen <lolh@ymail.com>:
> > Hello,



> > What are the best working options to get my KWorld DVB-T 310U usable in
> > analog TV mode at least? Which driver to I have to take, what would I
> > have to do?



> > I'm on Ubuntu 8.04
> > but I have a vanilla kernel 2.6.27-rc5 source at hand  (yes which I
> > configured, compiled and have working with Ubuntu in another grub
> > entry :-)), which v4l drivers would I have to enable there to use that
> > kernels drivers?
> >
> > Thanks fro any help!
> >
> 
> audio especially for that device will take a few more days in a
> default ubuntu environment for that device it's work in progress.
> 
> you might read through the em28xx mailinglist, it has several
> information how to get most of that device work (there's no need to
> grab an extra firmware from somewhere).
> 
> Markus


What's the state of each of your 3 trees v4l-dvb-kernel,
v4l-dvb-experimental and em28xx-new? I noticed that the last entry to
your v4l trees is around 4 months old in both cases and that they both
received updates at around the same times. Is there a difference in the
experimental tree from the kernel tree? Is every file affected or were
only some added/changed? I gathered from gnames archive of your em28xx
mailing list that you have an em28xx-new tree. Unfortunately I found
only 5 posts regarding the 310U, yet many regarding the 300. Will your
new tree support the chips that come with the em2883 like the XCeive
3028? Your kernel driver gave the 310U the status of a DVB-T device and
w_scan worked, unfortunately the analog part was unstable as mentioned
in my first e-mail and I have no DVB-T viewing application under Gnome
(or they don't work (Totem misses the channels.conf and I don't know
where to put it and mplayers gui has no TV controls and I haven't
figured out its command line spec and I don't know whether I want to)).
The v4l-dvb driver from the v4l wikis main-page (so not yours) didn't
give the 310U the status of a DVB-T device so it would just work for
analog.
The v4l wiki has many different pages which tell similar things but they
are not linked with each other and sometimes one leads there while the
other leads elsewhere and the information obtained then is different.
For example regarding the em28xx it is said that only analog works but
the xc3028 which may come with an em28xx (as in my case) is said to have
support for DVB-T yet the v4l-dvb driver didn't make the device a DVB-T
one. Is that the em28xx drivers "fault"?
Also there is a seperate wiki for dvb-t which I think is unneccessary.
They are pointing to the same repository (v4l-dvb) and the same people
are working on the driver, isn't this the case? It would be sufficient
if the linuxTV wiki split the technical section only into one for
dvb-info and one for analog info. And where would the hybrid people go?

Lars
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
