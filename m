Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1L0EG5-0001df-9b
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 12:51:42 +0100
Date: Wed, 12 Nov 2008 12:51:07 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <E1L09Ud-000GW2-00.goga777-bk-ru@f149.mail.ru>
Message-ID: <20081112115107.217170@gmx.net>
MIME-Version: 1.0
References: <20081112023112.94740@gmx.net>
	<E1L09Ud-000GW2-00.goga777-bk-ru@f149.mail.ru>
To: Goga777 <goga777@bk.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
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

> > I have attached two patches for scan-s2 at
> http://mercurial.intuxication.org/hg/scan-s2.
> > =

> > Patch1: Some fixes for problems I found. QAM_AUTO is not supported by
> all drivers,
> > in particular the HVR-4000, so one needs to use QPSK as the default and
> ensure that
> > settings are parsed properly from the network information -- the new S2
> FECs and
> > modulations were not handled.
> > =

> > Patch2: Add DiSEqC 1.2 rotor support. Use it like this to move the dish
> to the correct
> > position for the scan:
> >  scan-s2 -r 19.2E -n dvb-s/Astra-19.2E
> >  or
> >  scan-s2 -R 2 -n dvb-s/Astra-19.2E
> > =

> > A file (rotor.conf) listing the rotor positions is used (NB: rotors vary
> -- do check your
> > rotor manual).
> =

> =

> thanks for your patch.
> =

> btw - could you scan dvb-s2 (qpsk & 8psk) channels with scan-s2 and
> hvr4000 ? with which drivers ?
> =

> Goga

Yes I could scan DVB-S and DVB-S2 (both QPSK and 8PSK) in one command with =
the =

HVR4000. The satellite delivery system descriptor parsing is used to set DV=
B-S/-S2 and
QPSK/8PSK and FEC. I used the s2-liplianin drivers (only because I am also =
testing a
stb0899 vp1041 card at the moment). It should also work with the v4l-dvb dr=
ivers but
I didn't try yet.

Also there is some network information on 19.2E which points to 23.5E so th=
e rotor is moved
during the scan to 23.5E and then back to 19.2E depending on the transponde=
r. :).

Hans


-- =

Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
