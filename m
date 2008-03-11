Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2BLQDj9016482
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 17:26:13 -0400
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2BLPcVt032626
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 17:25:39 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: itman <itman@fm.com.ua>
In-Reply-To: <063801c88370$5594f3a0$6401a8c0@LocalHost>
References: <000f01c808e7$3ab4e3a0$6401a8c0@LocalHost>
	<1191845080.3506.82.camel@pc08.localdom.local>
	<007f01c80e7d$21c02300$6401a8c0@LocalHost>
	<1192788480.18371.4.camel@gaivota>
	<Pine.LNX.4.58.0710190951100.16052@shell4.speakeasy.net>
	<471A4011.8010706@fm.com.ua> <1192922346.4857.8.camel@gaivota>
	<003701c81410$869e6960$6401a8c0@LocalHost>
	<1193043044.30686.22.camel@gaivota>
	<003a01c8150f$6a248490$6401a8c0@LocalHost>
	<1193103690.14811.10.camel@pc08.localdom.local>
	<000401c8151a$080ef4b0$6401a8c0@LocalHost>
	<1193107021.5728.20.camel@gaivota> <1193107692.5728.23.camel@gaivota>
	<002701c8812f$33c6ed20$6501a8c0@LocalHost>
	<1205004114.3358.29.camel@pc08.localdom.local>
	<063801c88370$5594f3a0$6401a8c0@LocalHost>
Content-Type: text/plain; charset=utf-8
Date: Tue, 11 Mar 2008 22:17:41 +0100
Message-Id: <1205270261.5927.84.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: simon@kalmarkaglan.se, Linux and Kernel Video <video4linux-list@redhat.com>,
	Trent Piepho <xyzzy@speakeasy.org>, MIDIMaker <midimaker@yandex.ru>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: 2.6.24 kernel and MSI TV @nywheremaster MS-8606 status
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

Hi Serge,

Am Dienstag, den 11.03.2008, 14:06 +0200 schrieb itman:
> Hi, Hermann.
> 
> Yea I have seen changes. But the question is about: How to build fresh v4l 
> (with MSI patches)  for 2.6.24 ?
> 
> With this procedure it does not work:
> 
> 1) cd /usr/src/linux   ; kernel 2.6.24.3 srs
> 2) mkdir v4lnew
> 3) cd ./v4lnew
> 4) hg init
> 5)  hg pull http://linuxtv.org/hg/v4l-dvb
hg update

> 6) make
> 7) make install

you can do this to, but I just keep v4l-dvb as working directory.

> As result I've got working modules BUT module tuner, as I  mentioned in 
> previous message, does not have any! of important parameters: port1, port2, 
> qss.

As said already, the tda9887 module is factored out of the tuner again.
The only thing you can do wrong is to select "Customize analog tuner
support" and then disable tuner simple and the tda9886 or the microtune
mt20xx.

Else try "modinfo tda9887" again and set the port options for it, qss=1
is default since some years.

> Did something change? What is exect procedure of building v4l for new 
> 2.6.24.3 kernel?
> 
> Last time Mauro created this one repository for 2.6.23 
> http://linuxtv.org/hg/~mchehab/fm8606 and archieved one: 
> http://linuxtv.org/hg/~mchehab/fm8606/archive/tip.tar.bz2.
> 
> Is it possible to make the same for 2.6.24? or just make it clear - what 
> should be do for building new v4l with patches under 2.6.24.3 vanila kernel?
> 
> Rgs,
>     Serge.
> 

The patches are in v4l-dvb master and 2.6.25.

Since some modules change from kernel to kernel, except tuner related
like tda9887 and tea5767 also video-buf and saa7134-oss come in mind,
it is like you would change from the recent to a very old snapshot and
also the other way round.

In such a case "make rmmod" and "make rminstall" are only fully safe
from the version of v4l-dvb you have installed from.
Since v4l-dvb master is currently in good sync with 2.6.25, a
"ls -R /lib/modules/2.6.25-rc5/kernel/drivers/media |grep .ko"
will find no remaining modules after "rmmod" and "rminstall".

On older kernels you might take a little care to get everything unloaded
with "modprobe -vr" and eventually have to remove some remaining old
modules manually before you run "make install" the first time, but that
is all.

After that it is easy for example to replace the recent v4l-dvb with the
original kernel modules again. Just "make rmmod" and "make rminstall"
from v4l-dvb and "make modules_install" from the vanilla source will do
the job. You have to take care to change the port options again for now,
sorry for that.

For the situation on that card.
The PAL and NTSC versions of the card have the same PCI subsystem and we
can't make a difference. The NTSC version only has sound with qss=0
intercarrier demodulation. Lucas Endress kindly did some testing and the
port options seem not to matter for NTSC-M, but Torsten at DScaler seems
to have reports that port1=0 improves NTSC-M. Also on PAL-I TOP
adjust=0x0e seems to do something.
Maybe we can set port1=0 and port2=0 in the card's entry without side
effects, at least we don't have to care for special radio mode settings
like on the Philips tuners, but we don't have it per tuner and tv norm,
like we would like to have for the users.

