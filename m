Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KwV7t-0000aI-N0
	for linux-dvb@linuxtv.org; Sun, 02 Nov 2008 06:03:51 +0100
Received: by qw-out-2122.google.com with SMTP id 9so816580qwb.17
	for <linux-dvb@linuxtv.org>; Sat, 01 Nov 2008 22:03:44 -0700 (PDT)
Message-ID: <c74595dc0811012203ufbeb07rb24d742bfaecdc1@mail.gmail.com>
Date: Sun, 2 Nov 2008 07:03:44 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Michel Verbraak" <michel@verbraak.org>
In-Reply-To: <490C7194.8060603@verbraak.org>
MIME-Version: 1.0
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<490C7194.8060603@verbraak.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1134848697=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1134848697==
Content-Type: multipart/alternative;
	boundary="----=_Part_35497_19376667.1225602224484"

------=_Part_35497_19376667.1225602224484
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Michel,

Thanks for your proposals.

I also has a thought about S2 parameter in frequency file, but decided to
perform both DVB-S and DVB-S2 scans automatically since it easy on
maintaining the frequency file.

I will probably leave "S" frequency as is and will add "S1" and "S2" if you
want to specify what delivery should be used.
Also, I've been reported that some drivers can't work with AUTO modulation
so it have to be implicitly specified. scan-s2 will have to monitor the
modulation and scan S2 channels directly when 8PSK is specified or scan only
DVB-S if QPSK is specified.

I'll review your patches later, don't have time now.

On Sat, Nov 1, 2008 at 5:11 PM, Michel Verbraak <michel@verbraak.org> wrote:

