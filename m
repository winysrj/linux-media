Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1KyuTB-0006NC-QU
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 21:31:46 +0100
Received: by qw-out-2122.google.com with SMTP id 9so1085317qwb.17
	for <linux-dvb@linuxtv.org>; Sat, 08 Nov 2008 12:31:40 -0800 (PST)
Message-ID: <c74595dc0811081231s6caeba51o5612cb992edb94b6@mail.gmail.com>
Date: Sat, 8 Nov 2008 22:31:40 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] stb0899 buffer is not cleaned on tunning
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1333554026=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1333554026==
Content-Type: multipart/alternative;
	boundary="----=_Part_71207_1480223.1226176300702"

------=_Part_71207_1480223.1226176300702
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

While working on scan-s2 utility I paid attention that after tuning the
driver still pass the
messages from previously tuned channel. I believe there is some kind of
buffering in device
or driver that is not cleaned after tuning.
The problem is probably not seen when watching the content of the channel,
but affects the scanning
since channels are assigned to a wrong frequency or create some other
anomalies.

When working on my Linux machine via VNC I can see this old content in VDR
too since the
screen is updated slower.

Can someone take a look on that?

Thanks.

------=_Part_71207_1480223.1226176300702
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi all,<br><br>While working on scan-s2 utility I paid attention that after tuning the driver still pass the <br>messages from previously tuned channel. I believe there is some kind of buffering in device <br>
or driver that is not cleaned after tuning.<br>The problem is probably not seen when watching the content of the channel, but affects the scanning<br>since channels are assigned to a wrong frequency or create some other anomalies.<br>
<br>When working on my Linux machine via VNC I can see this old content in VDR too since the<br>screen is updated slower.<br><br>Can someone take a look on that?<br><br>Thanks.<br><br></div>

------=_Part_71207_1480223.1226176300702--


--===============1333554026==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1333554026==--
