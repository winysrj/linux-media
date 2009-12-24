Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.17.10])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <peter@naiadhome.com>) id 1NNlO1-00059l-6d
	for linux-dvb@linuxtv.org; Thu, 24 Dec 2009 11:57:45 +0100
Message-ID: <4B334905.1000409@naiadhome.com>
Date: Thu, 24 Dec 2009 10:57:09 +0000
From: Peter <peter@naiadhome.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem tuning frequencyusing Nova S plus
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2028719069=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2028719069==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
</head>
<body bgcolor="#ffffff" text="#000000">
I am having a problem tuning to a couple of particular frequencies
using a Hauppauge Nova S Plus. There are two transponders very close in
frequency and neither of them will give a lock, while other
transponders from the same satellite lock just fine.<br>
<br>
The satellite is: Intelsat 10 (IS-10) (68.5E) - <br>
<br>
and the transponder I am interested in is: 3864.00 H - Txp: 4 - Beam: C
DVB-S (QPSK) - 19850 3/4 - NID:65535 - TID:1<br>
<br>
I can tune to transponders either side of this, but I fail to get a
lock when using dvbtune.<br>
<br>
root# dvbtune -f 3864000 -s 19850 -p h -c 3 -cr 3_4<br>
No CA device found, skipping<br>
Using DVB card "Conexant CX24123/CX24109"<br>
Using C-BAND parameters LOF=5150000<br>
tuning DVB-S to Freq: 1286000, Pol:H Srate=19850000, 22kHz tone=off,
LNB: 0<br>
Setting only tone OFF and voltage 18V<br>
DISEQC SETTING SUCCEDED<br>
polling....<br>
Getting frontend event<br>
FE_STATUS:<br>
polling....<br>
Getting frontend event<br>
FE_STATUS: FE_HAS_SIGNAL<br>
polling....<br>
polling....<br>
polling....<br>
<br>
---- give up<br>
<br>
Setting the debug=1 on the module I get this in dmesg:<br>
CX24123: cx24123_initfe: init frontend<br>
CX24123: cx24123_set_tone: setting tone off<br>
CX24123: cx24123_set_frontend:<br>
CX24123: cx24123_set_inversion: inversion auto<br>
CX24123: cx24123_set_fec: set FEC to auto<br>
CX24123: cx24123_set_symbolrate: srate=19850000, ratio=0x003ed29a,
sample_rate=40444000 sample_gain=1<br>
CX24123: cx24123_pll_tune: frequency=1286000<br>
CX24123: cx24123_pll_writereg: pll writereg called, data=0x00100e3f<br>
CX24123: cx24123_pll_writereg: pll writereg called, data=0x000a0180<br>
CX24123: cx24123_pll_writereg: pll writereg called, data=0x00000201<br>
CX24123: cx24123_pll_writereg: pll writereg called, data=0x001f84f7<br>
CX24123: cx24123_pll_tune: pll tune VCA=1052223, band=513, pll=2065655<br>
CX24123: cx24123_read_ber: BER = 0<br>
CX24123: cx24123_read_signal_strength: Signal strength = 64768<br>
CX24123: cx24123_read_snr: read S/N index = 64135<br>
CX24123: cx24123_read_ber: BER = 0<br>
CX24123: cx24123_read_signal_strength: Signal strength = 64768<br>
CX24123: cx24123_read_snr: read S/N index = 64197<br>
<br>
When I tune to a very close adjacent channel I also get a failure:<br>
<a class="bld">3863.00&nbsp;V</a> - Txp: <a class="bld"
 href="http://en.kingofsat.net/tp.php?tp=2797">15</a> - Beam: <a
 class="bld" href="http://en.kingofsat.net/beams.php?s=42&amp;b=170">C</a>DVB-S
(QPSK) - <a class="bld">20600</a> <a class="bld">3/4</a> - NID:6144 -
TID:9<br>
<br>
which is only 1 MHz different from the transponder I am interested in,
though on a different polarity.<br>
<br>
When I tune to an channel some way off I get a lock, for example: <br>
dvbtune -f 3836000 -s 20600 -p v -c 3 -cr 3_4<br>
No CA device found, skipping<br>
Using DVB card "Conexant CX24123/CX24109"<br>
Using C-BAND parameters LOF=5150000<br>
tuning DVB-S to Freq: 1314000, Pol:V Srate=20600000, 22kHz tone=off,
LNB: 0<br>
Setting only tone OFF and voltage 13V<br>
DISEQC SETTING SUCCEDED<br>
polling....<br>
Getting frontend event<br>
FE_STATUS:<br>
polling....<br>
Getting frontend event<br>
FE_STATUS: FE_HAS_SIGNAL<br>
polling....<br>
Getting frontend event<br>
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
FE_HAS_SYNC<br>
Event:&nbsp; Frequency: 11064000<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SymbolRate: 20600000<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FEC_inner:&nbsp; 3<br>
<br>
Bit error rate: 0<br>
Signal strength: 62464<br>
SNR: 65252<br>
FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
FE_HAS_SYNC<br>
<br>
I was wondering if anyone had come across a similar problem? I am
speculating, but maybe this is interference from an adjacent channel
since other channels with wider spacing always work. Interestingly a
commercial satellite STB can tune to this transponder without errors,
so this does indicate a driver releated buglet.<br>
<br>
Are there any cx24123 parameters that could be tweaked to help here, or
maybe this is a tuner problem?<br>
<br>
Could anyone provide me with the data sheets for the demod and tuner
for these cards? I would be happy to dig into this a bit deeper.<br>
<br>
Regards<br>
<br>
Pete<br>
<br>
<br>
<br>
<br>
</body>
</html>


--===============2028719069==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2028719069==--