> Alex,
>
> Tested your scan-s2 with a Technisat HD2 card.
>
> Scanning works. But some channels are reported twice with different
> frequency. I found an error which is fixed by the patch file named
> scan.c.diff1.
>
> I would also like to propose the following change (see file scan.c.diff2 or
> scan.c.diff which includes both patches). This change makes it possible to
> only scan for DVB-S channels or DVB-S2 channels or both. This is done by
> specifying lines starting with S or S2 in the input file.
>
> example input file:
> # Astra 19.2E SDT info service transponder
> # freq pol sr fec
> S 12522000 H 22000000 2/3       <only DVB-S channels are scanned>
> S 11914000 H 27500000 AUTO
> S 10743750 H 22000000 5/6
> S 12187500 H 27500000 3/4
> S 12343500 H 27500000 3/4
> S 12515250 H 22000000 5/6
> S 12574250 H 22000000 5/6
> S2 12522000 H 22000000 AUTO    <only DVB-S2 channels are scanned>
> S2 11914000 H 27500000 AUTO
>
> I hope this is usefull.
>
> Regards,
>
> Michel.
>
> --- scan-s2-88afcf030566/scan.c.orig    2008-11-01 10:09:43.000000000 +0100
> +++ scan-s2-88afcf030566/scan.c 2008-11-01 15:55:14.000000000 +0100
> @@ -906,10 +906,7 @@
>                                // New transponder
>                                t = alloc_transponder(tn.frequency);
>
> -                               // For sattelites start with DVB-S, it will
> switch to DVB-S2 if DVB-S gives no results
> -                               if(current_tp->delivery_system == SYS_DVBS
> || current_tp->delivery_system == SYS_DVBS2) {
> -                                       tn.delivery_system = SYS_DVBS;
> -                               }
> +                               tn.delivery_system =
> current_tp->delivery_system;
>
>                                copy_transponder(t, &tn);
>                        }
> @@ -1578,7 +1575,10 @@
>                        if_freq = abs(t->frequency - lnb_type.low_val);
>                }
>                if (verbosity >= 2)
> +                   if (t->delivery_system == SYS_DVBS)
>                        dprintf(1,"DVB-S IF freq is %d\n", if_freq);
> +                  else if (t->delivery_system == SYS_DVBS2)
> +                       dprintf(1,"DVB-S2 IF freq is %d\n", if_freq);
>        }
>
>
> @@ -1640,7 +1640,8 @@
>                        // get the actual parameters from the driver for
> that channel
>                        if ((ioctl(frontend_fd, FE_GET_PROPERTY, &cmdseq))
> == -1) {
>                                perror("FE_GET_PROPERTY failed");
> -                               return;
> +                               t->last_tuning_failed = 1;
> +                               return -1;
>                        }
>
>                        t->delivery_system = p[0].u.data;
> @@ -1722,12 +1723,6 @@
>
>                rc = tune_to_transponder(frontend_fd, t);
>
> -               // If scan failed and it's a DVB-S system, try DVB-S2
> before giving up
> -               if (rc != 0 && t->delivery_system == SYS_DVBS) {
> -                       t->delivery_system = SYS_DVBS2;
> -                       rc = tune_to_transponder(frontend_fd, t);
> -               }
> -
>                if (rc == 0) {
>                        return 0;
>                }
> @@ -1992,6 +1987,42 @@
>                                t->frequency,
>                                pol[0], t->symbol_rate, fec2str(t->fec),
> rolloff2str(t->rolloff), qam2str(t->modulation));
>                }
> +               else if (sscanf(buf, "S2 %u %1[HVLR] %u %4s %4s %6s\n", &f,
> pol, &sr, fec, rolloff, qam) >= 3) {
> +                       t = alloc_transponder(f);
> +                       t->delivery_system = SYS_DVBS2;
> +                       t->modulation = QAM_AUTO;
> +                       t->rolloff = ROLLOFF_AUTO;
> +                       t->fec = FEC_AUTO;
> +                       switch(pol[0])
> +                       {
> +                       case 'H':
> +                       case 'L':
> +                               t->polarisation = POLARISATION_HORIZONTAL;
> +                               break;
> +                       default:
> +                               t->polarisation = POLARISATION_VERTICAL;;
> +                               break;
> +                       }
> +                       t->inversion = spectral_inversion;
> +                       t->symbol_rate = sr;
> +
> +                       // parse optional parameters
> +                       if(strlen(fec) > 0) {
> +                               t->fec = str2fec(fec);
> +                       }
> +
> +                       if(strlen(rolloff) > 0) {
> +                               t->rolloff = str2rolloff(rolloff);
> +                       }
> +
> +                       if(strlen(qam) > 0) {
> +                               t->modulation = str2qam(qam);
> +                       }
> +
> +                       info("initial transponder %u %c %d %s %s %s\n",
> +                               t->frequency,
> +                               pol[0], t->symbol_rate, fec2str(t->fec),
> rolloff2str(t->rolloff), qam2str(t->modulation));
> +               }
>                else if (sscanf(buf, "C %u %u %4s %6s\n", &f, &sr, fec, qam)
> >= 2) {
>                        t = alloc_transponder(f);
>                        t->delivery_system = SYS_DVBC_ANNEX_AC;
>
> --- scan-s2-88afcf030566/scan.c.orig    2008-11-01 10:09:43.000000000 +0100
> +++ scan-s2-88afcf030566/scan.c 2008-11-01 15:55:14.000000000 +0100
> @@ -1640,7 +1640,8 @@
>                        // get the actual parameters from the driver for
> that channel
>                        if ((ioctl(frontend_fd, FE_GET_PROPERTY, &cmdseq))
> == -1) {
>                                perror("FE_GET_PROPERTY failed");
> -                               return;
> +                               t->last_tuning_failed = 1;
> +                               return -1;
>                        }
>
>                        t->delivery_system = p[0].u.data;
>
> --- scan-s2-88afcf030566/scan.c.orig    2008-11-01 10:09:43.000000000 +0100
> +++ scan-s2-88afcf030566/scan.c 2008-11-01 15:55:14.000000000 +0100
> @@ -906,10 +906,7 @@
>                                // New transponder
>                                t = alloc_transponder(tn.frequency);
>
> -                               // For sattelites start with DVB-S, it will
> switch to DVB-S2 if DVB-S gives no results
> -                               if(current_tp->delivery_system == SYS_DVBS
> || current_tp->delivery_system == SYS_DVBS2) {
> -                                       tn.delivery_system = SYS_DVBS;
> -                               }
> +                               tn.delivery_system =
> current_tp->delivery_system;
>
>                                copy_transponder(t, &tn);
>                        }
> @@ -1578,7 +1575,10 @@
>                        if_freq = abs(t->frequency - lnb_type.low_val);
>                }
>                if (verbosity >= 2)
> +                   if (t->delivery_system == SYS_DVBS)
>                        dprintf(1,"DVB-S IF freq is %d\n", if_freq);
> +                  else if (t->delivery_system == SYS_DVBS2)
> +                       dprintf(1,"DVB-S2 IF freq is %d\n", if_freq);
>        }
>
>
> @@ -1722,12 +1723,6 @@
>
>                rc = tune_to_transponder(frontend_fd, t);
>
> -               // If scan failed and it's a DVB-S system, try DVB-S2
> before giving up
> -               if (rc != 0 && t->delivery_system == SYS_DVBS) {
> -                       t->delivery_system = SYS_DVBS2;
> -                       rc = tune_to_transponder(frontend_fd, t);
> -               }
> -
>                if (rc == 0) {
>                        return 0;
>                }
> @@ -1992,6 +1987,42 @@
>                                t->frequency,
>                                pol[0], t->symbol_rate, fec2str(t->fec),
> rolloff2str(t->rolloff), qam2str(t->modulation));
>                }
> +               else if (sscanf(buf, "S2 %u %1[HVLR] %u %4s %4s %6s\n", &f,
> pol, &sr, fec, rolloff, qam) >= 3) {
> +                       t = alloc_transponder(f);
> +                       t->delivery_system = SYS_DVBS2;
> +                       t->modulation = QAM_AUTO;
> +                       t->rolloff = ROLLOFF_AUTO;
> +                       t->fec = FEC_AUTO;
> +                       switch(pol[0])
> +                       {
> +                       case 'H':
> +                       case 'L':
> +                               t->polarisation = POLARISATION_HORIZONTAL;
> +                               break;
> +                       default:
> +                               t->polarisation = POLARISATION_VERTICAL;;
> +                               break;
> +                       }
> +                       t->inversion = spectral_inversion;
> +                       t->symbol_rate = sr;
> +
> +                       // parse optional parameters
> +                       if(strlen(fec) > 0) {
> +                               t->fec = str2fec(fec);
> +                       }
> +
> +                       if(strlen(rolloff) > 0) {
> +                               t->rolloff = str2rolloff(rolloff);
> +                       }
> +
> +                       if(strlen(qam) > 0) {
> +                               t->modulation = str2qam(qam);
> +                       }
> +
> +                       info("initial transponder %u %c %d %s %s %s\n",
> +                               t->frequency,
> +                               pol[0], t->symbol_rate, fec2str(t->fec),
> rolloff2str(t->rolloff), qam2str(t->modulation));
> +               }
>                else if (sscanf(buf, "C %u %u %4s %6s\n", &f, &sr, fec, qam)
> >= 2) {
>                        t = alloc_transponder(f);
>                        t->delivery_system = SYS_DVBC_ANNEX_AC;
>
>

------=_Part_35497_19376667.1225602224484
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hello Michel,<br><br>Thanks for your proposals.<br><br>I also has a thought about S2 parameter in frequency file, but decided to perform both DVB-S and DVB-S2 scans automatically since it easy on maintaining the frequency file.<br>
<br>I will probably leave &quot;S&quot; frequency as is and will add &quot;S1&quot; and &quot;S2&quot; if you want to specify what delivery should be used.<br>Also, I&#39;ve been reported that some drivers can&#39;t work with AUTO modulation so it have to be implicitly specified. scan-s2 will have to monitor the modulation and scan S2 channels directly when 8PSK is specified or scan only DVB-S if QPSK is specified.<br>
<br>I&#39;ll review your patches later, don&#39;t have time now.<br><br><div class="gmail_quote">On Sat, Nov 1, 2008 at 5:11 PM, Michel Verbraak <span dir="ltr">&lt;<a href="mailto:michel@verbraak.org">michel@verbraak.org</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Alex,<br>
<br>
Tested your scan-s2 with a Technisat HD2 card.<br>
<br>
Scanning works. But some channels are reported twice with different frequency. I found an error which is fixed by the patch file named scan.c.diff1.<br>
<br>
I would also like to propose the following change (see file scan.c.diff2 or scan.c.diff which includes both patches). This change makes it possible to only scan for DVB-S channels or DVB-S2 channels or both. This is done by specifying lines starting with S or S2 in the input file.<br>

<br>
example input file:<br>
# Astra 19.2E SDT info service transponder<br>
# freq pol sr fec<br>
S 12522000 H 22000000 2/3 &nbsp; &nbsp; &nbsp; &lt;only DVB-S channels are scanned&gt;<br>
S 11914000 H 27500000 AUTO<br>
S 10743750 H 22000000 5/6<br>
S 12187500 H 27500000 3/4<br>
S 12343500 H 27500000 3/4<br>
S 12515250 H 22000000 5/6<br>
S 12574250 H 22000000 5/6<br>
S2 12522000 H 22000000 AUTO &nbsp; &nbsp;&lt;only DVB-S2 channels are scanned&gt;<br>
S2 11914000 H 27500000 AUTO<br>
<br>
I hope this is usefull.<br>
<br>
Regards,<br><font color="#888888">
<br>
Michel.<br>
</font><br>--- scan-s2-88afcf030566/scan.c.orig &nbsp; &nbsp;2008-11-01 10:09:43.000000000 +0100<br>
+++ scan-s2-88afcf030566/scan.c 2008-11-01 15:55:14.000000000 +0100<br>
@@ -906,10 +906,7 @@<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;// New transponder<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;t = alloc_transponder(tn.frequency);<br>
<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; // For sattelites start with DVB-S, it will switch to DVB-S2 if DVB-S gives no results<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if(current_tp-&gt;delivery_system == SYS_DVBS || current_tp-&gt;delivery_system == SYS_DVBS2) {<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; tn.delivery_system = SYS_DVBS;<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; tn.delivery_system = current_tp-&gt;delivery_system;<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;copy_transponder(t, &amp;tn);<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
@@ -1578,7 +1575,10 @@<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if_freq = abs(t-&gt;frequency - lnb_type.low_val);<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (verbosity &gt;= 2)<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (t-&gt;delivery_system == SYS_DVBS)<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;dprintf(1,&quot;DVB-S IF freq is %d\n&quot;, if_freq);<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;else if (t-&gt;delivery_system == SYS_DVBS2)<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; dprintf(1,&quot;DVB-S2 IF freq is %d\n&quot;, if_freq);<br>
 &nbsp; &nbsp; &nbsp; &nbsp;}<br>
