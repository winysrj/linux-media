Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.infomir.com.ua ([79.142.192.5] helo=infomir.com.ua)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdp@teletec.com.ua>) id 1LHdKl-00036V-CL
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 13:04:27 +0100
Received: from [10.128.0.10] (iptv.infomir.com.ua [79.142.192.146])
	by infomir.com.ua with ESMTP id 1LHdKg-000879-9Z
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 14:04:22 +0200
Message-ID: <495A0E46.6030903@teletec.com.ua>
Date: Tue, 30 Dec 2008 14:04:22 +0200
From: Dmitry Podyachev <vdp@teletec.com.ua>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1230548402.10016.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.1.1230548402.10016.linux-dvb@linuxtv.org>
Subject: [linux-dvb] dvb-t config for Ukraine_Kiev (ua)
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

#file for dvb-apps/util/scan/dvb-t/ua-kiev
#T freq     bw   fec_hi fec_lo  mod     transmission-mode guard-interval 
hierarchy
T 634000000 8MHz AUTO   NONE    QAM64   8k                AUTO          NONE
T 650000000 8MHz AUTO   NONE    QAM64   8k                AUTO          NONE
T 714000000 8MHz AUTO   NONE    QAM64   8k                AUTO          NONE
T 818000000 8MHz AUTO   NONE    QAM64   8k                AUTO          NONE


#dvbt.conf channels list for  Ukraine_Kiev (for 
dvb-apps/util/szap/channels-conf/dvb-t/ua-kiev)

UT-1:634000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:4111:4112:1
RADA:634000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:4131:4132:3

5 
KANAL:650000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:4311:4312:1
MEGASPORT:650000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:4321:4322:2
TET:650000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:4331:4332:3
OTV:650000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:4341:4342:4
ICTV:650000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:4351:4352:5

KDRTRK:714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:1011:1012:1
KULTURA:714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:1031:1032:3
UR1:714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:1111:11
UR2:714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:1121:12
UR3:714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:1131:13


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
