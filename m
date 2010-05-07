Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:52086 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0EGHFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 03:05:13 -0400
Date: Fri, 7 May 2010 09:05:15 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] stv6110x Fix kernel null pointer deref when plugging
 two TT s2-1600
Message-ID: <20100507090515.2fb971a7@zombie>
In-Reply-To: <20100503230924.3f560423@pedra>
References: <20100411231529.1538cf69@borg.bxl.tuxicoman.be>
	<20100503230924.3f560423@pedra>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/h5nd.1tCdRmmR=cMVPXjv.f"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/h5nd.1tCdRmmR=cMVPXjv.f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hi Mauro,

> This fix seem to be at the wrong place. There's nothing on stv090x.c
> that require a not null value for fe->tuner_priv.

Thanks for the review !

> So, a better fix for your bug is to add a check for fe->tuner_priv
> inside stv6110x_sleep().


Fix initialization of the TT s2-1600 card when plugging two of them in
the same box. Check for fe->tuner_priv to be set when
stv6110x_sleep() is called.

Signed-off-by : Guy Martin <gmsoft@tuxicoman.be>


Regards,
  Guy


--MP_/h5nd.1tCdRmmR=cMVPXjv.f
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
diff -r 4a8d6d981f07 linux/drivers/media/dvb/ttpci/budget.c
--- a/linux/drivers/media/dvb/ttpci/budget.c	Wed May 05 11:58:44 2010 -0300
+++ b/linux/drivers/media/dvb/ttpci/budget.c	Fri May 07 08:51:18 2010 +0200
@@ -461,8 +461,8 @@
 };
 
 static struct isl6423_config tt1600_isl6423_config = {
-	.current_max		= SEC_CURRENT_515m,
-	.curlim			= SEC_CURRENT_LIM_ON,
+	.current_max		= SEC_CURRENT_800m,
+	.curlim			= SEC_CURRENT_LIM_OFF,
 	.mod_extern		= 1,
 	.addr			= 0x08,
 };

--MP_/h5nd.1tCdRmmR=cMVPXjv.f--
