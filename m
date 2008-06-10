Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xsmtp1.ethz.ch ([82.130.70.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cluck@student.ethz.ch>) id 1K64Lj-0005yW-72
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 15:57:27 +0200
Message-ID: <484E8834.3000601@ethz.ch>
Date: Tue, 10 Jun 2008 15:57:08 +0200
From: Claudio Luck <cluck@ethz.ch>
MIME-Version: 1.0
To: abraham.manu@gmail.com
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] Multiproto DVBFE_GET_INFO and (not) locked
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

Hi Manu, hi all

I'm referring to the jusst.de/hg/multiproto tree. Working with a KNC1
DVB-S2 card to enhance the VideoLAN dvb plugin.

Testing showed that DVBFE_GET_INFO returns different frontend infos
(fec, mods) when the tuner is locked and when it is not (pasted below).

Is this the correct/expected behavior?


>From two separate runs, where the first leaves the tuner locked; first
run (femon says no lock at start):

> [00000303] dvb access debug: Opening device /dev/dvb/adapter1/frontend0
> [00000303] dvb access debug: ioctl DVBFE_GET_DELSYS
> [00000303] dvb access debug: ioctl DVBFE_GET_INFO
> [00000303] dvb access debug: Frontend Info:
> [00000303] dvb access debug:   api = DVB API 3.3
> [00000303] dvb access debug:   name = STB0899 DVB-S
> [00000303] dvb access debug:   frequency_min = 950000 (kHz)
> [00000303] dvb access debug:   frequency_max = 2150000 (kHz)
> [00000303] dvb access debug:   frequency_step = 0
> [00000303] dvb access debug:   frequency_tolerance = 0
> [00000303] dvb access debug:   symbol_rate_min = 1000000 (kHz)
> [00000303] dvb access debug:   symbol_rate_max = 45000000 (kHz)
> [00000303] dvb access debug:   symbol_rate_tolerance (ppm) = 0
> [00000303] dvb access debug: Frontend Info capability list:
> [00000303] dvb access debug: ioctl DVBFE_SET_DELSYS DVBFE_GET_INFO
> [00000303] dvb access debug:   delivery system DSS
> [00000303] dvb access debug:     modulations: QPSK
> [00000303] dvb access debug:     FEC: 1/2 2/3 3/4 5/6 6/7
> [00000303] dvb access debug: ioctl DVBFE_SET_DELSYS DVBFE_GET_INFO
> [00000303] dvb access debug:   delivery system DVB-S
> [00000303] dvb access debug:     modulations: QPSK
> [00000303] dvb access debug:     FEC: 1/2 2/3 3/4 5/6 6/7
> [00000303] dvb access debug: ioctl DVBFE_SET_DELSYS DVBFE_GET_INFO
> [00000303] dvb access debug:   delivery system DVB-S2
> [00000303] dvb access debug:     modulations: QPSK
> [00000303] dvb access debug:     FEC: 1/2 2/3 3/4 5/6 6/7
> [00000303] dvb access debug: End of capability list
> [00000303] dvb access debug: selected: DVB-S DSS DVB-S2
> [00000303] dvb access debug: dropped: DVB-T DVB-C DVB-H
> ...
> then more ioctl called (all works fine, i.e. VLC can stream DVB-S2)

Second run (femon says has lock at start):

> [00000303] dvb access debug: Opening device /dev/dvb/adapter1/frontend0
> [00000303] dvb access debug: ioctl DVBFE_GET_DELSYS
> [00000303] dvb access debug: ioctl DVBFE_GET_INFO
> [00000303] dvb access debug: Frontend Info:
> [00000303] dvb access debug:   api = DVB API 3.3
> [00000303] dvb access debug:   name = STB0899 DVB-S2
> [00000303] dvb access debug:   frequency_min = 950000 (kHz)
> [00000303] dvb access debug:   frequency_max = 2150000 (kHz)
> [00000303] dvb access debug:   frequency_step = 0
> [00000303] dvb access debug:   frequency_tolerance = 0
> [00000303] dvb access debug:   symbol_rate_min = 1000000 (kHz)
> [00000303] dvb access debug:   symbol_rate_max = 45000000 (kHz)
> [00000303] dvb access debug:   symbol_rate_tolerance (ppm) = 0
> [00000303] dvb access debug: Frontend Info capability list:
> [00000303] dvb access debug: ioctl DVBFE_SET_DELSYS DVBFE_GET_INFO
> [00000303] dvb access debug:   delivery system DSS
> [00000303] dvb access debug:     modulations: QPSK 8PSK 16APSK 32APSK
> [00000303] dvb access debug:     FEC: 1/2 1/3 1/4 2/3 2/5 3/4 3/5 4/5 5/6 8/9 9/10
> [00000303] dvb access debug: ioctl DVBFE_SET_DELSYS DVBFE_GET_INFO
> [00000303] dvb access debug:   delivery system DVB-S
> [00000303] dvb access debug:     modulations: QPSK 8PSK 16APSK 32APSK
> [00000303] dvb access debug:     FEC: 1/2 1/3 1/4 2/3 2/5 3/4 3/5 4/5 5/6 8/9 9/10
> [00000303] dvb access debug: ioctl DVBFE_SET_DELSYS DVBFE_GET_INFO
> [00000303] dvb access debug:   delivery system DVB-S2
> [00000303] dvb access debug:     modulations: QPSK 8PSK 16APSK 32APSK
> [00000303] dvb access debug:     FEC: 1/2 1/3 1/4 2/3 2/5 3/4 3/5 4/5 5/6 8/9 9/10
> [00000303] dvb access debug: End of capability list
> [00000303] dvb access debug: selected: DVB-S DSS DVB-S2
> [00000303] dvb access debug: dropped: DVB-T DVB-C DVB-H

-- 
Best Regards
Claudio Luck

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
