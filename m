Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n7.bullet.re3.yahoo.com ([68.142.237.92])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <korey_avail@yahoo.com>) id 1Ko2fv-0002BF-RD
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 23:04:02 +0200
Date: Thu, 9 Oct 2008 14:03:24 -0700 (PDT)
From: Korey ODell <korey_avail@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <608093.24875.qm@web57503.mail.re1.yahoo.com>
Subject: [linux-dvb] XC5000 tuner,
	DViCO FusionHDTV7 Dual Express signal strength problem
Reply-To: korey_avail@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1282669010=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1282669010==
Content-Type: multipart/alternative; boundary="0-918113751-1223586204=:24875"

--0-918113751-1223586204=:24875
Content-Type: text/plain; charset=us-ascii

Hello. Under linux 2.6.24, latest v4l drivers, my card works fine as far as producing a/v.
It locks on fine and I can read the /dev/dvb/adapter0/dvr0 device.
However none of the apps that report signal strength i.e. azap, femon, will report anything but a 0% signal strength value.
This card has the xc5000 tuner.


My application reads the device via an ioctl call to the frontend. Works fine with my older HDTV5 Gold card and same drivers.

Any guidance? Thanks.


      
--0-918113751-1223586204=:24875
Content-Type: text/html; charset=us-ascii

<table cellspacing="0" cellpadding="0" border="0" ><tr><td valign="top" style="font: inherit;">Hello. Under linux 2.6.24, latest v4l drivers, my card works fine as far as producing a/v.<br>It locks on fine and I can read the /dev/dvb/adapter0/dvr0 device.<br>However none of the apps that report signal strength i.e. azap, femon, will report anything but a 0% signal strength value.<br>This card has the xc5000 tuner.<br>
<br>My application reads the device via an ioctl call to the frontend. Works fine with my older HDTV5 Gold card and same drivers.<br><br>Any guidance? Thanks.</td></tr></table><br>

      
--0-918113751-1223586204=:24875--



--===============1282669010==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1282669010==--
