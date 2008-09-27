Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate05.web.de ([217.72.192.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <okleinecke@web.de>) id 1KjOJk-0005yq-A7
	for linux-dvb@linuxtv.org; Sat, 27 Sep 2008 03:09:52 +0200
Received: from web.de
	by fmmailgate05.web.de (Postfix) with SMTP id 169725948E84
	for <linux-dvb@linuxtv.org>; Sat, 27 Sep 2008 03:09:19 +0200 (CEST)
Date: Sat, 27 Sep 2008 03:09:17 +0200
Message-Id: <1959677029@web.de>
MIME-Version: 1.0
From: Oliver Kleinecke <okleinecke@web.de>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
 =?iso-8859-15?q?Need_help_getting_the_remote_of_a_Nov?=
 =?iso-8859-15?q?a-T_USB-Stick_to_work?=
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> -----Urspr=FCngliche Nachricht-----
> Von: "Devin Heitmueller" <devin.heitmueller@gmail.com>
> Gesendet: 26.09.08 19:27:52
> An: "Oliver Kleinecke" <okleinecke@web.de>
> CC: linux-dvb@linuxtv.org
> Betreff: Re: [linux-dvb] Need help getting the remote of a Nova-T USB-Sti=
ck to work


> 2008/9/26 Oliver Kleinecke <okleinecke@web.de>:
> > I compiled the latest stable v4l-dvb-drivers, everything worked fine, a=
nd i`m able to watch tv with kaffeine and mythtv already.
> > Now i would like to get the remote to work .. the ir-receiver shows up =
during boot, giving the following ouput :
> >
> > "kernel: input: IR-receiver inside an USB DVB receiver as /class/input/=
input7".
> >
> > If i do a lsinput, the device shows up like this :
> >
> > /dev/input/event7
> >   bustype : BUS_USB
> >   vendor  : 0x2040
> >   product : 0x7070
> >   version : 256
> >   name    : "IR-receiver inside an USB DVB re"
> >   phys    : "usb-0001:10:1b.2-1/ir0"
> >   bits ev : EV_SYN EV_KEY
> >
> >
> > so i`m pretty sure i am not toooo far away from the solution.
> >
> > but if i press a button on the rc, it just gives me kernel messages lik=
e this :
> >
> > "kernel: dib0700: Unknown remote controller key: 1D  2  0  0"
> >
> >
> > After a bit of googling, i found out, that there seems to be a solution=
, using a diff file, which i downloaded already, its attached to this mail.
> >
> > Now i need a bit of support in using this diff-file correctly, and some=
 infos on how to continue then..
> =

> That patch looks pretty straightforward.  Where did it come from?
> Have you tried it out:
> =

> cd v4l-dvb
> patch -p0 < path_to_patch_file
> make
> make install
> reboot
> See if it works...
> =

> (or you might have to do "patch -p1", depending on the patch)
> =

> If it works for you, it can be checked in so others won't have to deal
> with the problem in the future.
> =

> Devin
> =

> -- =

> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
> =


Hi, thanks for the fast answer !

After patching, recompile + install it works now.
At first i had the problem that the system reacted as if i pressed the rc-b=
utton constantly, when i just pressed it once, but after a fresh install of=
 my etch (i think i messed up my system a bit before), it now works perfect=
ly.

I found this diff file in the following thread : http://mandrihinkvauser.de=
/viewtopic.php?id=3D22141

Thanks, Oliver

PS : While trying to compile the drivers, i always get an error concerning =
the file "af9015.c" in the dvb-usb drivers section. Since i don` t need thi=
s module, i could easily compile the driver using "make -i", but there seem=
 to be some errors in the case-structur in lines 747 and following of the m=
entioned file.

_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=3D100071&distributionid=3D000000000066


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
