Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ag-out-0708.google.com ([72.14.246.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sergeniki@googlemail.com>) id 1K4FUT-0003P2-03
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 15:26:57 +0200
Received: by ag-out-0708.google.com with SMTP id 8so1942799agc.0
	for <linux-dvb@linuxtv.org>; Thu, 05 Jun 2008 06:26:48 -0700 (PDT)
Message-ID: <9e5406cc0806050626r5588f1d3k36896b75c05070b0@mail.gmail.com>
Date: Thu, 5 Jun 2008 14:26:48 +0100
From: "Serge Nikitin" <sergeniki@googlemail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb]  PEAK DVB-T Digital Dual Tuner PCI - anyone got this
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1425138589=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1425138589==
Content-Type: multipart/alternative;
	boundary="----=_Part_2339_30726719.1212672408173"

------=_Part_2339_30726719.1212672408173
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Andrew,

PEAK DVB-T Dual tuner PCI (221544AGPK) is either renamed or rebadged KWorld
DVB-T PC160 card.

I'm using first tuner on this card with help of the driver from following
source tree (snapshot was taken around 20/05/2008):
http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/
and latest firmware from
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/

Small modification for sources (file af9015.c) was needed (just add one more
USB Device ID (1b80:c160)) and the card is "just work" as a single-tuner
card.

I have not test second tuner due to following issue:

Second tuner identified itself correctly only after really "cold restart"
(power down, wait some time, power up):
May 20 23:39:09 dvbbird kernel: DVB: registering new adapter (KWorld  PC160
(PEAK 221544AGPK) DVB-T PCI dual tuner)
May 20 23:39:10 dvbbird kernel: af9013: firmware version:4.95.0
May 20 23:39:10 dvbbird kernel: tda18271 3-00c0: creating new instance
May 20 23:39:10 dvbbird kernel: TDA18271HD/C1 detected @ 3-00c0
May 20 23:39:10 dvbbird kernel: dvb-usb: will pass the complete MPEG2
transportstream to the software demuxer.
May 20 23:39:10 dvbbird kernel: DVB: registering new adapter (KWorld  PC160
(PEAK 221544AGPK) DVB-T PCI dual tuner)
May 20 23:39:11 dvbbird kernel: af9013: firmware version:4.95.0
May 20 23:39:11 dvbbird kernel: tda18271 4-00c0: creating new instance
May 20 23:39:11 dvbbird kernel: TDA18271HD/C1 detected @ 4-00c0

For any sort of "not-really-cold" restarts second tuner fails to respond
correctly:
May 21 00:10:10 dvbbird kernel: DVB: registering new adapter (KWorld  PC160
(PEAK 221544AGPK) DVB-T PCI dual tuner)
May 21 00:10:11 dvbbird kernel: af9013: firmware version:4.95.0
May 21 00:10:11 dvbbird kernel: tda18271 3-00c0: creating new instance
May 21 00:10:11 dvbbird kernel: TDA18271HD/C1 detected @ 3-00c0
May 21 00:10:11 dvbbird kernel: dvb-usb: will pass the complete MPEG2
transportstream to the software demuxer.
May 21 00:10:11 dvbbird kernel: DVB: registering new adapter (KWorld  PC160
(PEAK 221544AGPK) DVB-T PCI dual tuner)
May 21 00:10:12 dvbbird kernel: af9013: firmware version:4.95.0
May 21 00:10:12 dvbbird kernel: tda18271 4-00c0: creating new instance
May 21 00:10:12 dvbbird kernel: Unknown device detected @ 4-00c0, device not
supported.
May 21 00:10:12 dvbbird kernel: tda18271 4-00c0: destroying instance

Hope this help.
Sergej.

------=_Part_2339_30726719.1212672408173
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Andrew,<br><br>PEAK DVB-T Dual tuner PCI (221544AGPK) is either renamed or rebadged KWorld DVB-T PC160 card.<br><br>I&#39;m using first tuner on this card with help of the driver from following source tree (snapshot was taken around 20/05/2008):<br>
<a href="http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/">http://linuxtv.org/hg/~anttip/af9015-mxl500x-copy-fw/</a><br>and latest firmware from<br><a href="http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/">http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/</a><br>
<br>Small modification for sources (file af9015.c) was needed (just add one more USB Device ID (1b80:c160)) and the card is &quot;just work&quot; as a single-tuner card.<br><br>I have not test second tuner due to following issue:<br>
&nbsp;<br>Second tuner identified itself correctly only after really &quot;cold restart&quot; (power down, wait some time, power up):<br>May 20 23:39:09 dvbbird kernel: DVB: registering new adapter (KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)<br>
May 20 23:39:10 dvbbird kernel: af9013: firmware version:4.95.0<br>May 20 23:39:10 dvbbird kernel: tda18271 3-00c0: creating new instance<br>May 20 23:39:10 dvbbird kernel: TDA18271HD/C1 detected @ 3-00c0<br>May 20 23:39:10 dvbbird kernel: dvb-usb: will pass the complete MPEG2 transportstream to the software demuxer.<br>
May 20 23:39:10 dvbbird kernel: DVB: registering new adapter (KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)<br>May 20 23:39:11 dvbbird kernel: af9013: firmware version:4.95.0<br>May 20 23:39:11 dvbbird kernel: tda18271 4-00c0: creating new instance<br>
May 20 23:39:11 dvbbird kernel: TDA18271HD/C1 detected @ 4-00c0<br><br>For any sort of &quot;not-really-cold&quot; restarts second tuner fails to respond correctly:<br>May 21 00:10:10 dvbbird kernel: DVB: registering new adapter (KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)<br>
May 21 00:10:11 dvbbird kernel: af9013: firmware version:4.95.0<br>May 21 00:10:11 dvbbird kernel: tda18271 3-00c0: creating new instance<br>May 21 00:10:11 dvbbird kernel: TDA18271HD/C1 detected @ 3-00c0<br>May 21 00:10:11 dvbbird kernel: dvb-usb: will pass the complete MPEG2 transportstream to the software demuxer.<br>
May 21 00:10:11 dvbbird kernel: DVB: registering new adapter (KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)<br>May 21 00:10:12 dvbbird kernel: af9013: firmware version:4.95.0<br>May 21 00:10:12 dvbbird kernel: tda18271 4-00c0: creating new instance<br>
May 21 00:10:12 dvbbird kernel: Unknown device detected @ 4-00c0, device not supported.<br>May 21 00:10:12 dvbbird kernel: tda18271 4-00c0: destroying instance<br><br>Hope this help.<br>Sergej.<br><br>

------=_Part_2339_30726719.1212672408173--


--===============1425138589==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1425138589==--
