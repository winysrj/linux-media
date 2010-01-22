Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <dvbfreaky007@gmail.com>) id 1NYGeQ-0003dv-2R
	for linux-dvb@linuxtv.org; Fri, 22 Jan 2010 11:22:02 +0100
Received: from mail-bw0-f227.google.com ([209.85.218.227])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NYGeP-0004sm-Jf; Fri, 22 Jan 2010 11:22:01 +0100
Received: by bwz27 with SMTP id 27so866931bwz.1
	for <linux-dvb@linuxtv.org>; Fri, 22 Jan 2010 02:22:01 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 22 Jan 2010 15:52:00 +0530
Message-ID: <fd9871421001220222w7d6e8f6evd5f30efb52c2c150@mail.gmail.com>
From: dvbfreaky 007 <dvbfreaky007@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Initial Scan Data for DVB channel scan,
	How to get Initial DVB Scan 	data
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0454976734=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0454976734==
Content-Type: multipart/alternative; boundary=00032555e432b08da4047dbe3079

--00032555e432b08da4047dbe3079
Content-Type: text/plain; charset=ISO-8859-1

Hi ,
Can anyone share the information, regarding "How initial scan data will
generate"

from "dvb-apps->utils->scan",
to scan for channels, i executed following command
"./scan dvb-s/InSat4B-80.5E"

content of InSat4B-80.5E,
1 # Insat 4B-80.5E
2 # freq pol sr fec
3 S 1000 V 27500000 AUTO
4 S 10234234 V 27500000 AUTO
5 S 11232300 V 27500000 AUTO
6 S 11213343 V 27500000 AUTO
7 S 10990000 V 27500000 AUTO
~

My question is,
who will populate this information and from where they will populate this
info.
Is there any standard transponders frequency list.

like
http://www.lyngsat.com/in4b.html

we must follow this , for tuning?



Is there any tool, which doesnt required any initial data for scanning dvb
channels?


please let me know,

--00032555e432b08da4047dbe3079
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi ,<br>Can anyone share the information, regarding &quot;How initial scan =
data will generate&quot;<br><br>from &quot;dvb-apps-&gt;utils-&gt;scan&quot=
;,<br>to scan for channels, i executed following command<br>&quot;./scan dv=
b-s/InSat4B-80.5E&quot;<br>

<br>content of InSat4B-80.5E,<br>  1 # Insat 4B-80.5E<br>  2 # freq pol sr =
fec<br>  3 S 1000 V 27500000 AUTO<br>  4 S 10234234 V 27500000 AUTO<br>  5 =
S 11232300 V 27500000 AUTO<br>  6 S 11213343 V 27500000 AUTO<br>  7 S 10990=
000 V 27500000 AUTO<br>

~<br><br>My question is,<br>who will populate this information and from whe=
re they will populate this info.<br>Is there any standard transponders freq=
uency list.<br><br>like<br><a href=3D"http://www.lyngsat.com/in4b.html" tar=
get=3D"_blank">http://www.lyngsat.com/in4b.html</a><br>

<br>we must follow this , for tuning?<br><br><br><br>Is there any tool, whi=
ch doesnt required any initial data for scanning dvb channels?<br><br><br>p=
lease let me know,

--00032555e432b08da4047dbe3079--


--===============0454976734==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0454976734==--
