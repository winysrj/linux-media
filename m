Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.226])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <subhra85@gmail.com>) id 1KI0P0-0002Bx-1W
	for linux-dvb@linuxtv.org; Sun, 13 Jul 2008 14:10:07 +0200
Received: by rv-out-0506.google.com with SMTP id b25so5347707rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 13 Jul 2008 05:09:58 -0700 (PDT)
Message-ID: <35fa40850807130509q120d6878geb050d7e1cb29644@mail.gmail.com>
Date: Sun, 13 Jul 2008 17:39:58 +0530
From: "SUBHRANIL CHOUDHURY" <subhra85@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <20080712200627.2412f240@chicken.squirrel.local>
MIME-Version: 1.0
References: <20080712200627.2412f240@chicken.squirrel.local>
Subject: Re: [linux-dvb] Pinnacle PCTV Dual DVB-T Diversity Stick built in
	IR-Receiver supported ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0327676379=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0327676379==
Content-Type: multipart/alternative;
	boundary="----=_Part_31001_5700788.1215950998539"

------=_Part_31001_5700788.1215950998539
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
___________________________________________________________________________________________________________________
On Sat, Jul 12, 2008 at 11:36 PM, Ingo Arndt <scachi@gmx.de> wrote:

> Hello,
>
> as I haven't received any answer yet I'll post my question again,
>
> I have a Pinnacle PCTV Dual DVB-T Diversity Stick which works fine.
> The only thing I am missing is the built-in infrared receiver which is not
> recognized.
>
> Is anyone using this Pinnacle DVB-T stick and got it's remote control
> working ?
>
> Am I missing a module, a module option or something else
> or is the ir receiver just not supported by now ?
>
> I use the kernel 2.6.25 with tuxonice-patches on archlinux.
>
> lsusb output:
> ------------------------- lsusb output start ---
> idVendor           0x2304 Pinnacle Systems, Inc. [hex]
>  idProduct          0x0229
>  bcdDevice            0.01
>  iManufacturer           1 PINNACLE
>  iProduct                2 PCTV 2001e
>  iSerial                 3 12027630
> ------------------------- lsusb output stop ---
>
>
> mesg output:
> ---------------- dmesg code start ---
> usb 7-3: new high speed USB device using ehci_hcd and address 9
> usb 7-3: configuration #1 chosen from 1 choice
> dvb-usb: found a 'Pinnacle PCTV Dual DVB-T Diversity Stick' in cold state,
> will try to load a firmware
> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
> dib0700: firmware started successfully.
> dvb-usb: found a 'Pinnacle PCTV Dual DVB-T Diversity Stick' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)
> DVB: registering frontend 0 (DiBcom 7000PC)...
> DiB0070: successfully identified
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)
> DVB: registering frontend 1 (DiBcom 7000PC)...
> DiB0070: successfully identified
> dvb-usb: Pinnacle PCTV Dual DVB-T Diversity Stick successfully
> initialized and connected.
> ----------------- dmesg code end ---
>
>
> Best regards,
>  Ingo
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_31001_5700788.1215950998539
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div>hi, </div>
<div><br>I am working on DVB-T for the first time. I am using a Pinnacle PCTV 2001e USB DVB-T dongle.In that the device dri vers are getting registered and the device is getting detected.I am using a <a href="http://2.6.23.15">2.6.23.15</a> kernel.</div>

