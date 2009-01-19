Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:52474 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbZASJnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 04:43:16 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2540228rvb.1
        for <linux-media@vger.kernel.org>; Mon, 19 Jan 2009 01:43:15 -0800 (PST)
From: Brendon Higgins <blhiggins@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: Regression since 2.6.25 kernel: Crash of userspace program leaves DVB device unusable
Date: Mon, 19 Jan 2009 19:43:01 +1000
Cc: Andy Walls <awalls@radix.net>
References: <200901031200.56314.blhiggins@gmail.com> <200901191337.31272.blhiggins@gmail.com> <1232338898.3242.27.camel@palomino.walls.org>
In-Reply-To: <1232338898.3242.27.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart17121920.XzapWruI0y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901191943.06631.blhiggins@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart17121920.XzapWruI0y
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Andy Walls wrote (Monday 19 January 2009):
> On Mon, 2009-01-19 at 13:37 +1000, Brendon Higgins wrote:
> > > [snip]
>
> Well, you have the clues actually; they're in your log files.

Thanks Andy for prompting me to look at things again. I've discovered=20
something interesting about the way runvdr, a script which tries to keep vd=
r=20
alive (might be Debian custom, I'm not sure), interacts with the modules. W=
hen=20
vdr crashes, runvdr attempts to remove and re-load the dvb modules before=20
restarting vdr. Presumably this is a workaround for any modules left in a b=
ad=20
state.

Interestingly though, the script doesn't take the module dependency tree in=
to=20
account, only the first level branches, and so most of its rmmod commands f=
ail=20
since the modules are in use by other modules. In my case it attempts to=20
remove videobuf_dvb, cx88_dvb, and dvb_core, in that order. Only rmmod=20
cx88_dvb succeeds.

Now the really interesting part: soon after that, runvdr tries to modprobe =
all=20
those modules back in again. Trying to modprobe videobuf_dvb and dvb_core d=
oes=20
nothing since they weren't unloaded. But trying to modprobe cx88_dvb fails:=
=20
"FATAL: Error inserting cx88_dvb=20
(/lib/modules/2.6.28/kernel/drivers/media/video/cx88/cx88-dvb.ko): No such=
=20
device"

Only after "rmmod cx8802" can cx88_dvb be loaded successfully.

=46inally I've found a way to reproduce the bug on command! Hurrah!

Summary procedure, starting with a working dvb:
1) rmmod cx88_dvb
2) modprobe cx88_dvb
Error: No such device.
3) rmmod cx8802
4) modprobe cx88_dvb
Success (and cx8802 is pulled in automatically)

So it seems there might be some sort of module interdependency not being ta=
ken=20
care of. I'll try to report the runvdr tree problem to the relevant place=20
later.

> At the time of the crash, what shows up in dmesg, /var/log/messages, and
> any log that VDR creates?

Here's what's in /var/log/syslog when I perform the above procedure (with m=
y=20
best-guess labels as to when I did what):

rmmod cx88_dvb:
Jan 19 19:24:27 phi kernel: [15162.725955] cx88/2: unregistering cx8802=20
driver, type: dvb access: shared
Jan 19 19:24:27 phi kernel: [15162.725967] cx88[0]/2: subsystem: 18ac:db10,=
=20
board: DViCO FusionHDTV DVB-T Plus [card=3D21]
Jan 19 19:24:27 phi kernel: [15162.725972] cx88[0]/2-dvb: cx8802_dvb_remove

modprobe cx88_dvb:
Jan 19 19:24:32 phi kernel: [15167.399736] cx88/2: cx2388x dvb driver versi=
on=20
0.0.6 loaded
Jan 19 19:24:32 phi kernel: [15167.399744] cx88/2: registering cx8802 drive=
r,=20
type: dvb access: shared
Jan 19 19:24:32 phi kernel: [15167.399752] cx88[0]/2: subsystem: 18ac:db10,=
=20
board: DViCO FusionHDTV DVB-T Plus [card=3D21]
Jan 19 19:24:32 phi kernel: [15167.399757] cx88[0]/2-dvb: cx8802_dvb_probe
Jan 19 19:24:32 phi kernel: [15167.399761] cx88[0]/2-dvb:  ->being probed b=
y=20
Card=3D21 Name=3Dcx88[0], PCI 01:06
Jan 19 19:24:32 phi kernel: [15167.399766] cx88[0]/2: cx2388x based DVB/ATS=
C=20
card
Jan 19 19:24:32 phi kernel: [15167.399771] cx8802_dvb_probe() failed to get=
=20
frontend(1)
Jan 19 19:24:32 phi kernel: [15167.399775] cx88[0]/2: dvb_register failed (=
err=20
=3D -22)
Jan 19 19:24:32 phi kernel: [15167.399779] cx88[0]/2: cx8802 probe failed, =
err=20
=3D -22

