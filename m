Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:39050 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbaK0Fpq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 00:45:46 -0500
Received: by mail-qg0-f48.google.com with SMTP id q107so3043986qgd.7
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 21:45:46 -0800 (PST)
Date: Thu, 27 Nov 2014 02:45:42 -0300
From: Ismael Luceno <ismael.luceno@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	"hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>,
	Curtis Hall <chall@corp.bluecherry.net>
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any
 ideas or help?
Message-ID: <20141127024542.071fa54e@pirotess.bf.iodev.co.uk>
In-Reply-To: <54624FF1.2060102@xs4all.nl>
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
	<54624FF1.2060102@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/w3.oc4=GE1v6JtNxDTGQ2Pv"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/w3.oc4=GE1v6JtNxDTGQ2Pv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Nov 2014 19:05:37 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 11/11/2014 06:46 PM, Andrey Utkin wrote:
> > At Bluecherry, we have issues with servers which have 3 solo6110
> > cards (and cards have up to 16 analog video cameras connected to
> > them, and being actively read).
> > This is a kernel which I tested with such a server last time. It is
> > based on linux-next of October, 31, with few patches of mine (all
> > are in review for upstream).
> > https://github.com/krieger-od/linux/ . The HEAD commit is
> > 949e18db86ebf45acab91d188b247abd40b6e2a1 at the moment.
> >=20
> > The problem is the following: after ~1 hour of uptime with working
> > application reading the streams, one card (the same one every time)
> > stops producing interrupts (counter in /proc/interrupts freezes),
> > and all threads reading from that card hang forever in
> > ioctl(VIDIOC_DQBUF). The application uses libavformat (ffmpeg) API
> > to read the corresponding /dev/videoX devices of H264 encoders.
> > Application restart doesn't help, just interrupt counter increases
> > by 64. To help that, we need reboot or programmatic PCI device
> > reset by "echo 1 > /sys/bus/pci/devices/0000\:03\:05.0/reset",
> > which requires unloading app and driver and is not a solution
> > obviously.
> >=20
> > We had this issue for a long time, even before we used libavformat
> > for reading from such sources.
> > A few days ago, we had standalone ffmpeg processes working stable
> > for several days. The kernel was 3.17, the only probably-relevant
> > change in code over the above mentioned revision is an additional
> > bool variable set in solo_enc_v4l2_isr() and checked in
> > solo_ring_thread() to figure out whether to do or skip
> > solo_handle_ring(). The variable was guarded with
> > spin_lock_irqsave(). I am not sure if it makes any difference, will
> > try it again eventually.
> >=20
> > Any thoughts, can it be a bug in driver code causing that (please
> > point which areas of code to review/fix)? Or is that desperate
> > hardware issue? How to figure out for sure whether it is the former
> > or the latter?
>=20
> I would first try to exclude hardware issues: since you say it is
> always the same card, try either replacing it or swapping it with
> another solo card and see if the problem follows the card or not. If
> it does, then it is likely a hardware problem. If it doesn't, then it
> suggests a race condition in the interrupt handling somewhere.
>=20
> Regards,
>=20
> 	Hans

CC'ing Curtis, hope you don't mind.

It's just coincidence. This has been a long standing issue, and only
depends on having enough cards.

One of the problems I had to weed out this one was that I didn't
have the right hardware (only one 16-port card), and my guess is that
Andrey is in the same position.

--Sig_/w3.oc4=GE1v6JtNxDTGQ2Pv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUdrqGAAoJEBH/VE8bKTLbScUIAI1kNAgTpBLzvWO5jm3LZRT/
WlJ7nXPzzYgop2Q5DtwcTCz1/qCnlO/sjgrP2HfxYp6zg6zZr3voeQ3DNBCmSvfY
y/FzicimItCYRmyZkKwxULS6QQpuJLJc5rzq9evfObmzPsxyv84USPa0CK4Eb/7s
mH38UfNiIYesMKCfWtkJ/UBJCsiV8fCiTZ+Jjlhy4zsJpOG7qD7xajPMhjq1UCGE
gjPkWeVvQy8CE5BODX95T0AFRe8KwsBEj9jUZ4iWxIM/lJlmrwsYeZz5bwo+tzwz
plOmJzHUAswKD76r2bSOcmyEhhynJ3N58nlC5U89QcAVZAIlhn+zWMeylLYOQNc=
=RE6p
-----END PGP SIGNATURE-----

--Sig_/w3.oc4=GE1v6JtNxDTGQ2Pv--
