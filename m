Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1LL1H8-0006jO-3G
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 21:14:42 +0100
Received: by fg-out-1718.google.com with SMTP id e21so3406265fga.25
	for <linux-dvb@linuxtv.org>; Thu, 08 Jan 2009 12:14:37 -0800 (PST)
Message-ID: <1a297b360901081214q5d687fbcr3c718af6d2aaecf4@mail.gmail.com>
Date: Fri, 9 Jan 2009 00:14:37 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20090108171755.23040@gmx.net>
MIME-Version: 1.0
References: <20090105152029.293080@gmx.net>
	<20090108100149.2c6df55e@pedra.chehab.org>
	<20090108171755.23040@gmx.net>
Cc: linux-dvb@linuxtv.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [linux-dvb] [PATCH] [RESEND] stb6100: stb6100_init fix
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0550496671=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0550496671==
Content-Type: multipart/alternative;
	boundary="----=_Part_2398_10074431.1231445677904"

------=_Part_2398_10074431.1231445677904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Jan 8, 2009 at 9:17 PM, Hans Werner <HWerner4@gmx.de> wrote:

>
>
> Signed-off-by: Hans Werner <hwerner4@gmx.de>
>
> diff -r b7e7abe3e3aa linux/drivers/media/dvb/frontends/stb6100.c
> --- a/linux/drivers/media/dvb/frontends/stb6100.c
> +++ b/linux/drivers/media/dvb/frontends/stb6100.c
> @@ -434,11 +434,11 @@ static int stb6100_init(struct dvb_front
>        status->refclock        = 27000000;     /* Hz   */
>        status->iqsense         = 1;
>        status->bandwidth       = 36000;        /* kHz  */
> -       state->bandwidth        = status->bandwidth * 1000;     /* MHz  */
> +       state->bandwidth        = status->bandwidth * 1000;     /* Hz   */
>        state->reference        = status->refclock / 1000;      /* kHz  */
>
>        /* Set default bandwidth.       */
> -       return stb6100_set_bandwidth(fe, status->bandwidth);
> +       return stb6100_set_bandwidth(fe, state->bandwidth);
>  }
>
>  static int stb6100_get_state(struct dvb_frontend *fe,
>


Patch looks more or less ok, but it won't have any effect in any manner at
all as it is a
NOP during init (purely cosmetic). Anyway will pull it in along with the
other patches
and after testing.


Manu

------=_Part_2398_10074431.1231445677904
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br><div class="gmail_quote">On Thu, Jan 8, 2009 at 9:17 PM, Hans Werner <span dir="ltr">&lt;<a href="mailto:HWerner4@gmx.de">HWerner4@gmx.de</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<br>
Signed-off-by: Hans Werner &lt;<a href="mailto:hwerner4@gmx.de">hwerner4@gmx.de</a>&gt;<br>
<br>
diff -r b7e7abe3e3aa linux/drivers/media/dvb/frontends/stb6100.c<br>
--- a/linux/drivers/media/dvb/frontends/stb6100.c<br>
+++ b/linux/drivers/media/dvb/frontends/stb6100.c<br>
@@ -434,11 +434,11 @@ static int stb6100_init(struct dvb_front<br>
 &nbsp; &nbsp; &nbsp; &nbsp;status-&gt;refclock &nbsp; &nbsp; &nbsp; &nbsp;= 27000000; &nbsp; &nbsp; /* Hz &nbsp; */<br>
 &nbsp; &nbsp; &nbsp; &nbsp;status-&gt;iqsense &nbsp; &nbsp; &nbsp; &nbsp; = 1;<br>
 &nbsp; &nbsp; &nbsp; &nbsp;status-&gt;bandwidth &nbsp; &nbsp; &nbsp; = 36000; &nbsp; &nbsp; &nbsp; &nbsp;/* kHz &nbsp;*/<br>
- &nbsp; &nbsp; &nbsp; state-&gt;bandwidth &nbsp; &nbsp; &nbsp; &nbsp;= status-&gt;bandwidth * 1000; &nbsp; &nbsp; /* MHz &nbsp;*/<br>
+ &nbsp; &nbsp; &nbsp; state-&gt;bandwidth &nbsp; &nbsp; &nbsp; &nbsp;= status-&gt;bandwidth * 1000; &nbsp; &nbsp; /* Hz &nbsp; */<br>
 &nbsp; &nbsp; &nbsp; &nbsp;state-&gt;reference &nbsp; &nbsp; &nbsp; &nbsp;= status-&gt;refclock / 1000; &nbsp; &nbsp; &nbsp;/* kHz &nbsp;*/<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp;/* Set default bandwidth. &nbsp; &nbsp; &nbsp; */<br>
- &nbsp; &nbsp; &nbsp; return stb6100_set_bandwidth(fe, status-&gt;bandwidth);<br>
+ &nbsp; &nbsp; &nbsp; return stb6100_set_bandwidth(fe, state-&gt;bandwidth);<br>
&nbsp;}<br>
<br>
&nbsp;static int stb6100_get_state(struct dvb_frontend *fe,<br>
<font color="#888888"></font></blockquote></div><br><br>Patch looks more or less ok, but it won&#39;t have any effect in any manner at all as it is a <br>NOP during init (purely cosmetic). Anyway will pull it in along with the other patches <br>
and after testing.<br><br><br>Manu<br><br></div>

------=_Part_2398_10074431.1231445677904--


--===============0550496671==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0550496671==--