rmmod cx8802:
Jan 19 19:25:06 phi kernel: [15200.890797] cx88-mpeg driver manager=20
0000:01:06.2: PCI INT A disabled

modprobe cx88_dvb:
Jan 19 19:25:07 phi kernel: [15201.996410] cx88/2: cx2388x MPEG-TS Driver=20
Manager version 0.0.6 loaded
Jan 19 19:25:07 phi kernel: [15201.996464] cx88[0]/2: cx2388x 8802 Driver=20
Manager
Jan 19 19:25:07 phi kernel: [15201.996489] cx88-mpeg driver manager=20
0000:01:06.2: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
Jan 19 19:25:07 phi kernel: [15201.996502] cx88[0]/2: found at 0000:01:06.2=
,=20
rev: 5, irq: 16, latency: 32, mmio: 0xfb000000
Jan 19 19:25:07 phi kernel: [15201.996516] cx8802_probe() allocating 1=20
frontend(s)
Jan 19 19:25:07 phi kernel: [15202.001647] cx88/2: cx2388x dvb driver versi=
on=20
0.0.6 loaded
Jan 19 19:25:07 phi kernel: [15202.001655] cx88/2: registering cx8802 drive=
r,=20
type: dvb access: shared
Jan 19 19:25:07 phi kernel: [15202.001661] cx88[0]/2: subsystem: 18ac:db10,=
=20
board: DViCO FusionHDTV DVB-T Plus [card=3D21]
Jan 19 19:25:07 phi kernel: [15202.001667] cx88[0]/2-dvb: cx8802_dvb_probe
Jan 19 19:25:07 phi kernel: [15202.001671] cx88[0]/2-dvb:  ->being probed b=
y=20
Card=3D21 Name=3Dcx88[0], PCI 01:06
Jan 19 19:25:07 phi kernel: [15202.001676] cx88[0]/2: cx2388x based DVB/ATS=
C=20
card
Jan 19 19:25:07 phi kernel: [15202.002518] DVB: registering new adapter=20
(cx88[0])
Jan 19 19:25:07 phi kernel: [15202.002526] DVB: registering adapter 0 front=
end=20
0 (Zarlink MT352 DVB-T)...

Note the "failed to get frontend(1)" in the first modprobe.

> Since modprobe after the crash failed with -ENODEV ["...cx88-dvb.ko): No
> such device], a quick grep through cx88-dvb.c in the source shows that
> that can only happen in a few places.  It should be easy to spot in the
> logs.  Adding an
>
> 	options cx88_dvb debug=3D1
>
> line to /etc/modprobe.conf would make things easier to see in the logs
> as well.

Thanks, I didn't know about that. The above syslog info ought to have been=
=20
produced with that option in effect.

> Also what is the source of your cx88 driver: Debian Testing or the
> v4l-dvb repo?

It comes in the stock kernels that I built and tested (2.6.26 was the Debia=
n=20
pre-packaged kernel, the others were built from kernel.org source via make-
kpkg).

> > Or care?
>
> The issue is usually not one of caring, but one of having
> time, the specific hardware, and ability to reporduce the problem.

Of course. When your first two emails about a problem get no response, it=20
starts looking like a plausible explanation, you know?

Peace,
Brendon


--nextPart17121920.XzapWruI0y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl0SyYACgkQCTfPD0Uw3q9qjACgoBCQz/vjNWDlfTROlVw27nMI
uZYAoLE/Ei754g+UODOSENi7SRD3y6WU
=jOzq
-----END PGP SIGNATURE-----

--nextPart17121920.XzapWruI0y--