<br>
<br>
@@ -1640,7 +1640,8 @@<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;// get the actual parameters from the driver for that channel<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if ((ioctl(frontend_fd, FE_GET_PROPERTY, &amp;cmdseq)) == -1) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;perror(&quot;FE_GET_PROPERTY failed&quot;);<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;last_tuning_failed = 1;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return -1;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;t-&gt;delivery_system = p[0].u.data;<br>
@@ -1722,12 +1723,6 @@<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;rc = tune_to_transponder(frontend_fd, t);<br>
<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; // If scan failed and it&#39;s a DVB-S system, try DVB-S2 before giving up<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (rc != 0 &amp;&amp; t-&gt;delivery_system == SYS_DVBS) {<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;delivery_system = SYS_DVBS2;<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; rc = tune_to_transponder(frontend_fd, t);<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
-<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (rc == 0) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return 0;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
@@ -1992,6 +1987,42 @@<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;t-&gt;frequency,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;pol[0], t-&gt;symbol_rate, fec2str(t-&gt;fec), rolloff2str(t-&gt;rolloff), qam2str(t-&gt;modulation));<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; else if (sscanf(buf, &quot;S2 %u %1[HVLR] %u %4s %4s %6s\n&quot;, &amp;f, pol, &amp;sr, fec, rolloff, qam) &gt;= 3) {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t = alloc_transponder(f);<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;delivery_system = SYS_DVBS2;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;modulation = QAM_AUTO;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;rolloff = ROLLOFF_AUTO;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;fec = FEC_AUTO;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; switch(pol[0])<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; case &#39;H&#39;:<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; case &#39;L&#39;:<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;polarisation = POLARISATION_HORIZONTAL;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; break;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; default:<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;polarisation = POLARISATION_VERTICAL;;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; break;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;inversion = spectral_inversion;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;symbol_rate = sr;<br>
+<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; // parse optional parameters<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if(strlen(fec) &gt; 0) {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;fec = str2fec(fec);<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if(strlen(rolloff) &gt; 0) {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;rolloff = str2rolloff(rolloff);<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if(strlen(qam) &gt; 0) {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;modulation = str2qam(qam);<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; info(&quot;initial transponder %u %c %d %s %s %s\n&quot;,<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;frequency,<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; pol[0], t-&gt;symbol_rate, fec2str(t-&gt;fec), rolloff2str(t-&gt;rolloff), qam2str(t-&gt;modulation));<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;else if (sscanf(buf, &quot;C %u %u %4s %6s\n&quot;, &amp;f, &amp;sr, fec, qam) &gt;= 2) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;t = alloc_transponder(f);<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;t-&gt;delivery_system = SYS_DVBC_ANNEX_AC;<br>
<br>--- scan-s2-88afcf030566/scan.c.orig &nbsp; &nbsp;2008-11-01 10:09:43.000000000 +0100<br>
+++ scan-s2-88afcf030566/scan.c 2008-11-01 15:55:14.000000000 +0100<br>
@@ -1640,7 +1640,8 @@<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;// get the actual parameters from the driver for that channel<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if ((ioctl(frontend_fd, FE_GET_PROPERTY, &amp;cmdseq)) == -1) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;perror(&quot;FE_GET_PROPERTY failed&quot;);<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;last_tuning_failed = 1;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return -1;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;t-&gt;delivery_system = p[0].u.data;<br>
<br>--- scan-s2-88afcf030566/scan.c.orig &nbsp; &nbsp;2008-11-01 10:09:43.000000000 +0100<br>
+++ scan-s2-88afcf030566/scan.c 2008-11-01 15:55:14.000000000 +0100<br>
@@ -906,10 +906,7 @@<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;// New transponder<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;t = alloc_transponder(tn.frequency);<br>
<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; // For sattelites start with DVB-S, it will switch to DVB-S2 if DVB-S gives no results<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if(current_tp-&gt;delivery_system == SYS_DVBS || current_tp-&gt;delivery_system == SYS_DVBS2) {<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; tn.delivery_system = SYS_DVBS;<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; tn.delivery_system = current_tp-&gt;delivery_system;<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;copy_transponder(t, &amp;tn);<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
@@ -1578,7 +1575,10 @@<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if_freq = abs(t-&gt;frequency - lnb_type.low_val);<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (verbosity &gt;= 2)<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (t-&gt;delivery_system == SYS_DVBS)<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;dprintf(1,&quot;DVB-S IF freq is %d\n&quot;, if_freq);<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;else if (t-&gt;delivery_system == SYS_DVBS2)<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; dprintf(1,&quot;DVB-S2 IF freq is %d\n&quot;, if_freq);<br>
 &nbsp; &nbsp; &nbsp; &nbsp;}<br>
