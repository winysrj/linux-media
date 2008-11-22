Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <sinter.mann@gmx.de>) id 1L3twj-0007py-Tt
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 15:58:54 +0100
Date: Sat, 22 Nov 2008 15:58:20 +0100
From: sinter.mann@gmx.de
Message-ID: <20081122145820.183450@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] errormessages skystar2 rev 2.8b with latest v4l-dvb
 branch
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

Hello Halim,

Forget about the Mercurial tree........

1. Get a vanilla kernel 2.6.27 plus patch 2.6.28-rc6 from =

http://www.eu.kernel.org/

2. Prepare a kernel linux-2.6.28-rc6.

3. Download the appended patchset: http://www.htpc-
forum.de/forum/index.php?showtopic=3D4944&st=3D0&#entry31527

4. Unpack the patchset to /usr/src/linux.

5. Move all files in /usr/src/linux/skystarxyz to /usr/src/linux.

6. For a 32-bit architecture execute: ./sky28 32, for a 64-bit one ./sky28 =
64.

7. Then move on with "make xconfig", make your config, then continue with "=
make =

modules && make bzlilo, make modules_install.....

Enjoy!

Cheers

Uwe

-- =

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
