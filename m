Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KyWgp-0001Lb-1u
	for linux-dvb@linuxtv.org; Fri, 07 Nov 2008 20:08:16 +0100
Date: Fri, 07 Nov 2008 20:07:41 +0100
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20081107190741.240760@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, liplianin@tut.by
Subject: [linux-dvb] [PATCH] s2liplianin: mb86a16.c fix
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


The compiler throws a warning in mb86a16.c.

Surely this change is needed to match the definition of .tune in struct dvb=
_frontend_ops
in dvb-core/dvb_frontend.h ?


Signed-off-by: Hans Werner <hwerner4@gmx.de>

diff -r 98830467913d linux/drivers/media/dvb/frontends/mb86a16.c
--- a/linux/drivers/media/dvb/frontends/mb86a16.c
+++ b/linux/drivers/media/dvb/frontends/mb86a16.c
@@ -1676,7 +1676,7 @@ static int mb86a16_set_frontend(struct d
 static int mb86a16_set_frontend(struct dvb_frontend *fe,
                                struct dvb_frontend_parameters *p,
                                unsigned int mode_flags,
-                               int *delay,
+                               unsigned int *delay,
                                fe_status_t *status)
 {
        int ret =3D 0;
-- =

Release early, release often.

GMX Download-Spiele: Preizsturz! Alle Puzzle-Spiele Deluxe =FCber 60% billi=
ger.
http://games.entertainment.gmx.net/de/entertainment/games/download/puzzle/i=
ndex.html

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
