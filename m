Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1K2D28-0000pu-OR
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 00:25:13 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 31 May 2008 00:24:13 +0200
References: <1212079844.26238.22.camel@rommel.snap.tv>
	<484063E1.9010109@iki.fi> <48406DB7.10109@gmail.com>
In-Reply-To: <48406DB7.10109@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805310024.14082@orion.escape-edv.de>
Subject: Re: [linux-dvb] Oops in tda10023
Reply-To: linux-dvb@linuxtv.org
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

e9hack wrote:
> A third option is the following patch:

Ack for this one.

> diff -r 398b07fdfe79 linux/drivers/media/dvb/frontends/tda10023.c
> --- a/linux/drivers/media/dvb/frontends/tda10023.c      Wed May 28 17:55:13 2008 -0300
> +++ b/linux/drivers/media/dvb/frontends/tda10023.c      Fri May 30 23:02:55 2008 +0200
> @@ -90,7 +90,7 @@ static int tda10023_writereg (struct tda
>          if (ret != 1)
>                  printk("DVB: TDA10023(%d): %s, writereg error "
>                          "(reg == 0x%02x, val == 0x%02x, ret == %i)\n",
> -                       state->frontend.dvb->num, __func__, reg, data, ret);
> +                       state->frontend.dvb ? state->frontend.dvb->num : '?', __func__, 

Please replace '?' by -1.

Btw, the same code should be added to tda10023_readreg to print the
adapter number there.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
