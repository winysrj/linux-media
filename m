Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpauth01.csee.siteprotect.eu ([83.246.86.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roger@beardandsandals.co.uk>) id 1Ka9cz-000821-L9
	for linux-dvb@linuxtv.org; Mon, 01 Sep 2008 15:39:33 +0200
Received: from [192.168.10.241] (unknown [81.168.109.249])
	(Authenticated sender: roger@beardandsandals.co.uk)
	by smtpauth01.csee.siteprotect.eu (Postfix) with ESMTP id F26C66C00D
	for <linux-dvb@linuxtv.org>; Mon,  1 Sep 2008 15:38:58 +0200 (CEST)
Message-ID: <48BBF072.3070807@beardandsandals.co.uk>
Date: Mon, 01 Sep 2008 14:38:58 +0100
From: Roger James <roger@beardandsandals.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Binary compatibility TT-3200
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1786330936=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1786330936==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
I am trying to test an encrypted stream via a TT-3200 using the
multiproto drivers. The patched scan szap works fine and I can get a
lock. However I need to test with something that activates the CAM. So
I tried gnutv. Gnutv uses dvb-apps/lib so it is not patched for
multiproto and uses the FE_SET_FRONTEND ioctl.<br>
<br>
My understanding from Manu's comments about binary compatibility where
that this should work. I am wrong in this assumption? Anyway it does
not work and never reports a lock.<br>
<br>
roger@myth:~$ gnutv -channels satchannels.conf "BBC 1 London"<br>
Cannot open decoder; defaulting to dvr output<br>
Using frontend "STB0899 Multistandard", type DVB-S<br>
CAM Application type: 0100 | snr 0000 | ber 00000000 | unc 00000000 |<br>
CAM Application manufacturer: 4a70<br>
CAM Manufacturer code: 4a70<br>
CAM Menu string: PRED 3.66<br>
CAM supports the following ca system ids:<br>
&nbsp; 0x0100<br>
&nbsp; 0x0500<br>
&nbsp; 0x1702<br>
&nbsp; 0x0b00<br>
&nbsp; 0x4a70<br>
&nbsp; 0x0d22<br>
&nbsp; 0x0d03<br>
&nbsp; 0x1801<br>
&nbsp; 0x1762<br>
&nbsp; 0x1800<br>
&nbsp; 0x2600<br>
&nbsp; 0x0d01<br>
&nbsp; 0x0d00<br>
&nbsp; 0x0961<br>
&nbsp; 0x0d05<br>
&nbsp; 0x0604<br>
roger@myth:~$&nbsp;&nbsp;&nbsp;&nbsp; nal 0000 | snr 0000 | ber 00000000 | unc 00000000 |<br>
<br>
Here is the dmesg (I have killed the frontend zigzag diagnostics for
clarity)<br>
<br>
dvb_frontend_open<br>
dvb_frontend_start<br>
dvb_frontend_thread<br>
DVB: initialising frontend 0 (STB0899 Multistandard)...<br>
dvb_frontend_ioctl<br>
dvb_ca adapter 0: DVB CAM detected and initialised successfully<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_add_event<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=2<br>
dvb_frontend_thread: Retune requested, FESTAT_RETUNE<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=16<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_release<br>
dvb_frontend_thread: frontend_wakeup<br>
roger@myth:~$<br>
<br>
Here is a run of szap<br>
<br>
roger@myth:~$ szap -c satchannels.conf "BBC 1 London"<br>
reading channels from file 'satchannels.conf'<br>
zapping to 1 'BBC 1 London':<br>
sat 0, frequency = 10773 MHz H, symbolrate 22000000, vpid = 0x1388,
apid = 0x1389 sid = 0x189d<br>
Querying info .. Delivery system=DVB-S<br>
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'<br>
----------------------------------&gt; Using 'STB0899 DVB-S' DVB-S<br>
do_tune: API version=3, delivery system = 0<br>
do_tune: Frequency = 1023000, Srate = 22000000<br>
do_tune: Frequency = 1023000, Srate = 22000000<br>
<br>
<br>
status 1e | signal 0193 | snr 007b | ber 00000000 | unc fffffffe |
FE_HAS_LOCK<br>
<br>
roger@myth:~$<br>
<br>
<br>
and here is the dmesg from that<br>
<br>
dvb_frontend_open<br>
dvb_frontend_start<br>
dvb_frontend_thread<br>
DVB: initialising frontend 0 (STB0899 Multistandard)...<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl: DVBFE_GET_INFO<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_get_event<br>
dvb_frontend_ioctl<br>
newfec_to_oldfec: Unsupported FEC 9<br>
dvb_frontend_ioctl: FESTATE_RETUNE: fepriv-&gt;state=2<br>
dvb_frontend_add_event<br>
dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=2<br>
dvb_frontend_thread: Retune requested, FESTAT_RETUNE<br>
dvb_frontend_ioctl<br>
stb6100_set_bandwidth: Bandwidth=51610000<br>
stb6100_get_bandwidth: Bandwidth=52000000<br>
stb6100_get_bandwidth: Bandwidth=52000000<br>
stb6100_set_frequency: Frequency=1023000<br>
stb6100_get_frequency: Frequency=1022994<br>
stb6100_get_bandwidth: Bandwidth=52000000<br>
dvb_frontend_thread: SEARCH callback exists at 0xe0be8cf3<br>
dvb_frontend_thread: STATUS = DVBFE_ALGO_SEARCH_SUCCESS<br>
dvb_frontend_thread: TRACK callback exists at 0xe0be7078<br>
dvb_frontend_add_event<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_ioctl<br>
dvb_frontend_release<br>
roger@myth:~$<br>
<br>
<br>
I am having a little difficulty working out whta is going on. Am I
wasting my time?<br>
<br>
Roger<br>
</body>
</html>


--===============1786330936==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1786330936==--
