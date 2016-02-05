Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.bgcomp.co.uk ([81.187.35.205]:56015 "EHLO
	mailgate.bgcomp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbcBEPFu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 10:05:50 -0500
Received: from eth7.localnet (mailgate.bgcomp.co.uk [IPv6:2001:8b0:ca:2::fd])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	(Authenticated sender: b)
	by mailgate.bgcomp.co.uk (Postfix) with ESMTPSA id A0F6C1B652
	for <linux-media@vger.kernel.org>; Fri,  5 Feb 2016 15:05:47 +0000 (GMT)
From: Bob Goddard <linuxtv@1.linuxtv.bgcomp.co.uk>
To: linux-media@vger.kernel.org
Subject: dvbv5-scan fails on DVB-S2
Date: Fri, 05 Feb 2016 15:05:47 +0000
Message-ID: <1512032.oAz5utTtnS@eth7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can someone please confirm that dvbv5-scan still works with DVB-S2 transponders?

For the life of me, I cannot get it to pick up any DVB-S2 channels on Astra 28E, but it works fine in MythTV & kaffeine.

If I restrict the scan to a single BBC HD tp:

## Astra 2E
# Transponder 61
[CHANNEL]
        DELIVERY_SYSTEM = DVBS2
        FREQUENCY = 11024000
        POLARIZATION = HORIZONTAL
        SYMBOL_RATE = 23000000
        INNER_FEC = 2/3
        MODULATION = PSK/8
        INVERSION = AUTO

All I get is...



b@eth7 ~/ff/dtv-scan-tables$ /opt/v4l-utils/bin/dvbv5-scan -l UNIVERSAL -F -vvvvvvvv -C gb ~/Astra-28.2E-1
Using LNBf UNIVERSAL
        Europe
        10800 to 11800 MHz and 11600 to 12700 MHz
        Dual LO, IF = lowband 9750 MHz, highband 10600 MHz
using demux '/dev/dvb/adapter0/demux0'
Device NXP TDA10071 (/dev/dvb/adapter0/frontend0) capabilities:
     CAN_2G_MODULATION
     CAN_FEC_1_2
     CAN_FEC_2_3
     CAN_FEC_3_4
     CAN_FEC_4_5
     CAN_FEC_5_6
     CAN_FEC_6_7
     CAN_FEC_7_8
     CAN_FEC_8_9
     CAN_FEC_AUTO
     CAN_INVERSION_AUTO
     CAN_QPSK
     CAN_RECOVER
DVB API Version 5.10, Current v5 delivery system: DVBS2
Supported delivery systems: 
     DVBS
    [DVBS2]
ERROR    command BANDWIDTH_HZ (5) not found during retrieve
Cannot calc frequency shift. Either bandwidth/symbol-rate is unavailable (yet).
Scanning frequency #1 11024000
DiSEqC VOLTAGE: 18
DiSEqC TONE: OFF
FREQUENCY = 11024000
INVERSION = AUTO
SYMBOL_RATE = 23000000
INNER_FEC = 2/3
MODULATION = PSK/8
PILOT = 4294967295
ROLLOFF = AUTO
POLARIZATION = HORIZONTAL
STREAM_ID = 0
DELIVERY_SYSTEM = DVBS2
Status: 
BER: 0, Strength: 0, SNR: 0, UCB: 0
DEBUG    Stats for STATUS = 0
DEBUG    Stats for STATUS = 0
DEBUG    Stats for STATUS = 0
DEBUG    Stats for POST BER = 0
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
Status: 
BER: 0, Strength: 0, SNR: 0, UCB: 0
DEBUG    Stats for STATUS = 0
DEBUG    Stats for STATUS = 0
DEBUG    Stats for POST BER = 0
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
...[REPEAT]...
DiSEqC VOLTAGE: OFF

