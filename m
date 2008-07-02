Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <websdaleandrew@googlemail.com>) id 1KE0jX-00066T-6X
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 13:42:48 +0200
Received: by fk-out-0910.google.com with SMTP id f40so333854fka.1
	for <linux-dvb@linuxtv.org>; Wed, 02 Jul 2008 04:42:43 -0700 (PDT)
Message-ID: <e37d7f810807020442q13107177n5a90b11faf51194d@mail.gmail.com>
Date: Wed, 2 Jul 2008 12:42:42 +0100
From: "Andrew Websdale" <websdaleandrew@googlemail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Dposh DVB-T USB2.0(ULi M9207) initialising OK but no
	response from scan
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1553169831=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1553169831==
Content-Type: multipart/alternative;
	boundary="----=_Part_1308_20433267.1214998963137"

------=_Part_1308_20433267.1214998963137
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All,

I've been trying to amend the M920x driver to cope with the MT2060 tuner. My
dmesg output looks encouraging :
usb 5-1: new high speed USB device using ehci_hcd and address 5
usb 5-1: configuration #1 chosen from 1 choice
Probing for m920x device at interface 0
dvb-usb: found a 'Dposh(mt2060 tuner) DVB-T USB2.0' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Dposh(mt2060 tuner) DVB-T USB2.0)
m920x_mt352_frontend_attach
DVB: registering frontend 0 (Zarlink MT352 DVB-T)...
m920x_mt2060_tuner_attach
MT2060: successfully identified (IF1 = 1220)
dvb-usb: Dposh(mt2060 tuner) DVB-T USB2.0 successfully initialized and
connected.

but scanning produces no result. I thought it might be the firmware so I
used USBSnoop ( ver 2.0 from
here<http://www.pcausa.com/Utilities/UsbSnoop/SniffUSB-x86-2.0.0006.zip>
, I think its slightly easier to use than the original) and extracted a new
firmware file (attached) . The firmware loaded without complaint, but still
no scan result. I'm a bit stuck now, anyone got any suggestions as to how I
should proceed?

regards Andrew

------=_Part_1308_20433267.1214998963137
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All,<br><br>I&#39;ve been trying to amend the M920x driver to cope with the MT2060 tuner. My dmesg output looks encouraging :<br>usb 5-1: new high speed USB device using ehci_hcd and address 5<br>usb 5-1: configuration #1 chosen from 1 choice<br>
Probing for m920x device at interface 0<br>
dvb-usb: found a &#39;Dposh(mt2060 tuner) DVB-T USB2.0&#39; in warm state.<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>DVB: registering new adapter (Dposh(mt2060 tuner) DVB-T USB2.0)<br>

m920x_mt352_frontend_attach<br>DVB: registering frontend 0 (Zarlink MT352 DVB-T)...<br>m920x_mt2060_tuner_attach<br>MT2060: successfully identified (IF1 = 1220) <br>dvb-usb: Dposh(mt2060 tuner) DVB-T USB2.0 successfully initialized and connected.<br>
&nbsp;&nbsp;
<br>but scanning produces no result. I thought it might be the firmware so I used USBSnoop ( ver 2.0 from&nbsp;<a href="http://www.pcausa.com/Utilities/UsbSnoop/SniffUSB-x86-2.0.0006.zip">here</a>&nbsp; , I think its slightly easier to use than the original) and extracted a new firmware file (attached) . The firmware loaded without complaint, but still no scan result. I&#39;m a bit stuck now, anyone got any suggestions as to how I should proceed?<br>
<br>regards Andrew<br>

------=_Part_1308_20433267.1214998963137--


--===============1553169831==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1553169831==--
