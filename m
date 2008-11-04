Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KxOVf-0001ax-89
	for linux-dvb@linuxtv.org; Tue, 04 Nov 2008 17:12:03 +0100
Received: by qw-out-2122.google.com with SMTP id 9so1379026qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 04 Nov 2008 08:11:58 -0800 (PST)
Message-ID: <c74595dc0811040811k2d2efb5eye6fa6fd2821ba1e3@mail.gmail.com>
Date: Tue, 4 Nov 2008 18:11:58 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20081104155024.68280@gmx.net>
MIME-Version: 1.0
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<c74595dc0810281223j25d78c9eqbcbed70a1b495b43@mail.gmail.com>
	<b42fca4d0810281305l6e741c25ia25e1f3f348761d5@mail.gmail.com>
	<c74595dc0810281320r9ef1a1cw172a36738c8a4e8@mail.gmail.com>
	<c74595dc0810301510t5ae3df6fg28c6a62e999aed83@mail.gmail.com>
	<20081031145853.2b722c9f@bk.ru>
	<157f4a8c0811030703w195a4947uab8c3076173898e5@mail.gmail.com>
	<157f4a8c0811031004j776b2eb2v67d59b80775246b9@mail.gmail.com>
	<c74595dc0811031212p1ebe023fm43e81861650fcd6d@mail.gmail.com>
	<20081104155024.68280@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1174233294=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1174233294==
Content-Type: multipart/alternative;
	boundary="----=_Part_76764_12199539.1225815118590"

------=_Part_76764_12199539.1225815118590
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks Hans,

I have only TwinHan 1041 card (DVB-S/S2 stb0899 based), so could not test
anything else.

I will include your fix as soon as I'll get to work on it.

Will post a message with changes after that.

On Tue, Nov 4, 2008 at 5:50 PM, Hans Werner <HWerner4@gmx.de> wrote:

