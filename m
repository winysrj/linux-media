Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m33NZb13002792
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 19:35:37 -0400
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net
	[151.189.21.52])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m33NZNgW005443
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 19:35:23 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: cherOKe@gmail.com
In-Reply-To: <1207264453.21932.11.camel@fugitif>
References: <1207182705.31477.17.camel@fugitif>
	<1207253648.15452.62.camel@pc08.localdom.local>
	<1207264453.21932.11.camel@fugitif>
Content-Type: text/plain; charset=utf-8
Date: Fri, 04 Apr 2008 01:35:20 +0200
Message-Id: <1207265720.3364.19.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] i can't make my Lifeview trio CARDBUS works.
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

Am Freitag, den 04.04.2008, 01:14 +0200 schrieb cherOKe:
> El jue, 03-04-2008 a las 22:14 +0200, hermann pitton escribió:
> > Hi,
> > 
> > Am Donnerstag, den 03.04.2008, 02:31 +0200 schrieb cherOKe:
> > > Hi, it's my first timer here, i'm cheroke from spain. 
> > > 
> > > I,ve trying to istall y lifeview trio several times with no good
> > > results, the only that I've made works it's analog tv without sound :(.
> > 
> > for devices without analog sound out you need a helper application like
> > "sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -w -r 48000 /dev/dsp"
> > to get the sound from here assumed saa7134-alsa device /dev/dsp1 to your sound card.
> > 
> > Only mplayer and mencoder support this directly from the saa7134-alsa dsp with immediatemode=0.
> > 
> > Sample commands could look like.
> > 
> > /usr/local/bin/mplayer -v tv:// -vf pp=lb -tv driver=v4l2:norm=PAL:input=0:alsa:adevice=hw.1,0:forceaudio:immediatemode=0:audiorate=32000:amode=1:width=640:height=480:outfmt=yuy2:device=/dev/video0:chanlist=europe-west:channel=E9
> > 
> > /usr/local/bin/mencoder -v tv:// -tv driver=v4l2:device=/dev/video0:width=640:height=480:chanlist=europe-west:alsa:adevice=hw.1,0:audiorate=32000:amode=1:forceaudio:volume=95:immediatemode=0:norm=PAL -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=3600 -vf pp=lb -oac mp3lame -lameopts cbr:br=128:mode=0 -o mytest.avi
> ...............
> > 
> > OK, I assume you have a recent v4l-dvb master copy now.
> > 
> ...............
> > On older kernels, like 2.6.20, a simple "make" does not make all it
> > seems, also "make allmodconfig" doesn't work. You get all bttv, cx88,
> > saa7134 related and others not built. This might be the case here.
> > 
> > This results in a mixture of incompatible old and new modules after
> > "make install".
> > 
> > Try "make distclean" and then "make xconfig" and enable all missing
> > modules, also go through dvb and check that the related frontends
> > tda10045/46 and tda10086 and the isl6421 are ready, see it with
> > customize dvb froontends. In short enable all you can and if possible
> > always as modules. Then "make".
> > 
> > If installing first time on an older kernel, try to make sure you have 
> > really all older *.ko removed from /lib/modules/uname -r/kernel/drivers/media
> > 
> > With "make rmmod" you might not be able to unload all modules and might
> > try to get the rest with "modprobe -vr" or must reboot later.
> > 
> > Do "make rminstall", this should remove all *.ko from the media folder,
> > but check with "ls -R |grep .ko" there and remove/delete any remaining
> > module. Do "make install". Reboot if there are any related modules still
> > loaded.
> > 
> > If you want to test DVB-S, it is best to put
> > "options saa7134-dvb use_frontend=1" in /etc/modprobe.conf or what your
> > distribution uses else for module options and "depmod -a".
> > 
> > Also put "options saa7134 card=84 latency=64" something there to avoid
> > card=0 on boot, but from now on everything else should work too.
> > 
> > If it should have a remote, support is not in tree, if it has radio
> > support, please test. Please report, that we might be able to add it to
> > auto detection. We have one previous report for now and that cardbus
> > version was functional so far.
> > 
> > Happy testing,
> > 
> > Hermann
> > 
> Hi, 
> Thanks you for responding, i'll try to digest all the information yo give me, and testing.
> I'll report results as soon i have.
> I'm using Ubuntu 8.04 (development branch) kernel2.6.24-12-generic.

Hi,

yes, that is true.

Had a first look 24 hours back and missed the 2.6.24 now, but the
pattern should still be valid for _all_ supported kernels, but 2.6.24 is
not exactly in question ;)

You have some nice module mess anyway.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
