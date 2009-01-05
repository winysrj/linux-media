Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1LJr6z-0000xZ-G9
	for linux-dvb@linuxtv.org; Mon, 05 Jan 2009 16:11:26 +0100
Date: Mon, 05 Jan 2009 16:10:50 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <c74595dc0901042308j24fcbdebq3d6c51d2c68c8a73@mail.gmail.com>
Message-ID: <20090105151050.293110@gmx.net>
MIME-Version: 1.0
References: <49346726.7010303@insite.cz>	
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>	
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>	
	<49371511.1060703@insite.cz> <4938C8BB.5040406@verbraak.org>	
	<c74595dc0812050100q52ab86bewebe8dbf17bddbb51@mail.gmail.com>	
	<20081206170753.69410@gmx.net> <20081209153451.75130@gmx.net>	
	<20081215143047.45940@gmx.net> <20090104192435.72460@gmx.net>
	<c74595dc0901042308j24fcbdebq3d6c51d2c68c8a73@mail.gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] stb6100: stb6100_init fix
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

Two issues in stb6100_init : the call to stb6100_set_bandwidth needs an arg=
ument in Hz
not kHz, and a comment incorrectly says MHz instead of Hz.  I don't know if=
 this caused
real problems anywhere.

This patch is for v4l-dvb, but it is also needs to be fixed in s2-liplianin.

diff -r b7e7abe3e3aa linux/drivers/media/dvb/frontends/stb6100.c
--- a/linux/drivers/media/dvb/frontends/stb6100.c
+++ b/linux/drivers/media/dvb/frontends/stb6100.c
@@ -434,11 +434,11 @@ static int stb6100_init(struct dvb_front
        status->refclock        =3D 27000000;     /* Hz   */
        status->iqsense         =3D 1;
        status->bandwidth       =3D 36000;        /* kHz  */
-       state->bandwidth        =3D status->bandwidth * 1000;     /* MHz  */
+       state->bandwidth        =3D status->bandwidth * 1000;     /* Hz   */
        state->reference        =3D status->refclock / 1000;      /* kHz  */

        /* Set default bandwidth.       */
-       return stb6100_set_bandwidth(fe, status->bandwidth);
+       return stb6100_set_bandwidth(fe, state->bandwidth);
 }

 static int stb6100_get_state(struct dvb_frontend *fe,
-- =

Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