> I don't know if anyone mentioned it already, but scan-s2 does not work for
> DVB-T.
>
> Here is a patch which fixes DVB-T support.
>
> Signed-off-by: Hans Werner <hwerner4@gmx.de>
>
> diff -r fff2d1f1fd4f scan.c
> --- a/scan.c    Fri Oct 31 14:07:06 2008 +0200
> +++ b/scan.c    Tue Nov 04 15:38:09 2008 +0000
> @@ -1523,6 +1523,7 @@ static int __tune_to_transponder (int fr
>        int i;
>        fe_status_t s;
>        uint32_t if_freq;
> +       uint32_t bandwidth_hz = 0;
>        current_tp = t;
>
>        struct dtv_property p_clear[] = {
> @@ -1580,7 +1581,22 @@ static int __tune_to_transponder (int fr
>                if (verbosity >= 2)
>                        dprintf(1,"DVB-S IF freq is %d\n", if_freq);
>        }
> -
> +       else if (t->delivery_system == SYS_DVBT) {
> +               if_freq=t->frequency;
> +               if (t->bandwidth == BANDWIDTH_6_MHZ)
> +                        bandwidth_hz = 6000000;
> +                else if (t->bandwidth == BANDWIDTH_7_MHZ)
> +                        bandwidth_hz = 7000000;
> +                else if (t->bandwidth == BANDWIDTH_8_MHZ)
> +                        bandwidth_hz = 8000000;
> +                else
> +                        /* Including BANDWIDTH_AUTO */
> +                        bandwidth_hz = 0;
> +               if (verbosity >= 2){
> +                       dprintf(1,"DVB-T frequency is %d\n", if_freq);
> +                       dprintf(1,"DVB-T bandwidth is %d\n", bandwidth_hz);
> +               }
> +       }
>
>        struct dvb_frontend_event ev;
>        struct dtv_property p_tune[] = {
> @@ -1591,11 +1607,12 @@ static int __tune_to_transponder (int fr
>                { .cmd = DTV_INNER_FEC,                 .u.data = t->fec },
>                { .cmd = DTV_INVERSION,                 .u.data =
> t->inversion },
>                { .cmd = DTV_ROLLOFF,                   .u.data = t->rolloff
> },
> -               { .cmd = DTV_PILOT,                             .u.data =
> PILOT_AUTO },
> +               { .cmd = DTV_BANDWIDTH_HZ,              .u.data =
> bandwidth_hz },
> +               { .cmd = DTV_PILOT,                     .u.data =
> PILOT_AUTO },
>                { .cmd = DTV_TUNE },
>        };
>        struct dtv_properties cmdseq_tune = {
> -               .num = 9,
> +               .num = 10,
>                .props = p_tune
>        };
>
>
>
> --
> Release early, release often.
>
> "Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
> Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
>

------=_Part_76764_12199539.1225815118590
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div>Thanks Hans,</div>
<div>&nbsp;</div>
<div>I have only TwinHan 1041 card (DVB-S/S2 stb0899 based), so could not test anything else.</div>
<div>&nbsp;</div>
<div>I will include your fix as soon as I&#39;ll get to work on it.</div>
<div>&nbsp;</div>
<div>Will post a message with changes after that.<br><br></div>
<div class="gmail_quote">On Tue, Nov 4, 2008 at 5:50 PM, Hans Werner <span dir="ltr">&lt;<a href="mailto:HWerner4@gmx.de">HWerner4@gmx.de</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">I don&#39;t know if anyone mentioned it already, but scan-s2 does not work for DVB-T.<br><br>Here is a patch which fixes DVB-T support.<br>
<br>Signed-off-by: Hans Werner &lt;<a href="mailto:hwerner4@gmx.de">hwerner4@gmx.de</a>&gt;<br><br>diff -r fff2d1f1fd4f scan.c<br>--- a/scan.c &nbsp; &nbsp;Fri Oct 31 14:07:06 2008 +0200<br>+++ b/scan.c &nbsp; &nbsp;Tue Nov 04 15:38:09 2008 +0000<br>
@@ -1523,6 +1523,7 @@ static int __tune_to_transponder (int fr<br>&nbsp; &nbsp; &nbsp; &nbsp;int i;<br>&nbsp; &nbsp; &nbsp; &nbsp;fe_status_t s;<br>&nbsp; &nbsp; &nbsp; &nbsp;uint32_t if_freq;<br>+ &nbsp; &nbsp; &nbsp; uint32_t bandwidth_hz = 0;<br>&nbsp; &nbsp; &nbsp; &nbsp;current_tp = t;<br><br>&nbsp; &nbsp; &nbsp; &nbsp;struct dtv_property p_clear[] = {<br>
@@ -1580,7 +1581,22 @@ static int __tune_to_transponder (int fr<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (verbosity &gt;= 2)<br>
<div class="Ih2E3d">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;dprintf(1,&quot;DVB-S IF freq is %d\n&quot;, if_freq);<br>&nbsp; &nbsp; &nbsp; &nbsp;}<br>-<br></div>+ &nbsp; &nbsp; &nbsp; else if (t-&gt;delivery_system == SYS_DVBT) {<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if_freq=t-&gt;frequency;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (t-&gt;bandwidth == BANDWIDTH_6_MHZ)<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;bandwidth_hz = 6000000;<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;else if (t-&gt;bandwidth == BANDWIDTH_7_MHZ)<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;bandwidth_hz = 7000000;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;else if (t-&gt;bandwidth == BANDWIDTH_8_MHZ)<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;bandwidth_hz = 8000000;<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;else<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;/* Including BANDWIDTH_AUTO */<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;bandwidth_hz = 0;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (verbosity &gt;= 2){<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; dprintf(1,&quot;DVB-T frequency is %d\n&quot;, if_freq);<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; dprintf(1,&quot;DVB-T bandwidth is %d\n&quot;, bandwidth_hz);<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+ &nbsp; &nbsp; &nbsp; }<br><br>&nbsp; &nbsp; &nbsp; &nbsp;struct dvb_frontend_event ev;<br>&nbsp; &nbsp; &nbsp; &nbsp;struct dtv_property p_tune[] = {<br>@@ -1591,11 +1607,12 @@ static int __tune_to_transponder (int fr<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ .cmd = DTV_INNER_FEC, &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .u.data = t-&gt;fec },<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ .cmd = DTV_INVERSION, &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .u.data = t-&gt;inversion },<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ .cmd = DTV_ROLLOFF, &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .u.data = t-&gt;rolloff },<br>- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; { .cmd = DTV_PILOT, &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .u.data = PILOT_AUTO },<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; { .cmd = DTV_BANDWIDTH_HZ, &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.u.data = bandwidth_hz },<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; { .cmd = DTV_PILOT, &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .u.data = PILOT_AUTO },<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ .cmd = DTV_TUNE },<br>&nbsp; &nbsp; &nbsp; &nbsp;};<br>&nbsp; &nbsp; &nbsp; &nbsp;struct dtv_properties cmdseq_tune = {<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .num = 9,<br>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .num = 10,<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.props = p_tune<br>&nbsp; &nbsp; &nbsp; &nbsp;};<br><font color="#888888"><br><br><br>--<br>Release early, release often.<br><br>&quot;Feel free&quot; - 10 GB Mailbox, 100 FreeSMS/Monat ...<br>
Jetzt GMX TopMail testen: <a href="http://www.gmx.net/de/go/topmail" target="_blank">http://www.gmx.net/de/go/topmail</a><br></font></blockquote></div><br></div>

------=_Part_76764_12199539.1225815118590--


--===============1174233294==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1174233294==--
