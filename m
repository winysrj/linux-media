Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n8a.bullet.ukl.yahoo.com ([217.146.183.156])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1L3eAu-0005Df-IL
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 23:08:29 +0100
Date: Fri, 21 Nov 2008 18:07:52 -0400
From: Emmanuel ALLAUD <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <200811091657.32226.liplianin@tut.by> <49271E99.2040407@gmail.com>
In-Reply-To: <49271E99.2040407@gmail.com> (from abraham.manu@gmail.com on
	Fri Nov 21 16:48:25 2008)
Message-Id: <1227305272.6200.2@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : [PATCH] TT S2-3200: Increase timeout for
 stb0899_send_diseqc_msg.
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

Le 21.11.2008 16:48:25, Manu Abraham a =E9crit=A0:
> Igor M. Liplianin wrote:
> > TT S2-3200: Increase timeout for stb0899_send_diseqc_msg.
> > =

> > From: Igor M. Liplianin <liplianin@me.by>
> > =

> > Increase timeout for stb0899_send_diseqc_msg. It fixes error for
> rotor:
> > FE_DISEQC_SEND_MASTER_CMD failed: Connection timed out.
> > =

> > Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> > =

> > =

> > =

> ------------------------------------------------------------------------
> > =

> > # HG changeset patch
> > # User Igor M. Liplianin <liplianin@me.by>
> > # Date 1226189735 -7200
> > # Node ID e14ee5f020b15afdf0e5b573d0f960c68a458d37
> > # Parent  1c4d63e589e0420d95d96bf81d3bfbb2cd39a9cf
> > TT S2-3200: Increase timeout for stb0899_send_diseqc_msg.
> > =

> > From: Igor M. Liplianin <liplianin@me.by>
> > =

> > Increase timeout for stb0899_send_diseqc_msg. It fixes error for
> rotor:
> > FE_DISEQC_SEND_MASTER_CMD failed: Connection timed out.
> > =

> > Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> > =

> > diff -r 1c4d63e589e0 -r e14ee5f020b1
> linux/drivers/media/dvb/frontends/stb0899_drv.c
> > --- a/linux/drivers/media/dvb/frontends/stb0899_drv.c	Sat Nov
> 08 23:33:34 2008 +0200
> > +++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c	Sun Nov
> 09 02:15:35 2008 +0200
> > @@ -705,7 +705,7 @@
> >  	stb0899_write_reg(state, STB0899_DISCNTRL1, reg);
> >  	for (i =3D 0; i < cmd->msg_len; i++) {
> >  		/* wait for FIFO empty	*/
> > -		if (stb0899_wait_diseqc_fifo_empty(state, 10) < 0)
> > +		if (stb0899_wait_diseqc_fifo_empty(state, 20) < 0)
> >  			return -ETIMEDOUT;
> >  =

> >  		stb0899_write_reg(state, STB0899_DISFIFO,
> cmd->msg[i]);
> =

> Diseqc/Rotor did work with the 10ms timeout for most of us. Was it
> really failing ?
> =

> Anyway if it is really needed, the timeout can be increased.
> =

> Regards,
> Manu

Hi Manu,
any progress on the stb0899 locking problems (I reported mine for DVB-S =

QPSK 5/6).
Thx
Bye
Manu




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
