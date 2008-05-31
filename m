Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.siberianet.ru ([89.105.136.7])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <wmn@siberianet.ru>) id 1K2R1y-0006CG-3y
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 15:21:59 +0200
Received: from mail.siberianet.ru (mail.siberianet.ru [89.105.136.7])
	by mail.siberianet.ru (Postfix) with ESMTP id D69DC1DE172
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 21:21:22 +0800 (KRAST)
Received: from mail.siberianet.ru (mail.siberianet.ru [89.105.136.7])
	by mail.siberianet.ru (Postfix) with ESMTP id B50CE1DE15C
	for <linux-dvb@linuxtv.org>; Sat, 31 May 2008 21:21:22 +0800 (KRAST)
MIME-Version: 1.0
Date: Sat, 31 May 2008 21:21:22 +0800
From: <wmn@siberianet.ru>
To: linux-dvb@linuxtv.org
Message-ID: <e3441656877e3ba96ad8e1dffd546567@mail.siberianet.ru>
Subject: [linux-dvb] Patch to scan utility that allows giving data for
 initial tuning (DVB-S) from the command line instead of a file only
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1824160645=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1824160645==
Content-Type: multipart/alternative;
	boundary="=_318e74844fe1e4b7b8abe27a7de67f10"

--=_318e74844fe1e4b7b8abe27a7de67f10
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable



 Hello. =20

 Here is my patch to scan utility that allows giving data for initial
tuning (DVB-S) from the command line instead of a file only. =20

 It is useful for me and maybe it will be useful for someone else. =20

 18a19,21
 >  *=20
 >  * 2008-05-31 - Added -F-S-z-E console parameters for initial
