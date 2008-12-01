Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web88306.mail.re4.yahoo.com ([216.39.53.229])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <aturbide@rogers.com>) id 1L7BFq-0002dY-NN
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 17:04:11 +0100
Date: Mon, 1 Dec 2008 08:03:32 -0800 (PST)
From: Alain <aturbide@rogers.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <496119.70264.qm@web88306.mail.re4.yahoo.com>
Subject: [linux-dvb] Bug Report - Twinhan vp-1020, bt_8xx driver + frontend
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0921148768=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0921148768==
Content-Type: multipart/alternative; boundary="0-514767292-1228147412=:70264"

--0-514767292-1228147412=:70264
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi. I didnt find a report of this issue so I'm posting it to the list in ca=
se.=A0=A0=A0 I noted that in changeset 9349, specifically changes to dvb_fr=
ontend.c caused my budget dvb card (Twinhan vp-1020a) to no longer be able =
to tune.=A0 All drivers compile and load correctly.=A0 All changesets after=
 9348 (including the current set of 9767) =A0=A0also exibit the same issue.=
=A0 Using the dvb_frontend.c source file=A0from 9348 and recompiling=A0allo=
ws the drivers to function normally with the latest changeset.
--0-514767292-1228147412=:70264
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman, new york, times, serif;font-size:12pt"><DIV>Hi. I didnt find a report of this issue so I'm posting it to the list in case.&nbsp;&nbsp;&nbsp; I noted that in changeset 9349, specifically changes to dvb_frontend.c caused my budget dvb card (Twinhan vp-1020a) to no longer be able to tune.&nbsp; All drivers compile and load correctly.&nbsp; All changesets after 9348 (including the current set of 9767) &nbsp;&nbsp;also exibit the same issue.&nbsp; Using the dvb_frontend.c source file&nbsp;from 9348 and recompiling&nbsp;allows the drivers to function normally with the latest changeset.</DIV></div></body></html>
--0-514767292-1228147412=:70264--


--===============0921148768==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0921148768==--
