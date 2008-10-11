Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <softnhard.es@gmail.com>) id 1KocjM-0004df-MH
	for linux-dvb@linuxtv.org; Sat, 11 Oct 2008 13:33:58 +0200
Received: by nf-out-0910.google.com with SMTP id g13so474507nfb.11
	for <linux-dvb@linuxtv.org>; Sat, 11 Oct 2008 04:33:52 -0700 (PDT)
Message-ID: <d2f7e03e0810110433y277c4410s874d0681abecfe37@mail.gmail.com>
Date: Sat, 11 Oct 2008 15:03:52 +0330
From: "Seyyed Mohammad mohammadzadeh" <softnhard.es@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] .:: Trouble with StarSat 2 ::.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0224286776=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0224286776==
Content-Type: multipart/alternative;
	boundary="----=_Part_14783_16485572.1223724832922"

------=_Part_14783_16485572.1223724832922
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have installed a StarSat2 DVB-S2 PCI card. on SuSE 11.0 with kernel
version equal to 2.6.25.16-0.1-pae. the system recognise the card as follow:

lspci -vv:
------------
03:02.0 Multimedia video controller: Trigem Computer Inc. Device 036f (rev
01)
        Subsystem: Device 0001:2004
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: I/O ports at 6000 [size=256]
        Kernel driver in use: dm1105
        Kernel modules: dm1105
======================

dmesg:
----------
DVB: registering new adapter (dm1105)
dm1105 0000:03:02.0: MAC 00:18:bd:00:6c:bb
DVB: registering frontend 0 (Conexant CX24116/CX24118)...
===========================================

but when i want to tune it I got DISEqC error:

linux-kluk:~ # dvbtune -f 11555 -p v -s 27500
Using DVB card "Conexant CX24116/CX24118", freq=11555
tuning DVB-S to Freq: 1805000, Pol:V Srate=27500000, 22kHz tone=off, LNB: 0
Setting only tone OFF and voltage 13V
DISEQC SETTING FAILED

I tested it with kaffeine and got this message:
Tuning to: algo / autocount: 1
DvbCam::probe(): /dev/dvb/adapter0/ca0: : No such file or directory
Using DVB device 0:0 "Conexant CX24116/CX24118"
tuning DVB-S to 11555000 v 27500000
inv:2 fecH:9
DiSEqC: switch pos 0, 13V, loband (index 0)
FE_SET_TONE failed: Connection timed out
DiSEqC: e0 10 38 f0 00 00
FE_DISEQC_SEND_MASTER_CMD failed: Connection timed out
FE_DISEQC_SEND_MASTER_CMD failed: Connection timed out
FE_SET_TONE failed: Connection timed out
. LOCKED.
NOUT: 1
dvbEvents 0:0 started
Tuning delay: 4243 ms
pipe opened
xine pipe opened /home/user/.kaxtv1.ts

But no video is played. Szap output seems to be fake because no data is
received on /dev/dvb/adapter0/dvr0:

zapping to 5 'Traffic':
sat 0, frequency = 11137 MHz V, symbolrate 30000000, vpid = 0x1fff, apid =
0x1fff sid = 0x03e8
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
FE_SET_TONE failed: Connection timed out
FE_DISEQC_SEND_MASTER_CMD failed: Connection timed out
FE_SET_TONE failed: Connection timed out
status 19 | signal  99% | snr  70% | ber 101940526 | unc 36167 | FE_HAS_LOCK
status 19 | signal  99% | snr  70% | ber 101940526 | unc 36167 | FE_HAS_LOCK
status 19 | signal  99% | snr  70% | ber 101940526 | unc 36167 | FE_HAS_LOCK
status 19 | signal  99% | snr  70% | ber 101940526 | unc 36167 | FE_HAS_LOCK
status 19 | signal  99% | snr  70% | ber 101940526 | unc 36167 | FE_HAS_LOCK

Anybody helps?

-- 
Best Regards
Mehran

Softnhard = Software & Hardware expert

