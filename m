Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.237])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <subhra85@gmail.com>) id 1KI0uS-0004nS-89
	for linux-dvb@linuxtv.org; Sun, 13 Jul 2008 14:42:38 +0200
Received: by rv-out-0506.google.com with SMTP id b25so5355371rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 13 Jul 2008 05:42:31 -0700 (PDT)
Message-ID: <35fa40850807130542y6ffb55c6t1f3e93ba8f40b7e7@mail.gmail.com>
Date: Sun, 13 Jul 2008 18:12:31 +0530
From: "SUBHRANIL CHOUDHURY" <subhra85@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Scan issues on Pinnacle 2001e DAUL Diversity Stick
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0216593973=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0216593973==
Content-Type: multipart/alternative;
	boundary="----=_Part_31096_7194001.1215952951699"

------=_Part_31096_7194001.1215952951699
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

hi,

I am working on DVB-T for the first time. I am using a Pinnacle PCTV 2001e
USB DVB-T dongle.In that the device dri vers are getting registered and the
device is getting detected.I am using a 2.6.23.15 kernel.

The dmesg is as follows:

dvb-usb: Pinnacle PCTV Dual DVB-T Diversity Stick successfully deinitialized
and disconnected.
usb 1-1.4: new high speed USB device using musb_hdrc and address 4
usb 1-1.4: Product: PCTV 2001e
usb 1-1.4: Manufacturer: PINNACLE
usb 1-1.4: SerialNumber: 12020607
usb 1-1.4: configuration #1 chosen from 1 choice

dvb-usb: found a 'Pinnacle PCTV Dual DVB-T Diversity Stick' in cold state,
will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Pinnacle PCTV Dual DVB-T Diversity Stick' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)
DVB: registering frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)
DVB: registering frontend 1 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: Pinnacle PCTV Dual DVB-T Diversity Stick successfully initialized
and connected.

But, after that when i am trying to run any scan application , it is showing
"scan failed".

the dmesg after running scan application is,

APPLN INFO >> Inside scan_network
APPLN INFO >> Inside tune_initial
Inside alloc_transponder
initial transponder 474166000 0 2 9 3 1 0 0
Inside alloc_transponder
initial transponder 498166000 0 2 9 3 1 0 0
Inside alloc_transponder
initial transponder 522166000 0 2 9 3 1 0 0
Inside alloc_transponder
initial transponder 538166000 0 2 9 3 1 0 0
Inside alloc_transponder
initial transponder 562166000 0 2 9 3 1 0 0
Inside alloc_transponder
initial transponder 586166000 0 3 9 3 1 2 0
Inside alloc_transponder
initial transponder 714166000 0 2 9 3 1 0 0
Inside alloc_transponder
initial transponder 738166000 0 2 9 3 1 0 0
Inside alloc_transponder
initial transponder 754166000 0 2 9 3 1 0 0
Inside alloc_transponder
initial transponder 762166000 0 2 9 3 1 0 0
Inside alloc_transponder
initial transponder 786166000 0 2 9 3 1 0 0
Inside alloc_transponder
initial transponder 810166000 0 2 9 3 1 0 0
Inside tune_to_next_transponder()
Inside tune_to_transponder()
APPLN INFO >> Entered __tune_to_transponder()
>>> tune to:
474166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
APPLN INFO >> Entered __tune_to_transponder()
>>> tune to:
474166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
Inside tune_to_transponder()

etc, etc.

Can Anyone Please tell me if you have faced a similar problem or what is
happening ?
Do i have to add something to the kernel?

Best regards,
subhro

------=_Part_31096_7194001.1215952951699
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<p>hi, </p>
<p>I am working on DVB-T for the first time. I am using a Pinnacle PCTV 2001e USB DVB-T dongle.In that the device dri vers are getting registered and the device is getting detected.I am using a <a href="http://2.6.23.15">2.6.23.15</a> kernel.<br>
&nbsp;<br>The dmesg is as follows:<br>&nbsp;<br>dvb-usb: Pinnacle PCTV Dual DVB-T Diversity Stick successfully deinitialized and disconnected.<br>usb 1-1.4: new high speed USB device using musb_hdrc and address 4<br>usb 1-1.4: Product: PCTV 2001e<br>
usb 1-1.4: Manufacturer: PINNACLE<br>usb 1-1.4: SerialNumber: 12020607<br>usb 1-1.4: configuration #1 chosen from 1 choice</p>
<p>dvb-usb: found a &#39;Pinnacle PCTV Dual DVB-T Diversity Stick&#39; in cold state, will try to load a firmware<br>dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700-1.10.fw&#39;<br>dib0700: firmware started successfully.<br>
dvb-usb: found a &#39;Pinnacle PCTV Dual DVB-T Diversity Stick&#39; in warm state.<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)<br>
DVB: registering frontend 0 (DiBcom 7000PC)...<br>DiB0070: successfully identified<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)<br>
DVB: registering frontend 1 (DiBcom 7000PC)...<br>DiB0070: successfully identified<br>dvb-usb: Pinnacle PCTV Dual DVB-T Diversity Stick successfully initialized and connected.<br>&nbsp;<br>But, after that when i am trying to run any scan application , it is showing &quot;scan failed&quot;.<br>
&nbsp;<br>the dmesg after running scan application is,<br>&nbsp;<br>APPLN INFO &gt;&gt; Inside scan_network<br>APPLN INFO &gt;&gt; Inside tune_initial<br>Inside alloc_transponder<br>initial transponder 474166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>
initial transponder 498166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 522166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 538166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>
initial transponder 562166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 586166000 0 3 9 3 1 2 0<br>Inside alloc_transponder<br>initial transponder 714166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>
initial transponder 738166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 754166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 762166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>
initial transponder 786166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 810166000 0 2 9 3 1 0 0<br>Inside tune_to_next_transponder()<br>Inside tune_to_transponder()<br>APPLN INFO &gt;&gt; Entered __tune_to_transponder()<br>
&gt;&gt;&gt; tune to: 474166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE<br>WARNING: &gt;&gt;&gt; tuning failed!!!<br>APPLN INFO &gt;&gt; Entered __tune_to_transponder()<br>
&gt;&gt;&gt; tune to: 474166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)<br>WARNING: &gt;&gt;&gt; tuning failed!!!<br>Inside tune_to_transponder()</p>

<p>etc, etc.<br>&nbsp;<br>Can Anyone Please tell me if you have faced a similar problem or what is happening ?<br>Do i have to add something to the kernel?<br>&nbsp;<br>Best regards,<br>subhro</p>

------=_Part_31096_7194001.1215952951699--


--===============0216593973==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0216593973==--
