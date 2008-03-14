Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <moreau.steve@gmail.com>) id 1Ja9P3-00070X-PU
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 13:52:59 +0100
Received: by fg-out-1718.google.com with SMTP id 22so3130768fge.25
	for <linux-dvb@linuxtv.org>; Fri, 14 Mar 2008 05:52:50 -0700 (PDT)
Message-ID: <bbc1085f0803140552p5377adddn48079f9cab074391@mail.gmail.com>
Date: Fri, 14 Mar 2008 13:52:50 +0100
From: "Steve Moreau" <moreau.steve@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Kworld DVB-T 210 - dvb tuning problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2065282700=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2065282700==
Content-Type: multipart/alternative;
	boundary="----=_Part_2416_16424830.1205499170288"

------=_Part_2416_16424830.1205499170288
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I forgot the most important part (naturally :-))

# tail /var/log/messages
Mar 14 13:16:13 test-desktop kernel: [94017.966160] dvb_frontend_ioctl:
DVBFE_GET_INFO
Mar 14 13:16:14 test-desktop kernel: [94018.187339] newfec_to_oldfec:
Unsupported FEC 3
Mar 14 13:16:14 test-desktop kernel: [94018.187346] dvb_frontend_ioctl:
FESTATE_RETUNE: fepriv->state=2
Mar 14 13:16:14 test-desktop kernel: [94018.190417] tda8261_get_bandwidth:
Bandwidth=40000000
Mar 14 13:16:14 test-desktop kernel: [94018.193820] tda8261_get_bandwidth:
Bandwidth=40000000
Mar 14 13:16:14 test-desktop kernel: [94018.195480] tda8261_set_state: Step
size=1, Divider=1000, PG=0x793 (1939)
Mar 14 13:16:14 test-desktop kernel: [94018.195542] tda8261_write: write
error, err=-121
Mar 14 13:16:14 test-desktop kernel: [94018.195546] tda8261_set_state: I/O
Error
Mar 14 13:16:14 test-desktop kernel: [94018.195550] tda8261_set_frequency:
Invalid parameter
Mar 14 13:16:14 test-desktop kernel: [94018.195555] tda8261_get_frequency:
Frequency=0
Mar 14 13:16:14 test-desktop kernel: [94018.200483] tda8261_get_bandwidth:
Bandwidth=40000000
Mar 14 13:16:14 test-desktop kernel: [94018.771196] tda8261_get_bandwidth:
Bandwidth=40000000
Mar 14 13:16:14 test-desktop kernel: [94018.774587] tda8261_get_bandwidth:
Bandwidth=40000000
Mar 14 13:16:14 test-desktop kernel: [94018.776208] tda8261_set_state: Step
size=1, Divider=1000, PG=0x793 (1939)
Mar 14 13:16:14 test-desktop kernel: [94018.776268] tda8261_write: write
error, err=-121
Mar 14 13:16:14 test-desktop kernel: [94018.776272] tda8261_set_state: I/O
Error

I guess I should keep on backtracking this write error, shouldn't I ?
Yeap, surely...

Steve

------=_Part_2416_16424830.1205499170288
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>I forgot the most important part (naturally :-))<br><br># tail /var/log/messages<br>Mar 14 13:16:13 test-desktop kernel: [94017.966160] dvb_frontend_ioctl: DVBFE_GET_INFO<br>Mar 14 13:16:14 test-desktop kernel: [94018.187339] newfec_to_oldfec: Unsupported FEC 3<br>

Mar 14 13:16:14 test-desktop kernel: [94018.187346] dvb_frontend_ioctl: FESTATE_RETUNE: fepriv-&gt;state=2<br>Mar 14 13:16:14 test-desktop kernel: [94018.190417] tda8261_get_bandwidth: Bandwidth=40000000<br>Mar 14 13:16:14 test-desktop kernel: [94018.193820] tda8261_get_bandwidth: Bandwidth=40000000<br>

Mar 14 13:16:14 test-desktop kernel: [94018.195480] tda8261_set_state: Step size=1, Divider=1000, PG=0x793 (1939)<br>Mar 14 13:16:14 test-desktop kernel: [94018.195542] tda8261_write: write error, err=-121<br>Mar 14 13:16:14 test-desktop kernel: [94018.195546] tda8261_set_state: I/O Error<br>

Mar 14 13:16:14 test-desktop kernel: [94018.195550] tda8261_set_frequency: Invalid parameter<br>Mar 14 13:16:14 test-desktop kernel: [94018.195555] tda8261_get_frequency: Frequency=0<br>Mar 14 13:16:14 test-desktop kernel: [94018.200483] tda8261_get_bandwidth: Bandwidth=40000000<br>

Mar 14 13:16:14 test-desktop kernel: [94018.771196] tda8261_get_bandwidth: Bandwidth=40000000<br>Mar 14 13:16:14 test-desktop kernel: [94018.774587] tda8261_get_bandwidth: Bandwidth=40000000<br>Mar 14 13:16:14 test-desktop kernel: [94018.776208] tda8261_set_state: Step size=1, Divider=1000, PG=0x793 (1939)<br>

Mar 14 13:16:14 test-desktop kernel: [94018.776268] tda8261_write: write error, err=-121<br>Mar 14 13:16:14 test-desktop kernel: [94018.776272] tda8261_set_state: I/O Error<br><br>I guess I should keep on backtracking this write error, shouldn&#39;t I ?<br>

Yeap, surely...<br><br>Steve<br>

------=_Part_2416_16424830.1205499170288--


--===============2065282700==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2065282700==--
