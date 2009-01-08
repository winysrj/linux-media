Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1LKyWa-0001OR-RW
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 18:18:29 +0100
Date: Thu, 08 Jan 2009 18:17:55 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20090108100149.2c6df55e@pedra.chehab.org>
Message-ID: <20090108171755.23040@gmx.net>
MIME-Version: 1.0
References: <20090105152029.293080@gmx.net>
	<20090108100149.2c6df55e@pedra.chehab.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
	abraham.manu@gmail.com, linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] [RESEND] stb6100: stb6100_init fix
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


> > Hi Mauro,
> > please look at the patch below.
> > =

> > Signed-off-by: Hans Werner <hwerner4@gmx.de>
> > =

> > Thanks,
> > Hans
> > =

> > -------- Original-Nachricht --------
> > Datum: Mon, 05 Jan 2009 16:10:50 +0100
> > Von: "Hans Werner" <HWerner4@gmx.de>
> > An: linux-dvb@linuxtv.org
> > Betreff: [linux-dvb] [PATCH] stb6100: stb6100_init fix
> > =

> > Two issues in stb6100_init : the call to stb6100_set_bandwidth needs an
> argument in Hz
> > not kHz, and a comment incorrectly says MHz instead of Hz.  I don't know
> if this caused
> > real problems anywhere.
> > =

> > This patch is for v4l-dvb, but it is also needs to be fixed in
> s2-liplianin.
> > =

> > ...
> > ...
> =

> Considering that the ioctl use "state" instead of "status", your patch
> looks
> sane:
> =

> case DVBFE_TUNER_BANDWIDTH:
>                 stb6100_set_bandwidth(fe, state->bandwidth);
> =

> Could you please re-send this patch to me, mentioning the above,
> explicitly C/C
> Manu, linux-media and linux-dvb ML's? Please, mark the patch as a resend.
> =

> Cheers,
> Mauro

Resending the following patch as requested by Mauro.
Signed-off-by: Hans Werner <hwerner4@gmx.de>

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
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
