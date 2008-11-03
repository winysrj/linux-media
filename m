Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from viefep18-int.chello.at ([213.46.255.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <basq@bitklub.hu>) id 1Kwx2U-0003Pj-78
	for linux-dvb@linuxtv.org; Mon, 03 Nov 2008 11:52:09 +0100
Received: from edge03.upc.biz ([192.168.13.238]) by viefep19-int.chello.at
	(InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
	id <20081103105132.OAWT7421.viefep19-int.chello.at@edge03.upc.biz>
	for <linux-dvb@linuxtv.org>; Mon, 3 Nov 2008 11:51:32 +0100
Date: Mon, 3 Nov 2008 11:51:16 +0100
From: Kovacs Balazs <basq@bitklub.hu>
Message-ID: <167586304.20081103115116@bitklub.hu>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] S2API + TT3200 + Amos4w 10.723 S2 problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi All!

  I tried a few variation, but without any success:

  I try to lock (stable! :)) on our new transponders at Amos 4W:

10,723(V) GHz, DVB-S2/8PSK, SR:30000, FEC:2/3, MPEG-4/Conax
10,759(V) GHz, DVB-S2/8PSK, SR:30000, FEC:2/3, MPEG-4/Conax
10,842(V) GHz, DVB-S2/8PSK, SR:30000, FEC:2/3, MPEG-4/Conax

with a TT3200 card + Debian etch with 2.4.24 etchnhalf kernel + the current V4L-DVB mercurial drivers compiled.

  The drivers recognizes my card, and for example it works good with Premiere's S2 transponders at Astra 19.2E. 

But it won't lock stable on our Amos's transponders.

  FYI: on these TP's there's a pilot signal and rolloff set to 0.20. I tried to push these parameters to scan-s2 and szap-s2, but scan-s2 sometimes lock and sometimes won't on these transponders and also szap-s2 (after a few try to lock with scan-s2 and get the channels.conf from these transponders) sometimes locks, but it's not stable, it lost lock after a few seconds.

  What I recognized also: if i run szap-s2 on our transponders it gives me the status message lines much slower than on other TP's.

it almost always looks like this:

/usr/src/dvb/s2api/szap-s2# ./szap-s2-thome.sh
reading channels from file '/root/.szap/channels.conf'
zapping to 1 '1':
delivery DVB-S2, modulation 8PSK
sat 0, frequency 10723 MHz V, symbolrate 30000000, coderate 2/3, rolloff 0.20
vpid 0x00b3, apid 0x00b1, sid 0x00b4
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 00b1 | snr 0000 | ber 00000000 | unc fffffffe |

but sometimes it can lock, very rare...

please, help me.

thanks,

Basq







_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
