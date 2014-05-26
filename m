Return-path: <linux-media-owner@vger.kernel.org>
Received: from relaycp04.dominioabsoluto.net ([217.116.26.100]:44164 "EHLO
	relaycp04.dominioabsoluto.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbaEZRqJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 13:46:09 -0400
Received: from smtp.movistar.es (smtp21.acens.net [86.109.99.145])
	by relaycp04.dominioabsoluto.net (Postfix) with ESMTP id 6534564618
	for <linux-media@vger.kernel.org>; Mon, 26 May 2014 19:39:41 +0200 (CEST)
Received: from jar7.dominio (88.3.12.114) by smtp.movistar.es (8.6.122.03) (authenticated as jareguero$telefonica.net)
        id 5379BC360030328A for linux-media@vger.kernel.org; Mon, 26 May 2014 17:39:41 +0000
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: Problem with dvbv5-zap
Date: Mon, 26 May 2014 19:39:38 +0200
Message-ID: <1575891.R2thD67EOX@jar7.dominio>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to use dvbv5-zap but give me an error and exit:

$ dvbv5-zap -a 2 -c Astra-19.2E  -l ENHANCED -I DVBV5 -v  ZDF
Using LNBf ENHANCED
        Astra
        10700 to 11700 MHz
        Single LO, IF = 9750 MHz
using demux '/dev/dvb/adapter2/demux0'
reading channels from file 'Astra-19.2E'
Device STB0899 Multistandard (/dev/dvb/adapter2/frontend0) capabilities:
     CAN_2G_MODULATION
     CAN_FEC_AUTO
     CAN_INVERSION_AUTO
     CAN_QPSK
DVB API Version 5.10, Current v5 delivery system: DVBS
Supported delivery systems: 
    [DVBS]
     DVBS2
     DSS
tuning to 11953 Hz
DiSEqC VOLTAGE: 18
DiSEqC TONE: OFF
ERROR    FE_SET_PROPERTY: Invalid argument
FREQUENCY = 11953
INVERSION = AUTO
SYMBOL_RATE = 27500
INNER_FEC = 3/4
POLARIZATION = HORIZONTAL
DELIVERY_SYSTEM = DVBS
ERROR: dvb_fe_set_parms failed (Invalid argument)
DiSEqC VOLTAGE: OFF

I try with two cards and the two give me the same error.

Jose alberto
