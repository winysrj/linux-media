Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tut.by ([195.137.160.40] helo=speedy.tutby.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <liplianin@tut.by>) id 1L3wVO-00018n-Dl
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 18:42:50 +0100
Received: from [213.184.224.41] (account liplianin@tut.by HELO
	dynamic-vpdn-128-2-82.telecom.by)
	by speedy.tutby.com (CommuniGate Pro SMTP 5.1.12)
	with ESMTPA id 98410812 for linux-dvb@linuxtv.org;
	Sat, 22 Nov 2008 19:42:42 +0200
Content-Disposition: inline
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org
Date: Sat, 22 Nov 2008 19:42:29 +0200
MIME-Version: 1.0
Message-Id: <200811221942.29590.liplianin@tut.by>
Subject: [linux-dvb] Fwd: Re: [PATCH] TT S2-3200: Increase timeout for
	stb0899_send_diseqc_msg.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> Igor M. Liplianin wrote:
> > TT S2-3200: Increase timeout for stb0899_send_diseqc_msg.
> >
> > From: Igor M. Liplianin <liplianin@me.by>
> >
> > Increase timeout for stb0899_send_diseqc_msg. It fixes error for rotor:
> > FE_DISEQC_SEND_MASTER_CMD failed: Connection timed out.
> >
> > Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> >
> >
> > ------------------------------------------------------------------------
> >
> > # HG changeset patch
> > # User Igor M. Liplianin <liplianin@me.by>
> > # Date 1226189735 -7200
> > # Node ID e14ee5f020b15afdf0e5b573d0f960c68a458d37
> > # Parent  1c4d63e589e0420d95d96bf81d3bfbb2cd39a9cf
> > TT S2-3200: Increase timeout for stb0899_send_diseqc_msg.
> >
> > From: Igor M. Liplianin <liplianin@me.by>
> >
> > Increase timeout for stb0899_send_diseqc_msg. It fixes error for rotor:
> > FE_DISEQC_SEND_MASTER_CMD failed: Connection timed out.
> >
> > Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> >
> > diff -r 1c4d63e589e0 -r e14ee5f020b1
> > linux/drivers/media/dvb/frontends/stb0899_drv.c ---
> > a/linux/drivers/media/dvb/frontends/stb0899_drv.c	Sat Nov 08 23:33:34
> > 2008 +0200 +++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c	Sun Nov
> > 09 02:15:35 2008 +0200 @@ -705,7 +705,7 @@
> >  	stb0899_write_reg(state, STB0899_DISCNTRL1, reg);
> >  	for (i = 0; i < cmd->msg_len; i++) {
> >  		/* wait for FIFO empty	*/
> > -		if (stb0899_wait_diseqc_fifo_empty(state, 10) < 0)
> > +		if (stb0899_wait_diseqc_fifo_empty(state, 20) < 0)
> >  			return -ETIMEDOUT;
> >
> >  		stb0899_write_reg(state, STB0899_DISFIFO, cmd->msg[i]);
>
> Diseqc/Rotor did work with the 10ms timeout for most of us. Was it
> really failing ?
>
> Anyway if it is really needed, the timeout can be increased.
>
> Regards,
> Manu
I do not insist.

Best regards
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