<br>
<br>
@@ -1722,12 +1723,6 @@<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;rc = tune_to_transponder(frontend_fd, t);<br>
<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; // If scan failed and it&#39;s a DVB-S system, try DVB-S2 before giving up<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (rc != 0 &amp;&amp; t-&gt;delivery_system == SYS_DVBS) {<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;delivery_system = SYS_DVBS2;<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; rc = tune_to_transponder(frontend_fd, t);<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
-<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (rc == 0) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return 0;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
@@ -1992,6 +1987,42 @@<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;t-&gt;frequency,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;pol[0], t-&gt;symbol_rate, fec2str(t-&gt;fec), rolloff2str(t-&gt;rolloff), qam2str(t-&gt;modulation));<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; else if (sscanf(buf, &quot;S2 %u %1[HVLR] %u %4s %4s %6s\n&quot;, &amp;f, pol, &amp;sr, fec, rolloff, qam) &gt;= 3) {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t = alloc_transponder(f);<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;delivery_system = SYS_DVBS2;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;modulation = QAM_AUTO;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;rolloff = ROLLOFF_AUTO;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;fec = FEC_AUTO;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; switch(pol[0])<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; case &#39;H&#39;:<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; case &#39;L&#39;:<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;polarisation = POLARISATION_HORIZONTAL;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; break;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; default:<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;polarisation = POLARISATION_VERTICAL;;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; break;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;inversion = spectral_inversion;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;symbol_rate = sr;<br>
+<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; // parse optional parameters<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if(strlen(fec) &gt; 0) {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;fec = str2fec(fec);<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if(strlen(rolloff) &gt; 0) {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;rolloff = str2rolloff(rolloff);<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if(strlen(qam) &gt; 0) {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;modulation = str2qam(qam);<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
+<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; info(&quot;initial transponder %u %c %d %s %s %s\n&quot;,<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;frequency,<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; pol[0], t-&gt;symbol_rate, fec2str(t-&gt;fec), rolloff2str(t-&gt;rolloff), qam2str(t-&gt;modulation));<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;else if (sscanf(buf, &quot;C %u %u %4s %6s\n&quot;, &amp;f, &amp;sr, fec, qam) &gt;= 2) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;t = alloc_transponder(f);<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;t-&gt;delivery_system = SYS_DVBC_ANNEX_AC;<br>
<br></blockquote></div><br></div>

------=_Part_35497_19376667.1225602224484--


--===============1134848697==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1134848697==--
