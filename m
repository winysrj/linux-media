Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JbtSN-0006uR-Hk
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 09:15:35 +0100
Received: from mail01.m-online.net (mail.m-online.net [192.168.3.149])
	by mail-out.m-online.net (Postfix) with ESMTP id CF7C721D81B
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 09:15:05 +0100 (CET)
Received: from localhost (unknown [192.168.1.157])
	by mail.m-online.net (Postfix) with ESMTP id 42D8E90285
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 09:14:58 +0100 (CET)
Received: from mail.mnet-online.de ([192.168.3.149])
	by localhost (scanner1.m-online.net [192.168.1.157]) (amavisd-new,
	port 10024) with ESMTP id juUTFUh92ZVu for <linux-dvb@linuxtv.org>;
	Wed, 19 Mar 2008 09:14:57 +0100 (CET)
Received: from gauss.x.fun (ppp-88-217-99-34.dynamic.mnet-online.de
	[88.217.99.34]) by mail.nefkom.net (Postfix) with ESMTP
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 09:14:57 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by gauss.x.fun (Postfix) with ESMTP id DD1E01E7C9A
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 09:14:56 +0100 (CET)
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Wed, 19 Mar 2008 09:14:55 +0100
References: <47A5D8AF.2090800@googlemail.com>
	<1205875868.3385.133.camel@pc08.localdom.local>
	<1205904196.6510.3.camel@ubuntu>
In-Reply-To: <1205904196.6510.3.camel@ubuntu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803190914.56106.zzam@gentoo.org>
Subject: Re: [linux-dvb]
	=?iso-8859-1?q?Any_chance_of_help_with_v4l-dvb-experi?=
	=?iso-8859-1?q?mental_/=09Avermedia_A16D_please=3F?=
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mittwoch, 19. M=E4rz 2008, timf wrote:
> Hi all,
>
> On Tue, 2008-03-18 at 22:31 +0100, hermann pitton wrote:
> > Hi,
> >
> > Am Dienstag, den 18.03.2008, 18:04 -0300 schrieb Mauro Carvalho Chehab:
> > > On Wed, 19 Mar 2008 05:48:52 +0900
> > >
> > > timf <timf@iinet.net.au> wrote:
> > > > 1) New install ubuntu, extract tip.tgz.
> > >
> > > There's no need for you to reinstall Linux for each test. This is not
> > > MS**t ;)
> > >
> > > You don't even need to reboot.
> > >
> > > > [   40.753552] saa7133[0]: i2c scan: found device @ 0xc2  [???]
> > > > [   40.864616] tuner' 2-0061: Setting mode_mask to 0x0e
> > > > [   40.864621] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> > > > [   40.864624] tuner' 2-0061: tuner 0x61: Tuner type absent
> > > > [   40.864658] tuner' 2-0061: Calling set_type_addr for type=3D0,
> > > > addr=3D0xff, mode=3D0x02, config=3D0xffff8100
> >
> > any idea somebody when that was introduced?
> >
> > [   40.753552] saa7133[0]: i2c scan: found device @ 0xc2  [???]
> > [   40.864616] tuner' 2-0061: Setting mode_mask to 0x0e
> > [   40.864621] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> > [   40.864624] tuner' 2-0061: tuner 0x61: Tuner type absent
> > [   40.864658] tuner' 2-0061: Calling set_type_addr for type=3D0,
> > addr=3D0xff, mode=3D0x02, config=3D0xffff8100
> > [   40.864662] tuner' 2-0061: set addr for type -1
> > [   40.876586] tuner-simple 2-0061: creating new instance
> > [   40.876589] tuner-simple 2-0061: type set to 0 (Temic PAL (4002 FH5))
> >
> > Out of historical cruft TUNER_ABSENT is tuner type 4.
> >
> > > mode=3D0x02 is radio.
> > >
> > > Try to add this to the struct:
> > >
> > > .radio_type     =3D UNSET,
> > >
> > > > 3) No DVB, installed tvtime - no signal.
> > >
> > > DVB won't work yet. What the demod inside this board? There's no setup
> > > for it.
> >
> > Cheers,
> > Hermann
>
> Nope, could't get anything to work.
> - blacklisted tuner_xc3028 - no diff still locked up at boot
> - dbg - no module loaded
>

Blacklisting will only work for modules modprobe is called for. These days =

udev does call modprobe so for this to work you need to blacklist saa7134 =

module.
Or: You stop module autoloading in general if your distro offers this optio=
n.

Regards
Matthias

-- =

Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
