Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.s.hodgson@gmail.com>) id 1JyLSl-0002Ss-VU
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 08:36:45 +0200
Received: by ti-out-0910.google.com with SMTP id w7so1238845tib.13
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 23:36:36 -0700 (PDT)
Message-ID: <d65b37b10805192336y2b9a899etf0e15019bfe54a5b@mail.gmail.com>
Date: Tue, 20 May 2008 16:36:36 +1000
From: "Andrew Hodgson" <a.s.hodgson@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] asus my media U3000 mini & ubuntu 7.10
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1650754407=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1650754407==
Content-Type: multipart/alternative;
	boundary="----=_Part_1022_18747696.1211265396321"

------=_Part_1022_18747696.1211265396321
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I know I must be doing something stupid but I just cant work out what. Any
help would be greatfully appreciated

I recently bought a asus my media U3000 mini as the docs said it was
supported.

I plugged it into my ubuntu 7.10 box running  2.6.22-14-generic.

It was not recognized.

I read on the net that the support was fairly new so I downloaded, built and
installed the latest v4l-dvb.

I then rebooted and it was recognized
---------
[ 1260.114059] usb 4-2: new high speed USB device using ehci_hcd and address
3
[ 1260.246814] usb 4-2: configuration #1 chosen from 1 choice
[ 1260.247200] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' in
cold state, will try to load a firmware
[ 1260.337936] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.10.fw'
[ 1260.536244] dib0700: firmware started successfully.
[ 1261.036644] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner' in
warm state.
[ 1261.036699] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[ 1261.036926] DVB: registering new adapter (ASUS My Cinema U3000 Mini DVBT
Tuner)
[ 1261.249263] DVB: registering frontend 5 (DiBcom 7000PC)...
[ 1261.401772] MT2266: successfully identified
[ 1261.558527] dvb-usb: ASUS My Cinema U3000 Mini DVBT Tuner successfully
initialized and connected.
--------

I tested tuning and it worked perfectly (I was very happy at that stage)

--------
ash-fs# tzap -a 5 nine
using '/dev/dvb/adapter5/frontend0' and '/dev/dvb/adapter5/demux0'
reading channels from file '/root/.tzap/channels.conf'
tuning to 191625000 Hz
video pid 0x0207, audio pid 0x02d0
status 1f | signal b176 | snr 0000 | ber 001fffff | unc 00000006 |
FE_HAS_LOCK
status 1f | signal b0b0 | snr 0000 | ber 00004950 | unc 00000006 |
FE_HAS_LOCK
status 1f | signal b04d | snr 0000 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
-------

However, when I tried to record (open /dev/dvb/adapter5/dvr0 I get

ERROR: failed opening '/dev/dvb/adapter5/dvr0' (Cannot allocate memory)
and dmesg has

[ 1472.071782] allocation failed: out of vmalloc space - use vmalloc=<size>
to increase size.

As you can see from the above I already have 5 dvb tuners working perfectly
(mostly pci). I bought this new one to setup a DVR box for a friend.

Is the problem because I am trying to have 6 dvb-t tuners ?

Thanks in advance

Andrew

------=_Part_1022_18747696.1211265396321
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I know I must be doing something stupid but I just cant work out what. Any help would be greatfully appreciated<br><br>I recently bought a asus my media U3000 mini as the docs said it was supported.<br><br>I plugged it into my ubuntu 7.10 box running&nbsp; 2.6.22-14-generic.<br>
<br>It was not recognized.<br><br>I read on the net that the support was fairly new so I downloaded, built and installed the latest v4l-dvb.<br><br>I then rebooted and it was recognized<br>---------<br>[ 1260.114059] usb 4-2: new high speed USB device using ehci_hcd and address 3<br>
[ 1260.246814] usb 4-2: configuration #1 chosen from 1 choice<br>[ 1260.247200] dvb-usb: found a &#39;ASUS My Cinema U3000 Mini DVBT Tuner&#39; in cold state, will try to load a firmware<br>[ 1260.337936] dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700-1.10.fw&#39;<br>
[ 1260.536244] dib0700: firmware started successfully.<br>[ 1261.036644] dvb-usb: found a &#39;ASUS My Cinema U3000 Mini DVBT Tuner&#39; in warm state.<br>[ 1261.036699] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>
[ 1261.036926] DVB: registering new adapter (ASUS My Cinema U3000 Mini DVBT Tuner)<br>[ 1261.249263] DVB: registering frontend 5 (DiBcom 7000PC)...<br>[ 1261.401772] MT2266: successfully identified<br>[ 1261.558527] dvb-usb: ASUS My Cinema U3000 Mini DVBT Tuner successfully initialized and connected.<br>
--------<br><br>I tested tuning and it worked perfectly (I was very happy at that stage)<br><br>--------<br>ash-fs# tzap -a 5 nine<br>using &#39;/dev/dvb/adapter5/frontend0&#39; and &#39;/dev/dvb/adapter5/demux0&#39;<br>reading channels from file &#39;/root/.tzap/channels.conf&#39;<br>
tuning to 191625000 Hz<br>video pid 0x0207, audio pid 0x02d0<br>status 1f | signal b176 | snr 0000 | ber 001fffff | unc 00000006 | FE_HAS_LOCK<br>status 1f | signal b0b0 | snr 0000 | ber 00004950 | unc 00000006 | FE_HAS_LOCK<br>
status 1f | signal b04d | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK<br>-------<br><br>However, when I tried to record (open /dev/dvb/adapter5/dvr0 I get <br><br>ERROR: failed opening &#39;/dev/dvb/adapter5/dvr0&#39; (Cannot allocate memory)<br>
and dmesg has<br><br>[ 1472.071782] allocation failed: out of vmalloc space - use vmalloc=&lt;size&gt; to increase size.<br><br>As you can see from the above I already have 5 dvb tuners working perfectly (mostly pci). I bought this new one to setup a DVR box for a friend.<br>
<br>Is the problem because I am trying to have 6 dvb-t tuners ?<br><br>Thanks in advance<br><br>Andrew<br><br><br><br><br><br>

------=_Part_1022_18747696.1211265396321--


--===============1650754407==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1650754407==--
