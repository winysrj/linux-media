Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.175])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mandm.thompson@gmail.com>) id 1JRMeH-0007eR-TJ
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 08:12:18 +0100
Received: by wf-out-1314.google.com with SMTP id 28so460549wfa.17
	for <linux-dvb@linuxtv.org>; Mon, 18 Feb 2008 23:12:13 -0800 (PST)
Message-ID: <9e5f3ed00802182312k7949dc95veb468f1ffb641ba0@mail.gmail.com>
Date: Tue, 19 Feb 2008 18:12:13 +1100
From: "Martin Thompson" <mandm.thompson@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] NEW version of dvico digital dual 4
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2111244512=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2111244512==
Content-Type: multipart/alternative;
	boundary="----=_Part_11673_13334613.1203405133300"

------=_Part_11673_13334613.1203405133300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

sorry if this has been posted a few times not getting anything back from
list
just bought a new dvico dd4 card
it has a revision 2.0 stamped on it
it is not picked up by mythtv
in the usb driver id the card is ID 0fe9:db*78* DVICO  ID 0fe9:db*78* DVICO
mi id on new card is ID 0fe9:db*98* DVICOso i changed the id to 98
linux picked it up as a dvico dd4 dvb card with two tuners
now mythtv finds the card but no frontend
i think they have changed that as well

dmesg | grep dvb-usb
[ 45.568438] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in
warm state.
[ 45.568759] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[ 45.676871] dvb-usb: no frontend was attached by 'DViCO FusionHDTV DVB-T
Dual Digital 4'
[ 45.677733] dvb-usb: schedule remote query interval to 100 msecs.
[ 45.677855] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully
initialized and connected.
[ 45.677872] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in
warm state.
[ 45.678261] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[ 46.003003] dvb-usb: no frontend was attached by 'DViCO FusionHDTV DVB-T
Dual Digital 4'
[ 46.003591] dvb-usb: schedule remote query interval to 100 msecs.
[ 46.003900] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully
initialized and connected.

lsusb
-snip-
Bus 002 Device 003: ID 0fe9:db98 DVICO
Bus 002 Device 002: ID 0fe9:db98 DVICO

lspci
-snip-
05:06.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB
1.1Controller (rev 62)
05:06.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB
1.1Controller (rev 62)
05:06.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65)
05:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder (rev 05)
05:07.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio
Decoder [MPEG Port] (rev 05)
05:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
05:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture
(rev 11)

card is back in xp box for recording i can run a protocol program to find
the id
just need to know what to use

hope you can help

------=_Part_11673_13334613.1203405133300
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

sorry if this has been posted a few times not getting anything back from list<br><div><font><font face="Arial" size="2">
<div><font face="Arial" size="2">just bought a new dvico dd4 card</font></div>
<div><font face="Arial" size="2">it has a revision 2.0 stamped on it</font></div>
<div><font face="Arial" size="2">it is not picked up by mythtv</font></div>
<div><font face="Arial" size="2">in the usb driver id the card is <span class="wcrep2"><font face="Times New Roman" size="3">ID 0fe9:db<b>78</b> DVICO &nbsp;ID 
0fe9:db<b>78</b> DVICO</font></span></font></div></font></font><font><font face="Arial" size="2"><font face="Arial" size="2"><span class="wcrep2"><font face="Times New Roman" size="3">mi id on new card is ID 
0fe9:db<b>98</b> DVICO</font></span></font></font></font><font><font face="Arial" size="2"><div><font size="-0"><span class="wcrep2">so i changed the id to 
98</span></font></div>
<div><font size="-0"><span class="wcrep2">linux picked it up as a dvico dd4 dvb card 
with two tuners</span></font></div>
<div><font size="-0"><span class="wcrep2">now mythtv finds the card but no 
frontend</span></font></div>
<div><font size="-0"><span class="wcrep2">i think they have changed that as 
well</span></font></div>
<div><font size="-0"><span class="wcrep2"></span></font>&nbsp;</div>
<div><font size="-0"><span class="wcrep2">dmesg | grep dvb-usb<br>[ 45.568438] 
dvb-usb: found a &#39;DViCO FusionHDTV DVB-T Dual Digital 4&#39; in warm state.<br>[ 
45.568759] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.<br>[ 45.676871] dvb-usb: no frontend was attached by &#39;DViCO 
FusionHDTV DVB-T Dual Digital 4&#39;<br>[ 45.677733] dvb-usb: schedule remote query 
interval to 100 msecs.<br>[ 45.677855] dvb-usb: DViCO FusionHDTV DVB-T Dual 
Digital 4 successfully initialized and connected.<br>[ 45.677872] dvb-usb: found 
a &#39;DViCO FusionHDTV DVB-T Dual Digital 4&#39; in warm state.<br>[ 45.678261] 
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.<br>[ 46.003003] dvb-usb: no frontend was attached by &#39;DViCO FusionHDTV 
DVB-T Dual Digital 4&#39;<br>[ 46.003591] dvb-usb: schedule remote query interval to 
100 msecs.<br>[ 46.003900] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 
successfully initialized and connected.</span></font></div>
<div><font size="-0"><span class="wcrep2"></span></font>&nbsp;</div>
<div><font size="-0"><span class="wcrep2">lsusb<br>-snip-<br>Bus 002 Device 003: ID 
0fe9:db98 DVICO<br>Bus 002 Device 002: ID 0fe9:db98 
DVICO<br><br>lspci<br>-snip-<br>05:06.0 USB Controller: VIA Technologies, Inc. 
VT82xxxxx UHCI USB 1.1 Controller (rev 62)<br>05:06.1 USB Controller: VIA 
Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 62)<br>05:06.2 USB 
Controller: VIA Technologies, Inc. USB 2.0 (rev 65)<br>05:07.0 Multimedia video 
controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 
05)<br>05:07.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio 
Decoder [MPEG Port] (rev 05)<br>05:08.0 Multimedia video controller: Brooktree 
Corporation Bt878 Video Capture (rev 11)<br>05:08.1 Multimedia controller: 
Brooktree Corporation Bt878 Audio Capture (rev 
11)<br><br>card is back in xp box for recording i can run a protocol program to find the id<br>just need to know what to use<br><br>hope you can help<br></span></font></div></font></font></div><br><br>

------=_Part_11673_13334613.1203405133300--


--===============2111244512==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2111244512==--