------=_Part_14783_16485572.1223724832922
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br clear="all">I have installed a StarSat2 DVB-S2 PCI card. on SuSE 11.0 with kernel version equal to 2.6.25.16-0.1-pae. the system recognise the card as follow:<br><br>lspci -vv:<br>------------<br>03:02.0 Multimedia video controller: Trigem Computer Inc. Device 036f (rev 01)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: Device 0001:2004<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium &gt;TAbort- &lt;TAbort- &lt;MAbort- &gt;SERR- &lt;PERR- INTx-<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 32 bytes<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Interrupt: pin A routed to IRQ 22<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Region 0: I/O ports at 6000 [size=256]<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Kernel driver in use: dm1105<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Kernel modules: dm1105<br>
======================<br><br>dmesg:<br>----------<br>DVB: registering new adapter (dm1105)<br>dm1105 0000:03:02.0: MAC 00:18:bd:00:6c:bb<br>DVB: registering frontend 0 (Conexant CX24116/CX24118)...<br>===========================================<br>
<br>but when i want to tune it I got DISEqC error:<br><br>linux-kluk:~ # dvbtune -f 11555 -p v -s 27500<br>Using DVB card &quot;Conexant CX24116/CX24118&quot;, freq=11555<br>tuning DVB-S to Freq: 1805000, Pol:V Srate=27500000, 22kHz tone=off, LNB: 0<br>
Setting only tone OFF and voltage 13V<br>DISEQC SETTING FAILED<br><br>I tested it with kaffeine and got this message:<br>Tuning to: algo / autocount: 1<br>DvbCam::probe(): /dev/dvb/adapter0/ca0: : No such file or directory<br>
Using DVB device 0:0 &quot;Conexant CX24116/CX24118&quot;<br>tuning DVB-S to 11555000 v 27500000<br>inv:2 fecH:9<br>DiSEqC: switch pos 0, 13V, loband (index 0)<br>FE_SET_TONE failed: Connection timed out<br>DiSEqC: e0 10 38 f0 00 00<br>
FE_DISEQC_SEND_MASTER_CMD failed: Connection timed out<br>FE_DISEQC_SEND_MASTER_CMD failed: Connection timed out<br>FE_SET_TONE failed: Connection timed out<br>. LOCKED.<br>NOUT: 1<br>dvbEvents 0:0 started<br>Tuning delay: 4243 ms<br>
pipe opened<br>xine pipe opened /home/user/.kaxtv1.ts<br><br>But no video is played. Szap output seems to be fake because no data is received on /dev/dvb/adapter0/dvr0:<br><br>zapping to 5 &#39;Traffic&#39;:<br>sat 0, frequency = 11137 MHz V, symbolrate 30000000, vpid = 0x1fff, apid = 0x1fff sid = 0x03e8<br>
using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>FE_SET_TONE failed: Connection timed out<br>FE_DISEQC_SEND_MASTER_CMD failed: Connection timed out<br>FE_SET_TONE failed: Connection timed out<br>
status 19 | signal&nbsp; 99% | snr&nbsp; 70% | ber 101940526 | unc 36167 | FE_HAS_LOCK<br>status 19 | signal&nbsp; 99% | snr&nbsp; 70% | ber 101940526 | unc 36167 | FE_HAS_LOCK<br>status 19 | signal&nbsp; 99% | snr&nbsp; 70% | ber 101940526 | unc 36167 | FE_HAS_LOCK<br>
status 19 | signal&nbsp; 99% | snr&nbsp; 70% | ber 101940526 | unc 36167 | FE_HAS_LOCK<br>status 19 | signal&nbsp; 99% | snr&nbsp; 70% | ber 101940526 | unc 36167 | FE_HAS_LOCK<br><br>Anybody helps?<br><br>-- <br>Best Regards<br>Mehran<br><br>
Softnhard = Software &amp; Hardware expert<br>
</div>

------=_Part_14783_16485572.1223724832922--


--===============0224286776==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0224286776==--
