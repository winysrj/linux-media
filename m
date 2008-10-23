Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <reklam@holisticode.se>) id 1Kt00e-0006SW-K1
	for linux-dvb@linuxtv.org; Thu, 23 Oct 2008 15:13:55 +0200
From: =?iso-8859-1?Q?M=E5rten_Gustafsson?= <reklam@holisticode.se>
To: <nikke@acc.umu.se>
References: <mailman.1.1224410403.28932.linux-dvb@linuxtv.org>
Date: Thu, 23 Oct 2008 15:13:14 +0200
Message-ID: <44DBF3264FE24C6CBCD74E9A61EB414A@xplap>
MIME-Version: 1.0
In-Reply-To: <mailman.1.1224410403.28932.linux-dvb@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis 2033 dvb-tuning problems
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

Nikke

I tried your patch, and it "improve" things a bit. Kaffeine is able to scan
a few channels now without any entries in /var/log/messages. w_scan finds a
few frequencies, but no services. Scan results are different between scans.
w_scan works "better" if timeout settings are increased.

The channels found by Kaffeine are not viewable, there is something moving,
but I guess the driver is unable to descramble the signal. =


My system is an Ubuntu 8.10 amd64. The network is ComHem and the CI is from
Conax. I also have the AzureWave AD-CP300.

Since this is an improvement I agree with you, Manu should apply the patch.

M=E5rten

-----Ursprungligt meddelande-----


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
On Wed, 15 Oct 2008, Hans Bergersen wrote:

> Hi,
>

> I have got a Twinhan vp-2033 based card. I run Ubuntu 8.04. I have =

> downloaded the driver from http://jusst.de/hg/mantis and it compiled =

> just fine. But when i try to tune a channel the tuning fails. It is =

> a newer card with the tda10023 tuner but when the driver loads it =

> uses the tda10021. What do I have to do to make it use the right =

> tuner? Can i give some options when compiling or when loading the =

> module?
<snip>
> Any ideas?

Try the attached patch which fixes this for my Azurewave AD-CP300 (at =

least last time I compiled it).

I've sent it to Manu and he was going to apply it, but it hasn't shown =

up on http://jusst.de/hg/mantis/ yet...


/Nikke
-- =

-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
  Niklas Edmundsson, Admin @ {acc,hpc2n}.umu.se      |     nikke@acc.umu.se
---------------------------------------------------------------------------
  "I don't believe it. There are no respected plastic surgeons." - Logan
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D
-------------- next part --------------

Fix tda10021 to not claim tda10023.

Previously mantis_frontend_init() relied on the PCI ID alone, this
causes trouble when a card has a different chip depending on
the manufacturing date. This match makes it work with newer
Azurewave AD-CP300 cards while (hopefully) maintaining compatibility
with older cards.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
