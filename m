Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:36182 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0EGHej (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 03:34:39 -0400
Date: Fri, 7 May 2010 09:34:40 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] stv6110x Fix kernel null pointer deref when plugging
 two TT s2-1600
Message-ID: <20100507093440.233cd65e@zombie>
In-Reply-To: <20100507090515.2fb971a7@zombie>
References: <20100411231529.1538cf69@borg.bxl.tuxicoman.be>
	<20100503230924.3f560423@pedra>
	<20100507090515.2fb971a7@zombie>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/MpHkJWX2nA9.n0Fn+f/1506"
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/MpHkJWX2nA9.n0Fn+f/1506
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hi Mauro,

Seems that I've sent the wrong patch. It contained additional things
which are irrelevant.

Attached the correct one.

Signed-off-by : Guy Martin <gmsoft@tuxicoman.be>

Regards,
  Guy

On Fri, 7 May 2010 09:05:15 +0200
Guy Martin <gmsoft@tuxicoman.be> wrote:

> 
> Hi Mauro,
> 
> > This fix seem to be at the wrong place. There's nothing on stv090x.c
> > that require a not null value for fe->tuner_priv.
> 
> Thanks for the review !
> 
> > So, a better fix for your bug is to add a check for fe->tuner_priv
> > inside stv6110x_sleep().
> 
> 
> Fix initialization of the TT s2-1600 card when plugging two of them in
> the same box. Check for fe->tuner_priv to be set when
> stv6110x_sleep() is called.
> 
> Signed-off-by : Guy Martin <gmsoft@tuxicoman.be>
> 
> 
> Regards,
>   Guy
> 


--MP_/MpHkJWX2nA9.n0Fn+f/1506
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=stv6110x-sleep-null-deref.patch

diff -r 4a8d6d981f07 linux/drivers/media/dvb/frontends/stv6110x.c
--- a/linux/drivers/media/dvb/frontends/stv6110x.c	Wed May 05 11:58:44 2010 -0300
+++ b/linux/drivers/media/dvb/frontends/stv6110x.c	Fri May 07 08:51:18 2010 +0200
@@ -302,7 +302,10 @@
 
 static int stv6110x_sleep(struct dvb_frontend *fe)
 {
-	return stv6110x_set_mode(fe, TUNER_SLEEP);
+	if (fe->tuner_priv)
+		return stv6110x_set_mode(fe, TUNER_SLEEP);
+
+	return 0;
 }
 
 static int stv6110x_get_status(struct dvb_frontend *fe, u32 *status)

--MP_/MpHkJWX2nA9.n0Fn+f/1506--