<div>&nbsp;</div>
<div>The dmesg is as follows:</div>
<div>&nbsp;</div>
<div>dvb-usb: Pinnacle PCTV Dual DVB-T Diversity Stick successfully deinitialized and disconnected.<br>usb 1-1.4: new high speed USB device using musb_hdrc and address 4<br>usb 1-1.4: Product: PCTV 2001e<br>usb 1-1.4: Manufacturer: PINNACLE<br>
usb 1-1.4: SerialNumber: 12020607<br>usb 1-1.4: configuration #1 chosen from 1 choice<br>dvb-usb: found a &#39;Pinnacle PCTV Dual DVB-T Diversity Stick&#39; in cold state, will try to load a firmware<br>dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700-1.10.fw&#39;<br>
dib0700: firmware started successfully.<br>dvb-usb: found a &#39;Pinnacle PCTV Dual DVB-T Diversity Stick&#39; in warm state.<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)<br>
DVB: registering frontend 0 (DiBcom 7000PC)...<br>DiB0070: successfully identified<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)<br>
DVB: registering frontend 1 (DiBcom 7000PC)...<br>DiB0070: successfully identified<br>dvb-usb: Pinnacle PCTV Dual DVB-T Diversity Stick successfully initialized and connected.</div>
<div>&nbsp;</div>
<div>But, after that when i am trying to run any scan application , it is showing &quot;scan failed&quot;.</div>
<div>&nbsp;</div>
<div>the dmesg after running scan application is,</div>
<div>&nbsp;</div>
<div><span style="FONT-SIZE: 8pt; FONT-FAMILY: &#39;Times New Roman&#39;,&#39;serif&#39;; mso-fareast-font-family: Calibri; mso-ansi-language: EN-US; mso-fareast-language: FR; mso-bidi-language: AR-SA">APPLN INFO &gt;&gt; Inside scan_network<br>
APPLN INFO &gt;&gt; Inside tune_initial<br>Inside alloc_transponder<br>initial transponder 474166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 498166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>
initial transponder 522166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 538166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 562166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>
initial transponder 586166000 0 3 9 3 1 2 0<br>Inside alloc_transponder<br>initial transponder 714166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 738166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>
initial transponder 754166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 762166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>initial transponder 786166000 0 2 9 3 1 0 0<br>Inside alloc_transponder<br>
initial transponder 810166000 0 2 9 3 1 0 0<br>Inside tune_to_next_transponder()<br>Inside tune_to_transponder()<br>APPLN INFO &gt;&gt; Entered __tune_to_transponder()<br>&gt;&gt;&gt; tune to: 474166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>APPLN INFO &gt;&gt; Entered __tune_to_transponder()<br>&gt;&gt;&gt; tune to: 474166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>Inside tune_to_transponder()<br style="mso-special-character: line-break"><br style="mso-special-character: line-break"></span>etc, etc.</div>
<div>&nbsp;</div>
<div>Can Anyone Please tell me if you have faced a similar problem or what is happening ?</div>
<div>Do i have to add something to the kernel?</div>
<div>&nbsp;</div>
<div>Best regards,</div>
<div>subhro<br>___________________________________________________________________________________________________________________</div>
<div class="gmail_quote">On Sat, Jul 12, 2008 at 11:36 PM, Ingo Arndt &lt;<a href="mailto:scachi@gmx.de">scachi@gmx.de</a>&gt; wrote:<br>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Hello,<br><br>as I haven&#39;t received any answer yet I&#39;ll post my question again,<br><br>I have a Pinnacle PCTV Dual DVB-T Diversity Stick which works fine.<br>
The only thing I am missing is the built-in infrared receiver which is not recognized.<br><br>Is anyone using this Pinnacle DVB-T stick and got it&#39;s remote control working ?<br><br>Am I missing a module, a module option or something else<br>
or is the ir receiver just not supported by now ?<br><br>I use the kernel 2.6.25 with tuxonice-patches on archlinux.<br><br>lsusb output:<br>------------------------- lsusb output start ---<br>idVendor &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0x2304 Pinnacle Systems, Inc. [hex]<br>
&nbsp;idProduct &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0x0229<br>&nbsp;bcdDevice &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0.01<br>&nbsp;iManufacturer &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1 PINNACLE<br>&nbsp;iProduct &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;2 PCTV 2001e<br>&nbsp;iSerial &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3 12027630<br>------------------------- lsusb output stop ---<br>
<br><br>mesg output:<br>---------------- dmesg code start ---<br>usb 7-3: new high speed USB device using ehci_hcd and address 9<br>usb 7-3: configuration #1 chosen from 1 choice<br>dvb-usb: found a &#39;Pinnacle PCTV Dual DVB-T Diversity Stick&#39; in cold state, will try to load a firmware<br>
dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700-1.10.fw&#39;<br>dib0700: firmware started successfully.<br>dvb-usb: found a &#39;Pinnacle PCTV Dual DVB-T Diversity Stick&#39; in warm state.<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>
DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)<br>DVB: registering frontend 0 (DiBcom 7000PC)...<br>DiB0070: successfully identified<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>
DVB: registering new adapter (Pinnacle PCTV Dual DVB-T Diversity Stick)<br>DVB: registering frontend 1 (DiBcom 7000PC)...<br>DiB0070: successfully identified<br>dvb-usb: Pinnacle PCTV Dual DVB-T Diversity Stick successfully<br>
initialized and connected.<br>----------------- dmesg code end ---<br><br><br>Best regards,<br>&nbsp;Ingo<br><br>_______________________________________________<br>linux-dvb mailing list<br><a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote></div><br>

------=_Part_31001_5700788.1215950998539--


--===============0327676379==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0327676379==--