Also the analog demodulation of these cards is more card than tuner
specific, the discretes like tda9885/6/7 and SAW filters are not in a
defined tuner area or even tuner housing, this opens ways for other
unexpected manufacturer specific specials. Some power off with port2=0,
others have the ports involved in digital versus analog usage switching.

That's about where it stands.

Cheers,
Hermann


> 
> ----- Original Message ----- 
> From: "hermann pitton" <hermann-pitton@arcor.de>
> To: "itman" <itman@fm.com.ua>
> Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>; 
> <simon@kalmarkaglan.se>; "Linux and Kernel Video" 
> <video4linux-list@redhat.com>; "MIDIMaker" <midimaker@yandex.ru>; "Trent 
> Piepho" <xyzzy@speakeasy.org>
> Sent: Saturday, March 08, 2008 9:21 PM
> Subject: Re: 2.6.24 kernel and MSI TV @nywheremaster MS-8606 status
> 
> 
> > Hi Serge,
> >
> > Am Samstag, den 08.03.2008, 17:15 +0200 schrieb itman:
> >> Hi, Mauro.
> >>
> >> Could you please be so kind to mention which is right mercurial 
> >> repository
> >> to which you have merged your changes and which one should be used for
> >> 2.6.24 kernel?
> >>
> >
> > the changes are as changesets 6384 to 6388 in the master repo.
> > Try "hg log" and to review them for example "hg export 6388", where you
> > will find the credit for your gpio contribution.
> >
> >> I've got issue:
> >>
> >> Trying now to build drivers for MSI TV @nywheremaster MS-8606 under 
> >> kernel
> >> 2.6.24.3.
> >>
> >> What were done:
> >>
> >> 1) mkdir /usr/src/linux/tmpmsi
> >> 2) cd tmpmsi
> >> 3) hg init v4l-dvb
> >> 4) hg pull http://linuxtv.org/hg/v4l-dvb
> >> 5) cd v4l-dvb
> >> 6) make
> >> 7) make install
> >>
> >>
> >> As result I've got cx88-cards.c with fixed gpio for MSI TV @anywhere BUT!
> >> there are no main parameters for module tuner: port1, port2, qss.
> >
> > Mike is doing some major syncing over the tuning systems,
> > so currently you set your port options for your mt2050 again to the
> > tda9887 module, like "options tda9887 port1=0 port2=0"
> > in /etc/modprobe.conf and "depmod -a".
> >
> > Since under tuner mt20xx are different tuners subsumed, and IIRC not all
> > can be identified safely per card, type and tv standard reception
> > abilities, hence this not very nice but functional
> > TDA9887_INTERCARRIER_NTSC in your card's entry, we have the tda9887
> > config not yet per tuner in tuner-types.c, like we have it for the
> > Philips types now.
> >
> > Best identification so far has Gunther for miro_pinnacle_gpio bttv
> > cards.
> >
> > Cheers,
> > Hermann
> >
> >>  head Makefile
> >> BUILD_DIR := $(shell pwd)/v4l
> >> TMP ?= /tmp
> >> REPO_PULL := http://linuxtv.org/hg/v4l-dvb
> >>
> >>
> >>
> >>  modinfo  tuner
> >> filename:       /lib/modules/2.6.24.3/kernel/drivers/media/video/tuner.ko
> >> license:        GPL
> >> author:         Ralph Metzler, Gerd Knorr, Gunther Mayer
> >> description:    device driver for various TV and TV+FM radio tuners
> >> depends:
> >> tea5761,v4l2-common,mt20xx,tuner-simple,tda9887,videodev,tea5767,xc5000,tuner-xc2028,tda8290
> >> vermagic:       2.6.24.3 preempt mod_unload PENTIUM4
> >> parm:           force:List of adapter,address pairs to boldly assume to 
> >> be
> >> present (array of short)
> >> parm:           probe:List of adapter,address pairs to scan additionally
> >> (array of short)
> >> parm:           ignore:List of adapter,address pairs not to scan (array 
> >> of
> >> short)
> >> parm:           addr:int
> >> parm:           no_autodetect:int
> >> parm:           show_i2c:int
> >> parm:           debug:int
> >> parm:           pal:string
> >> parm:           secam:string
> >> parm:           ntsc:string
> >> parm:           tv_range:array of int
> >>
> >> With best regards,
> >>
> >>             Serge Kolotylo
> >>
> >>
> >> __________________________
> >>
> >> Em Ter, 2007-10-23 às 05:11 +0300, itman escreveu:
> >> > After modprobe tuner port1=0 port2=0 qss=1 it works GREAT both TV
> >> > (sound is
> >> > clear and loud) and radio (sound is clear and loud) with DEFAULT
> >> > (card=7,
> >>
> >> Great! If you send us the proper tuner name, marked at the metallic can
> >> inside the board, we may add those tda9887 options at tuner-types.c.
> >> This way, passing the parameters to tuners can be avoided.
> >>
> >> > PS: will it be merged these changes to vanilla kernel soon?
> >>
> >> I've already merged into v4l-dvb tree. However, since this is changing
> >> some stuff at the existing driver, the addition at mainstream should be
> >> postponed to kernel 2.6.25.
> >>
> >
> >


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
