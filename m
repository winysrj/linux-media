Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1K2Bto-00039w-MH
	for linux-dvb@linuxtv.org; Fri, 30 May 2008 23:12:33 +0200
Received: by mu-out-0910.google.com with SMTP id w8so260164mue.1
	for <linux-dvb@linuxtv.org>; Fri, 30 May 2008 14:12:29 -0700 (PDT)
Message-ID: <48406DB7.10109@gmail.com>
Date: Fri, 30 May 2008 23:12:23 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <1212079844.26238.22.camel@rommel.snap.tv>	<483EED5A.7080200@iki.fi>	<48400833.60909@gmail.com>	<48401099.7040908@iki.fi>	<484014AC.3090603@gmail.com>	<48401C63.1010601@iki.fi>
	<484063E1.9010109@iki.fi>
In-Reply-To: <484063E1.9010109@iki.fi>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] Oops in tda10023
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

Antti Palosaari schrieb:
> Anyhow, I see there is two ways to fix that (only Oops from TDA10023, 
> not issue why it actually fails):
> 1) remove state->frontend.dvb->num from tda10023_writereg()
> 2) remove wakeup if in standby from tda10023_attach()

I wouldn't prefer #1, because it is very useful to know the adapter number, if one card 
sucks and it exist another one. Usually, it isn't necessary to wakeup the tda10023 for 
reading the id. A third option is the following patch:

diff -r 398b07fdfe79 linux/drivers/media/dvb/frontends/tda10023.c
--- a/linux/drivers/media/dvb/frontends/tda10023.c      Wed May 28 17:55:13 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/tda10023.c      Fri May 30 23:02:55 2008 +0200
@@ -90,7 +90,7 @@ static int tda10023_writereg (struct tda
         if (ret != 1)
                 printk("DVB: TDA10023(%d): %s, writereg error "
                         "(reg == 0x%02x, val == 0x%02x, ret == %i)\n",
-                       state->frontend.dvb->num, __func__, reg, data, ret);
+                       state->frontend.dvb ? state->frontend.dvb->num : '?', __func__, 
reg, data, ret);

         return (ret != 1) ? -EREMOTEIO : 0;
  }
@@ -481,7 +481,7 @@ struct dvb_frontend *tda10023_attach(con
         struct tda10023_state* state = NULL;

         /* allocate memory for the internal state */
-       state = kmalloc(sizeof(struct tda10023_state), GFP_KERNEL);
+       state = kzalloc(sizeof(struct tda10023_state), GFP_KERNEL);
         if (state == NULL) goto error;

         /* setup the state */

-Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