tuning
 >  *    Added by Wmn
 1691c1694
 < static int tune_initial (int frontend_fd, const char *initial)
 ---
 > static int tune_initial (int frontend_fd, const char *initial,
unsigned int freq, unsigned int srate, char polar, char *_fec)
 1699,1702c1702,1801
 <  inif =3D fopen(initial, "r");
 <  if (!inif) {
 <   error("cannot open '%s': %d %mn", initial, errno);
 <   return -1;
 ---
 >     if (!freq || !srate)
 >     {
 >         inif =3D fopen(initial, "r");
 >         if (!inif) {
 >             error("cannot open '%s': %d %mn", initial, errno);
 >             return -1;
 >         }
 >         while (fgets(buf, sizeof(buf), inif)) {
 >             if (buf[0] =3D=3D '#' || buf[0] =3D=3D 'n')
 >  =20
             ;
 >             else if (sscanf(buf, "S %u %1[HVLR] %u %4sn", &f, pol,
&sr, fec) =3D=3D 4) {
 >                 t =3D alloc_transponder(f);
 >                 t->type =3D FE_QPSK;
 >                 switch(pol[0]) {
 >                     case 'H':
 >                     case 'L':
 >                         t->polarisation =3D POLARISATION_HORIZONTAL;
 >                         break;
 >                     default:
 >                         t->polarisation =3D POLARISATION_VERTICAL;;
 >                         break;
 >                 }
 >                 t->param.inversion =3D spectral_inversion;
 >                 t->param.u.qpsk.symbol_rate =3D sr;
 >                 t->param.u.qpsk.fec_inner =3D str2fec(fec);
 >                 info("initial transponder %u %c %u %dn",
 >                         t->param.frequency,
 >                         pol[0], sr,
 >                         t->param.u.qpsk.fec_inner);
 >             }
 >             else if (sscanf(buf, "C %u %u %4s %6sn",
&f, &sr, fec,
qam) =3D=3D 4) {
 >                 t =3D alloc_transponder(f);
 >                 t->type =3D FE_QAM;
 >                 t->param.inversion =3D spectral_inversion;
 >                 t->param.u.qam.symbol_rate =3D sr;
 >                 t->param.u.qam.fec_inner =3D str2fec(fec);
 >                 t->param.u.qam.modulation =3D str2qam(qam);
 >                 info("initial transponder %u %u %d %dn",
 >                         t->param.frequency,
 >                         sr,
 >                         t->param.u.qam.fec_inner,
 >                         t->param.u.qam.modulation);
 >             }
 >             else if (sscanf(buf, "T %u %4s %4s %4s %7s %4s %4s
%4sn",
 >                         &f, bw, fec, fec2, qam, mode, guard, hier)
=3D=3D 8) {
 >                 t =3D alloc_transponder(f);
 >                 t->type =3D FE_OFDM;
 >                 t->param.inversion =3D spectral_inversion;
 >                 t->param.u.ofdm.bandwidth =3D str2bandwidth(bw);
 >               =20
t->param.u.ofdm.code_rate_HP =3D str2fec(fec);
 >                 if (t->param.u.ofdm.code_rate_HP =3D=3D FEC_NONE)
 >                     t->param.u.ofdm.code_rate_HP =3D FEC_AUTO;
 >                 t->param.u.ofdm.code_rate_LP =3D str2fec(fec2);
 >                 if (t->param.u.ofdm.code_rate_LP =3D=3D FEC_NONE)
 >                     t->param.u.ofdm.code_rate_LP =3D FEC_AUTO;
 >                 t->param.u.ofdm.constellation =3D str2qam(qam);
 >                 t->param.u.ofdm.transmission_mode =3D
str2mode(mode);
 >                 t->param.u.ofdm.guard_interval =3D str2guard(guard);
 >                 t->param.u.ofdm.hierarchy_information =3D
str2hier(hier);
 >                 info("initial transponder %u %d %d %d %d %d %d
%dn",
 >                         t->param.frequency,
 >                         t->param.u.ofdm.bandwidth,
 >                         t->param.u.ofdm.code_rate_HP,
 >                         t->param.u.ofdm.code_rate_LP,
 >                         t->param.u.ofdm.constellation,
 > =20
                      t->param.u.ofdm.transmission_mode,
 >                         t->param.u.ofdm.guard_interval,
 >                         t->param.u.ofdm.hierarchy_information);
 >             }
 >             else if (sscanf(buf, "A %u %7sn",
 >                         &f,qam) =3D=3D 2) {
 >                 t =3D alloc_transponder(f);
 >                 t->type =3D FE_ATSC;
 >                 t->param.u.vsb.modulation =3D str2qam(qam);
 >             } else
 >                 error("cannot parse'%s'n", buf);
 >         }
 >=20
 >         fclose(inif);
 >     }
 >     else
 >     {
 >         t =3D alloc_transponder(freq);
 >         t->type =3D FE_QPSK;
 >         switch(polar) {
 >             case 'H':
 >             case 'L':
 >                 t->polarisation =3D POLARISATION_HORIZONTAL;
 >                 break;
 >             default:
 >                 t->polarisation =3D POLARISATION_VERTICAL;;
 >                 break;
 >         }
 >         t->param.inversion =3D spectral_inversion;
 >  =20
     t->param.u.qpsk.symbol_rate =3D srate;
 >         t->param.u.qpsk.fec_inner =3D str2fec(_fec);
 >         info("initial transponder %u %c %u %dn",
 >                 t->param.frequency,
 >                 polar, srate,
 >                 t->param.u.qpsk.fec_inner);
 1704,1775d1802
 <  while (fgets(buf, sizeof(buf), inif)) {
 <   if (buf[0] =3D=3D '#' || buf[0] =3D=3D 'n')
 <    ;
 <   else if (sscanf(buf, "S %u %1[HVLR] %u %4sn", &f, pol, &sr, fec)
=3D=3D 4) {
 <    t =3D alloc_transponder(f);
 <    t->type =3D FE_QPSK;
 <    switch(pol[0]) {
 <     case 'H':
 <     case 'L':
 <      t->polarisation =3D POLARISATION_HORIZONTAL;
 <      break;
 <     default:
 <      t->polarisation =3D POLARISATION_VERTICAL;;
 <      break;
 <    }
 <    t->param.inversion =3D spectral_inversion;
 <    t->param.u.qpsk.symbol_rate =3D sr;
 <    t->param.u.qpsk.fec_inner =3D str2fec(fec);
 <    info("initial transponder %u %c %u %dn",
 <      t->param.frequency,
 <      pol[0], sr,
 <      t->param.u.qpsk.fec_inner);
 <   }
 <
  else if (sscanf(buf, "C %u %u %4s %6sn", &f, &sr, fec, qam) =3D=3D
4) {
 <    t =3D alloc_transponder(f);
 <    t->type =3D FE_QAM;
 <    t->param.inversion =3D spectral_inversion;
 <    t->param.u.qam.symbol_rate =3D sr;
 <    t->param.u.qam.fec_inner =3D str2fec(fec);
 <    t->param.u.qam.modulation =3D str2qam(qam);
 <    info("initial transponder %u %u %d %dn",
 <      t->param.frequency,
 <      sr,
 <      t->param.u.qam.fec_inner,
 <      t->param.u.qam.modulation);
 <   }
 <   else if (sscanf(buf, "T %u %4s %4s %4s %7s %4s %4s %4sn",
 <      &f, bw, fec, fec2, qam, mode, guard, hier) =3D=3D 8) {
 <    t =3D alloc_transponder(f);
 <    t->type =3D FE_OFDM;
 <    t->param.inversion =3D spectral_inversion;
 <    t->param.u.ofdm.bandwidth =3D str2bandwidth(bw);
 <    t->param.u.ofdm.code_rate_HP =3D str2fec(fec);
 <    if (t->param.u.ofdm.code_rate_HP =3D=3D FEC_NONE)
 <     t->param.u.ofdm.code_rate_HP =3D FEC_AUTO;
 <    t->param.u.ofdm.code_rate_LP =3D str2fec(fec2);
 <    if (t->param.u.ofdm.code_rate_LP =3D=3D
FEC_NONE)
 <     t->param.u.ofdm.code_rate_LP =3D FEC_AUTO;
 <    t->param.u.ofdm.constellation =3D str2qam(qam);
 <    t->param.u.ofdm.transmission_mode =3D str2mode(mode);
 <    t->param.u.ofdm.guard_interval =3D str2guard(guard);
 <    t->param.u.ofdm.hierarchy_information =3D str2hier(hier);
 <    info("initial transponder %u %d %d %d %d %d %d %dn",
 <      t->param.frequency,
 <      t->param.u.ofdm.bandwidth,
 <      t->param.u.ofdm.code_rate_HP,
 <      t->param.u.ofdm.code_rate_LP,
 <      t->param.u.ofdm.constellation,
 <      t->param.u.ofdm.transmission_mode,
 <      t->param.u.ofdm.guard_interval,
 <      t->param.u.ofdm.hierarchy_information);
 <   }
 <   else if (sscanf(buf, "A %u %7sn",
 <      &f,qam) =3D=3D 2) {
 <    t =3D alloc_transponder(f);
 <    t->type =3D FE_ATSC;
 <    t->param.u.vsb.modulation =3D str2qam(qam);
 <   } else
 <    error("cannot parse'%s'n", buf);
 <  }
 <=20
 <  fclose(inif);
 1858c1885
 < static void scan_network (int frontend_fd, const char *initial)
 ---
 >
static void scan_network (int frontend_fd, const char *initial,
unsigned int freq, unsigned int srate, char polar, char *fec)
 1860c1887
 <  if (tune_initial (frontend_fd, initial) < 0) {
 ---
 >  if (tune_initial (frontend_fd, initial, freq, srate, polar, fec)
< 0) {
 2054c2081
 <  "usage: %s [options...] [-c | initial-tuning-data-file]n"
 ---
 >  "usage: %s [options...] [-c | -F-S[-z-E] |
initial-tuning-data-file]n"
 2084c2111,2117
 <  " -U Uniquely name unknown servicesn";
 ---
 >  " -U Uniquely name unknown servicesn"
 >  "n"
 >  " Initial tune data:n"
 >  " -F N Frequency for initial tunen"
 >  " -S N Symbol-rate for initial tunen"
 >  " -z  Polarization for initial tunen"
 >  " -E  FEC for initial tunen";
 2122a2156,2158
 >     unsigned int srate =3D 0, freq =3D 0;
 >     char polar =3D 'V';
 >     char fec[] =3D "AUTO";
 2132c2168
 <  while ((opt =3D getopt(argc, argv,
"5cnpa:f:d:s:o:x:e:t:i:l:vquPA:U")) !=3D -1) {
 ---
 >  while ((opt =3D getopt(argc,
argv,
"5cnpa:f:d:s:o:x:e:t:i:l:vquPA:US:F:z:E:")) !=3D -1) {
 2207d2242
 <=20
 2211a2247,2259
 >   case 'S':
 >             srate =3D strtoul(optarg, NULL, 0);
 >    break;
 >   case 'F':
 >             freq =3D strtoul(optarg, NULL, 0);
 >    break;
 >   case 'z':
 >             polar =3D optarg[0];
 >             break;
 >   case 'E':
 >             strncpy (fec, optarg, 4);
 >             fec[4] =3D '';
 >             break;
 2220c2268
 <  if ((!initial && !current_tp_only) || (initial &&
current_tp_only) ||
 ---
 >  if ((((!freq || !srate) && !initial) && !current_tp_only) ||
(((freq && srate) || initial) && current_tp_only) ||
 2269c2317
 <   scan_network (frontend_fd, initial);
 ---
 >   scan_network (frontend_fd, initial, freq, srate, polar, fec); =20
--=_318e74844fe1e4b7b8abe27a7de67f10
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<p>
Hello.
</p>
<p>
Here is my patch to scan utility that allows giving data for initial tuning=
 (DVB-S) from the command line instead of a file only.
</p>
<p>
It is useful for me and maybe it will be useful for someone else.
</p>
<p>
18a19,21<br />
&gt;&nbsp; * <br />
&gt;&nbsp; * 2008-05-31 - Added -F-S-z-E console parameters for initial tun=
ing<br />
&gt;&nbsp; *&nbsp;&nbsp;&nbsp; Added by Wmn<br />
1691c1694<br />
&lt; static int tune_initial (int frontend_fd, const char *initial)<br />
---<br />
&gt; static int tune_initial (int frontend_fd, const char *initial, unsigne=
d int freq, unsigned int srate, char polar, char *_fec)<br />
1699,1702c1702,1801<br />
&lt; &nbsp;inif =3D fopen(initial, &quot;r&quot;);<br />
&lt; &nbsp;if (!inif) {<br />
&lt; &nbsp;&nbsp;error(&quot;cannot open '%s': %d %m\n&quot;, initial, errn=
o);<br />
&lt; &nbsp;&nbsp;return -1;<br />
---<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp; if (!freq || !srate)<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp; {<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inif =3D fopen(initial=
, &quot;r&quot;);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!inif) {<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; error(&quot;cannot open '%s': %d %m\n&quot;, initial, errno);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; return -1;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while (fgets(buf, size=
of(buf), inif)) {<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; if (buf[0] =3D=3D '#' || buf[0] =3D=3D '\n')<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; else if (sscanf(buf, &quot;S %u %1[HVLR] %u %4s\n&quot;, &amp;f, pol, &am=
p;sr, fec) =3D=3D 4) {<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t =3D alloc_transponder(f);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;type =3D FE_QPSK;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; switch(pol[0]) {<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'H':<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'L':<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;polarisation =3D POLARISATION_HORIZONTAL;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b=
reak;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; default:<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;polarisation =3D POLARISATION_VERTICAL;;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b=
reak;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; }<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.inversion =3D spectral_inversion;<br =
/>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.qpsk.symbol_rate =3D sr;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.qpsk.fec_inner =3D str2fec(fec);<br=
 />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; info(&quot;initial transponder %u %c %u %d\n&quot=
;,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.frequency,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; p=
ol[0], sr,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.u.qpsk.fec_inner);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; }<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; else if (sscanf(buf, &quot;C %u %u %4s %6s\n&quot;, &amp;f, &amp;sr, fec,=
 qam) =3D=3D 4) {<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t =3D alloc_transponder(f);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;type =3D FE_QAM;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.inversion =3D spectral_inversion;<br =
/>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.qam.symbol_rate =3D sr;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.qam.fec_inner =3D str2fec(fec);<br =
/>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.qam.modulation =3D str2qam(qam);<br=
 />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; info(&quot;initial transponder %u %u %d %d\n&quot=
;,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.frequency,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; s=
r,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.u.qam.fec_inner,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.u.qam.modulation);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; }<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; else if (sscanf(buf, &quot;T %u %4s %4s %4s %7s %4s %4s %4s\n&quot;,<br /=
>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &=
amp;f, bw, fec, fec2, qam, mode, guard, hier) =3D=3D 8) {<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t =3D alloc_transponder(f);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;type =3D FE_OFDM;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.inversion =3D spectral_inversion;<br =
/>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.ofdm.bandwidth =3D str2bandwidth(bw=
);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.ofdm.code_rate_HP =3D str2fec(fec);=
<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; if (t-&gt;param.u.ofdm.code_rate_HP =3D=3D FEC_NO=
NE)<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.ofdm.code_r=
ate_HP =3D FEC_AUTO;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.ofdm.code_rate_LP =3D str2fec(fec2)=
;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; if (t-&gt;param.u.ofdm.code_rate_LP =3D=3D FEC_NO=
NE)<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.ofdm.code_r=
ate_LP =3D FEC_AUTO;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.ofdm.constellation =3D str2qam(qam)=
;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.ofdm.transmission_mode =3D str2mode=
(mode);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.ofdm.guard_interval =3D str2guard(g=
uard);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.ofdm.hierarchy_information =3D str2=
hier(hier);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; info(&quot;initial transponder %u %d %d %d %d %d =
%d %d\n&quot;,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.frequency,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.u.ofdm.bandwidth,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.u.ofdm.code_rate_HP,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.u.ofdm.code_rate_LP,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.u.ofdm.constellation,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.u.ofdm.transmission_mode,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.u.ofdm.guard_interval,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t=
-&gt;param.u.ofdm.hierarchy_information);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; }<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; else if (sscanf(buf, &quot;A %u %7s\n&quot;,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &=
amp;f,qam) =3D=3D 2) {<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t =3D alloc_transponder(f);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;type =3D FE_ATSC;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.vsb.modulation =3D str2qam(qam);<br=
 />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; } else<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; error(&quot;cannot parse'%s'\n&quot;, buf);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br />
&gt; <br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fclose(inif);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp; }<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp; else<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp; {<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t =3D alloc_transponde=
r(freq);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;type =3D FE_QPSK=
;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; switch(polar) {<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; case 'H':<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; case 'L':<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;polarisation =3D POLARISATION_HORIZONTAL;<b=
r />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; break;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; default:<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;polarisation =3D POLARISATION_VERTICAL;;<br=
 />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; break;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.inversion =
=3D spectral_inversion;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.qpsk.sym=
bol_rate =3D srate;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.qpsk.fec=
_inner =3D str2fec(_fec);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; info(&quot;initial tra=
nsponder %u %c %u %d\n&quot;,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.frequency,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; polar, srate,<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; t-&gt;param.u.qpsk.fec_inner);<br />
1704,1775d1802<br />
&lt; &nbsp;while (fgets(buf, sizeof(buf), inif)) {<br />
&lt; &nbsp;&nbsp;if (buf[0] =3D=3D '#' || buf[0] =3D=3D '\n')<br />
&lt; &nbsp;&nbsp;&nbsp;;<br />
&lt; &nbsp;&nbsp;else if (sscanf(buf, &quot;S %u %1[HVLR] %u %4s\n&quot;, &=
amp;f, pol, &amp;sr, fec) =3D=3D 4) {<br />
&lt; &nbsp;&nbsp;&nbsp;t =3D alloc_transponder(f);<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;type =3D FE_QPSK;<br />
&lt; &nbsp;&nbsp;&nbsp;switch(pol[0]) {<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;case 'H':<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;case 'L':<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;polarisation =3D POLARISATION_HORI=
ZONTAL;<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;break;<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;default:<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;polarisation =3D POLARISATION_VERT=
ICAL;;<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;break;<br />
&lt; &nbsp;&nbsp;&nbsp;}<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.inversion =3D spectral_inversion;<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.qpsk.symbol_rate =3D sr;<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.qpsk.fec_inner =3D str2fec(fec);<br />
&lt; &nbsp;&nbsp;&nbsp;info(&quot;initial transponder %u %c %u %d\n&quot;,<=
br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.frequency,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pol[0], sr,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.qpsk.fec_inner);<br />
&lt; &nbsp;&nbsp;}<br />
&lt; &nbsp;&nbsp;else if (sscanf(buf, &quot;C %u %u %4s %6s\n&quot;, &amp;f=
, &amp;sr, fec, qam) =3D=3D 4) {<br />
&lt; &nbsp;&nbsp;&nbsp;t =3D alloc_transponder(f);<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;type =3D FE_QAM;<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.inversion =3D spectral_inversion;<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.qam.symbol_rate =3D sr;<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.qam.fec_inner =3D str2fec(fec);<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.qam.modulation =3D str2qam(qam);<br />
&lt; &nbsp;&nbsp;&nbsp;info(&quot;initial transponder %u %u %d %d\n&quot;,<=
br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.frequency,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sr,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.qam.fec_inner,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.qam.modulation);<br />
&lt; &nbsp;&nbsp;}<br />
&lt; &nbsp;&nbsp;else if (sscanf(buf, &quot;T %u %4s %4s %4s %7s %4s %4s %4=
s\n&quot;,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&amp;f, bw, fec, fec2, qam, mode, guard,=
 hier) =3D=3D 8) {<br />
&lt; &nbsp;&nbsp;&nbsp;t =3D alloc_transponder(f);<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;type =3D FE_OFDM;<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.inversion =3D spectral_inversion;<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.bandwidth =3D str2bandwidth(bw);<=
br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.code_rate_HP =3D str2fec(fec);<br=
 />
&lt; &nbsp;&nbsp;&nbsp;if (t-&gt;param.u.ofdm.code_rate_HP =3D=3D FEC_NONE)=
<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.code_rate_HP =3D FEC_AUTO;<=
br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.code_rate_LP =3D str2fec(fec2);<b=
r />
&lt; &nbsp;&nbsp;&nbsp;if (t-&gt;param.u.ofdm.code_rate_LP =3D=3D FEC_NONE)=
<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.code_rate_LP =3D FEC_AUTO;<=
br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.constellation =3D str2qam(qam);<b=
r />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.transmission_mode =3D str2mode(mo=
de);<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.guard_interval =3D str2guard(guar=
d);<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.hierarchy_information =3D str2hie=
r(hier);<br />
&lt; &nbsp;&nbsp;&nbsp;info(&quot;initial transponder %u %d %d %d %d %d %d =
%d\n&quot;,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.frequency,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.bandwidth,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.code_rate_HP,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.code_rate_LP,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.constellation,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.transmission_mode,<br=
 />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.guard_interval,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;t-&gt;param.u.ofdm.hierarchy_information=
);<br />
&lt; &nbsp;&nbsp;}<br />
&lt; &nbsp;&nbsp;else if (sscanf(buf, &quot;A %u %7s\n&quot;,<br />
&lt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&amp;f,qam) =3D=3D 2) {<br />
&lt; &nbsp;&nbsp;&nbsp;t =3D alloc_transponder(f);<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;type =3D FE_ATSC;<br />
&lt; &nbsp;&nbsp;&nbsp;t-&gt;param.u.vsb.modulation =3D str2qam(qam);<br />
&lt; &nbsp;&nbsp;} else<br />
&lt; &nbsp;&nbsp;&nbsp;error(&quot;cannot parse'%s'\n&quot;, buf);<br />
&lt; &nbsp;}<br />
&lt; <br />
&lt; &nbsp;fclose(inif);<br />
1858c1885<br />
&lt; static void scan_network (int frontend_fd, const char *initial)<br />
---<br />
&gt; static void scan_network (int frontend_fd, const char *initial, unsign=
ed int freq, unsigned int srate, char polar, char *fec)<br />
1860c1887<br />
&lt; &nbsp;if (tune_initial (frontend_fd, initial) &lt; 0) {<br />
---<br />
&gt; &nbsp;if (tune_initial (frontend_fd, initial, freq, srate, polar, fec)=
 &lt; 0) {<br />
2054c2081<br />
&lt; &nbsp;&quot;usage: %s [options...] [-c | initial-tuning-data-file]\n&q=
uot;<br />
---<br />
&gt; &nbsp;&quot;usage: %s [options...] [-c | -F-S[-z-E] | initial-tuning-d=
ata-file]\n&quot;<br />
2084c2111,2117<br />
&lt; &nbsp;&quot;&nbsp;-U&nbsp;Uniquely name unknown services\n&quot;;<br /=
>
---<br />
&gt; &nbsp;&quot;&nbsp;-U&nbsp;Uniquely name unknown services\n&quot;<br />
&gt; &nbsp;&quot;\n&quot;<br />
&gt; &nbsp;&quot;&nbsp;Initial tune data:\n&quot;<br />
&gt; &nbsp;&quot;&nbsp;-F N&nbsp;Frequency for initial tune\n&quot;<br />
&gt; &nbsp;&quot;&nbsp;-S N&nbsp;Symbol-rate for initial tune\n&quot;<br />
&gt; &nbsp;&quot;&nbsp;-z &lt;V=3Ddefault|H|R|L&gt; Polarization for initia=
l tune\n&quot;<br />
&gt; &nbsp;&quot;&nbsp;-E &lt;NONE|1/2|2/3|3/4|4/5|5/6|6/7|7/8|8/9|AUTO=3Dd=
efault&gt; FEC for initial tune\n&quot;;<br />
2122a2156,2158<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int srate =3D 0, freq =3D 0;<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp; char polar =3D 'V';<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp; char fec[] =3D &quot;AUTO&quot;;<br />
2132c2168<br />
&lt; &nbsp;while ((opt =3D getopt(argc, argv, &quot;5cnpa:f:d:s:o:x:e:t:i:l=
:vquPA:U&quot;)) !=3D -1) {<br />
---<br />
&gt; &nbsp;while ((opt =3D getopt(argc, argv, &quot;5cnpa:f:d:s:o:x:e:t:i:l=
:vquPA:US:F:z:E:&quot;)) !=3D -1) {<br />
2207d2242<br />
&lt; <br />
2211a2247,2259<br />
&gt; &nbsp;&nbsp;case 'S':<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; srate =3D strtoul(optarg, NULL, 0);<br />
&gt; &nbsp;&nbsp;&nbsp;break;<br />
&gt; &nbsp;&nbsp;case 'F':<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; freq =3D strtoul(optarg, NULL, 0);<br />
&gt; &nbsp;&nbsp;&nbsp;break;<br />
&gt; &nbsp;&nbsp;case 'z':<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; polar =3D optarg[0];<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; break;<br />
&gt; &nbsp;&nbsp;case 'E':<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; strncpy (fec, optarg, 4);<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; fec[4] =3D '\0';<br />
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; break;<br />
2220c2268<br />
&lt; &nbsp;if ((!initial &amp;&amp; !current_tp_only) || (initial &amp;&amp=
; current_tp_only) ||<br />
---<br />
&gt; &nbsp;if ((((!freq || !srate) &amp;&amp; !initial) &amp;&amp; !current=
_tp_only) || (((freq &amp;&amp; srate) || initial) &amp;&amp; current_tp_on=
ly) ||<br />
2269c2317<br />
&lt; &nbsp;&nbsp;scan_network (frontend_fd, initial);<br />
---<br />
&gt; &nbsp;&nbsp;scan_network (frontend_fd, initial, freq, srate, polar, fe=
c);=20
</p>

--=_318e74844fe1e4b7b8abe27a7de67f10--




--===============1824160645==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1824160645==--
