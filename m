Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58794 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab2AJVgW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 16:36:22 -0500
Message-ID: <4F0CAF53.3090802@iki.fi>
Date: Tue, 10 Jan 2012 23:36:19 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] DVBv5 tools version 0.0.1
References: <4F08385E.7050602@redhat.com>
In-Reply-To: <4F08385E.7050602@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Behaviour of new FE is strange for my eyes. Could you look and explain 
if it is intentional?

[crope@localhost dvb]$ ./dvb-fe-tool
Device Sony CXD2820R (DVB-T/T2) (/dev/dvb/adapter0/frontend0) capabilities:
	CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 
CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO 
CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_64 CAN_QAM_256 
CAN_QAM_AUTO CAN_QPSK CAN_TRANSMISSION_MODE_AUTO
DVB API Version 5.5, Current v5 delivery system: DVBT
Supported delivery systems: [DVBT] DVBT2 DVBC/ANNEX_A
[crope@localhost dvb]$ czap "MTV3 "
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/crope/.czap/channels.conf'
  11 MTV3 :330000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_128:305:561:3
  11 MTV3 : f 330000000, s 6875000, i 2, fec 0, qam 4, v 0x131, a 0x231, 
s 0x3
ERROR: frontend device is not a QAM (DVB-C) device
[crope@localhost dvb]$ ./dvb-fe-tool --set-delsys=DVBC/ANNEX_A
Device Sony CXD2820R (DVB-T/T2) (/dev/dvb/adapter0/frontend0) capabilities:
	CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 
CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO 
CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_64 CAN_QAM_256 
CAN_QAM_AUTO CAN_QPSK CAN_TRANSMISSION_MODE_AUTO
DVB API Version 5.5, Current v5 delivery system: DVBT
Supported delivery systems: [DVBT] DVBT2 DVBC/ANNEX_A
Changing delivery system to: DVBC/ANNEX_A
[crope@localhost dvb]$ ./dvb-fe-tool
Device Sony CXD2820R (DVB-T/T2) (/dev/dvb/adapter0/frontend0) capabilities:
	CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 
CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO 
CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_64 CAN_QAM_256 
CAN_QAM_AUTO CAN_QPSK CAN_TRANSMISSION_MODE_AUTO
DVB API Version 5.5, Current v5 delivery system: DVBC/ANNEX_A
Supported delivery systems: DVBT DVBT2 [DVBC/ANNEX_A]
[crope@localhost dvb]$ czap "MTV3 "
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/crope/.czap/channels.conf'
  11 MTV3 :330000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_128:305:561:3
  11 MTV3 : f 330000000, s 6875000, i 2, fec 0, qam 4, v 0x131, a 0x231, 
s 0x3
status 00 | signal ffff | snr 00c6 | ber 00000000 | unc 00000000 |
^C
[crope@localhost dvb]$ ./dvb-fe-tool
Device Sony CXD2820R (DVB-T/T2) (/dev/dvb/adapter0/frontend0) capabilities:
	CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 
CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO 
CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_64 CAN_QAM_256 
CAN_QAM_AUTO CAN_QPSK CAN_TRANSMISSION_MODE_AUTO
DVB API Version 5.5, Current v5 delivery system: DVBT
Supported delivery systems: [DVBT] DVBT2 DVBC/ANNEX_A
[crope@localhost dvb]$ czap "MTV3 "
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/crope/.czap/channels.conf'
  11 MTV3 :330000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_128:305:561:3
  11 MTV3 : f 330000000, s 6875000, i 2, fec 0, qam 4, v 0x131, a 0x231, 
s 0x3
ERROR: frontend device is not a QAM (DVB-C) device
[crope@localhost dvb]$ ./dvb-fe-tool
Device Sony CXD2820R (DVB-T/T2) (/dev/dvb/adapter0/frontend0) capabilities:
	CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 
CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO 
CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_64 CAN_QAM_256 
CAN_QAM_AUTO CAN_QPSK CAN_TRANSMISSION_MODE_AUTO
DVB API Version 5.5, Current v5 delivery system: DVBT
Supported delivery systems: [DVBT] DVBT2 DVBC/ANNEX_A
[crope@localhost dvb]$

-- 
http://palosaari.fi/
