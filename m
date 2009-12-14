Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nBEJ6IZI018984
	for <video4linux-list@redhat.com>; Mon, 14 Dec 2009 14:06:18 -0500
Received: from proxy3.bredband.net (proxy3.bredband.net [195.54.101.73])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nBEJ62lD012846
	for <video4linux-list@redhat.com>; Mon, 14 Dec 2009 14:06:03 -0500
Received: from ipb2.telenor.se (195.54.127.165) by proxy3.bredband.net
	(7.3.140.3) id 4AD3E1BA01A3A543 for video4linux-list@redhat.com;
	Mon, 14 Dec 2009 20:06:01 +0100
Message-ID: <4B268C96.2020605@home.se>
Date: Mon, 14 Dec 2009 20:05:58 +0100
From: Andreas Lunderhage <lunderhage@home.se>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Pinnacle Hybrid Pro Stick USB scan problems
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I have problems scanning with my Pinnacle Hybrid Pro Stick (320E). When 
using the scan command, it finds the channels in the first mux in the 
mux file but it fails to tune the next ones. If I use Kaffeine to scan, 
it gives the same result but I can also see that the signal strength 
shows 99% on those muxes it fails to scan.

I thinks this is a problem with the tuning since if I watch one channel 
and switch to another (on another mux), it fails to tune. If I stop the 
viewing of the current channel first, then it will succeed tuning the next.

I'm running Ubuntu 9.04 32-bit (kernel 2.6.28-17-generic) with the code 
built from the repository today.
I'm also running Ubuntu 9.10 64-bit (kernel 2.6.31-16) (on another 
machine), but it gives the same problem.


BR

/Andreas

Output from scan:

scanning /usr/share/dvb/dvb-t/se-Stockholm_Nacka
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 490000000 0 2 9 3 1 2 0
initial transponder 642000000 0 2 9 3 1 2 0
initial transponder 754000000 0 2 9 3 1 2 0
initial transponder 706000000 0 2 9 3 1 2 0
initial transponder 746000000 0 2 9 3 1 2 0
initial transponder 730000000 0 2 9 3 1 2 0
 >>> tune to: 
490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 

Network Name 'Teracom_Mux_1'
0x0000 0x04d8: pmt_pid 0x04d8 Sveriges Television -- SVT24 (running)
0x0000 0x161c: pmt_pid 0x161c Sveriges Television -- SVT2 Sörmland 
(running)
0x0000 0x168a: pmt_pid 0x168a Sveriges Television -- SVT1 ABC (running)
0x0000 0x16da: pmt_pid 0x16da Sveriges Television -- SVT1 Sörmland 
(running)
0x0000 0x1586: pmt_pid 0x1586 Sveriges Television -- SVT2 ABC (running)
0x0000 0x0bc2: pmt_pid 0x0bc2 SR -- SR-P1 (running)
0x0000 0x0bcc: pmt_pid 0x0bcc SR -- SR-P2 Musik (running)
0x0000 0x0bd6: pmt_pid 0x0bd6 SR -- SR-P3 (running)
0x0000 0x0366: pmt_pid 0x0366 Sveriges Television -- Barn/Kunskapsk. 
(running)
0x0000 0x0500: pmt_pid 0x0500 Sveriges Television -- SVT1 Tal txt (running)
0x0000 0x050a: pmt_pid 0x050a Sveriges Television -- SVT2 Tal txt (running)
0x0000 0xfffe: pmt_pid 0x0712 Boxer TV Access AB -- Boxer Navigator 
(running, scrambled)
 >>> tune to: 
642000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 

WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 
754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 

WARNING: >>> tuning failed!!!
 >>> tune to: 
754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 
706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 

WARNING: >>> tuning failed!!!
 >>> tune to: 
706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 
746000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 

WARNING: >>> tuning failed!!!
 >>> tune to: 
746000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 
730000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 

WARNING: >>> tuning failed!!!
 >>> tune to: 
730000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
dumping lists (12 services)
Done.
SVT24:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1249:1248:1240 

SVT2 
Sörmland:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1029:1028:5660 

SVT1 
ABC:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1019:1018:5770 

SVT1 
Sörmland:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1019:1018:5850 

SVT2 
ABC:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1029:1028:5510 

SR-P1:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:3019:3018:3010 

SR-P2 
Musik:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:3019:3028:3020 

SR-P3:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:3019:3038:3030 

Barn/Kunskapsk.:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:879:878:870 

SVT2 Tal 
txt:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1299:1026:1290 

SVT1 Tal 
txt:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1289:1016:1280 

Boxer 
Navigator:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:65534 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
