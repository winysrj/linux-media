Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <websdaleandrew@googlemail.com>) id 1K6BiU-0005X9-Eb
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 23:49:23 +0200
Received: by fk-out-0910.google.com with SMTP id f40so1724640fka.1
	for <linux-dvb@linuxtv.org>; Tue, 10 Jun 2008 14:49:18 -0700 (PDT)
Message-ID: <e37d7f810806101449l1302da8cj12da36142cc989d1@mail.gmail.com>
Date: Tue, 10 Jun 2008 22:49:18 +0100
From: "Andrew Websdale" <websdaleandrew@googlemail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1688850004=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1688850004==
Content-Type: multipart/alternative;
	boundary="----=_Part_12256_32364542.1213134558508"

------=_Part_12256_32364542.1213134558508
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I've got a Dposh DVB-T USB2.0 (marked ATMT) and I've downloaded some
firmware ( which was v.difficult to find as the page in the wiki is blank)
which put the stick into a "warm" state i.e.

dvb-usb: found a 'Dposh DVB-T USB2.0' in cold state, will try to load a
firmware
dvb-usb: downloading firmware from file 'dvb-usb-dposh-01.fw'
dvb_usb_m920x: probe of 5-1:1.0 failed with error 64
dvb-usb: found a 'Dposh DVB-T USB2.0' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
dvb-usb: Dposh DVB-T USB2.0 successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_m920x

I've tried Kaffeine and w_scan to no avail, (WinXP gets a signal), I could
do with some advice on a)perhaps new firmware and b)help with how to use
dvbsnoop or similar to divine what is happening with this device as I lack
sufficient knowledge to proceed
Regards Andrew

------=_Part_12256_32364542.1213134558508
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I&#39;ve got a Dposh DVB-T USB2.0 (marked ATMT) and I&#39;ve downloaded some firmware ( which was v.difficult to find as the page in the wiki is blank) which put the stick into a &quot;warm&quot; state i.e.<br><br>dvb-usb: found a &#39;Dposh DVB-T USB2.0&#39; in cold state, will try to load a firmware<br>
dvb-usb: downloading firmware from file &#39;dvb-usb-dposh-01.fw&#39;<br>dvb_usb_m920x: probe of 5-1:1.0 failed with error 64<br>dvb-usb: found a &#39;Dposh DVB-T USB2.0&#39; in warm state.<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>
dvb-usb: Dposh DVB-T USB2.0 successfully initialized and connected.<br>usbcore: registered new interface driver dvb_usb_m920x<br><br>I&#39;ve tried Kaffeine and w_scan to no avail, (WinXP gets a signal), I could do with some advice on a)perhaps new firmware and b)help with how to use dvbsnoop or similar to divine what is happening with this device as I lack sufficient knowledge to proceed<br>
Regards Andrew<br><br>

------=_Part_12256_32364542.1213134558508--


--===============1688850004==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1688850004==--
