Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <landemaine@gmail.com>) id 1LzUqg-0005fR-Oe
	for linux-dvb@linuxtv.org; Thu, 30 Apr 2009 13:54:43 +0200
Received: by fg-out-1718.google.com with SMTP id l27so1095550fgb.2
	for <linux-dvb@linuxtv.org>; Thu, 30 Apr 2009 04:54:39 -0700 (PDT)
MIME-Version: 1.0
From: Charles <landemaine@gmail.com>
Date: Thu, 30 Apr 2009 13:54:19 +0200
Message-ID: <e6575a30904300454w117e6293p4793ad6c2b5c706@mail.gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Can't scan transponders with Terratec Cinergy HT PCI
	board
Reply-To: linux-media@vger.kernel.org
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

Hello,


I installed my Terratec Cinergy HT PCI DVB-T board on Ubuntu 9.04
using your tutorial
(http://www.linuxtv.org/wiki/index.php/How_to_Obtain%2C_Build_and_Install_V4L-DVB_Device_Drivers)
and when trying to scan transponders, no result was found:

$ ls -l /dev/dvb/adapter0
total 0
crw-rw----+ 1 root video 212, 1 2009-04-30 12:19 demux0
crw-rw----+ 1 root video 212, 2 2009-04-30 12:19 dvr0
crw-rw----+ 1 root video 212, 0 2009-04-30 12:19 frontend0
crw-rw----+ 1 root video 212, 3 2009-04-30 12:19 net0

$ scan /usr/share/dvb/dvb-t/fr-Nantes
scanning /usr/share/dvb/dvb-t/fr-Nantes
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 498000000 0 2 9 3 1 0 0
initial transponder 506000000 0 2 9 3 1 0 0
initial transponder 522000000 0 2 9 3 1 0 0
initial transponder 530000000 0 2 9 3 1 0 0
initial transponder 658000000 0 2 9 3 1 0 0
initial transponder 802000000 0 2 9 3 1 0 0
>>> tune to: 498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 530000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 530000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 802000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 802000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

$ dvbscan /usr/share/dvb/dvb-t/fr-Nantes
Unable to query frontend status

$ w_scan -ft -X
w_scan version 20081106
Info: using DVB adapter auto detection.
   Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
-_-_-_-_ Getting frontend capabilities-_-_-_-_
frontend Zarlink ZL10353 DVB-T supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
177500:
184500:
191500:
198500:
205500:
212500:
219500:
226500:
474000:
482000:
490000:
498000:
506000:
514000:
522000:
530000:
538000:
546000:
554000:
562000:
570000:
578000:
586000:
594000:
602000:
610000:
618000:
626000:
634000:
642000:
650000:
658000:
666000:
674000:
682000:
690000:
698000:
706000:
714000:
722000:
730000:
738000:
746000:
754000:
762000:
770000:
778000:
786000:
794000:
802000:
810000:
818000:
826000:
834000:
842000:
850000:
858000:
ERROR: Sorry - i couldn't get any working frequency/transponder
 Nothing to scan!!
dumping lists (0 services)
Done.
$



Any idea?
Thanks in advance,

Charles.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
