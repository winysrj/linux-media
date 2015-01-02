Return-path: <linux-media-owner@vger.kernel.org>
Received: from out-mta20.ai270.net ([94.126.40.164]:33499 "EHLO
	out-mta1.ai270.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751779AbbABTgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 14:36:19 -0500
Received: from [94.126.40.187] (helo=outscan1.ai270.net)
	by out-mta1.ai270.net with esmtp (Exim 4.80)
	(envelope-from <lists@keynet-technology.com>)
	id 1Y77ca-0005zg-Am
	for linux-media@vger.kernel.org; Fri, 02 Jan 2015 19:10:52 +0000
Received: from mail.lcn.com (mail.lcn.com [94.126.40.131])
	by outscan1.ai270.net (8.14.3/8.14.3/Debian-9.4) with ESMTP id t02JAq9D011216
	for <linux-media@vger.kernel.org>; Fri, 2 Jan 2015 19:10:52 GMT
Received: from 2.152.208.46.dyn.plus.net ([46.208.152.2] helo=ha-server.lan)
	by mail.lcn.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <lists@keynet-technology.com>)
	id 1Y77cZ-0003Dq-Ti
	for linux-media@vger.kernel.org; Fri, 02 Jan 2015 19:10:51 +0000
Received: from localhost (localhost [127.0.0.1])
	by ha-server.lan (Postfix) with ESMTP id 8BA8ADA0F2B
	for <linux-media@vger.kernel.org>; Fri,  2 Jan 2015 19:10:51 +0000 (GMT)
Received: from ha-server.lan ([127.0.0.1])
	by localhost (ha-server.lan [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h9Kne6aGZKmV for <linux-media@vger.kernel.org>;
	Fri,  2 Jan 2015 19:10:51 +0000 (GMT)
Received: from [10.0.0.1] (Core-i5.lan [10.0.0.1])
	by ha-server.lan (Postfix) with ESMTP id 0B614DA0F26
	for <linux-media@vger.kernel.org>; Fri,  2 Jan 2015 19:10:51 +0000 (GMT)
Message-ID: <54A6ED3B.9020004@keynet-technology.com>
Date: Fri, 02 Jan 2015 19:10:51 +0000
From: Richard F <lists@keynet-technology.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dtv_property_legacy_params_sync
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dtv_property_legacy_params_sync: doesn't know how to handle a DVBv3 call to delivery system 0

Hi,

I'm new to this list, just updated VDR (2.06) and a newer kernel (3.12) 
and getting
the above messages from my dtt200u receiver fill my kernel log.
Is there a straightforward way to stop them?
The suggestion from the VDR list is that this is a driver issue.

dvb-fe-tool gives the following output but can't set the V5 delivery 
system for some reason.

Thanks

INFO Device WideView USB DVB-T (/dev/dvb/adapter0/frontend0) capabilities:
INFO CAN_FEC_1_2
INFO CAN_FEC_2_3
INFO CAN_FEC_3_4
INFO CAN_FEC_5_6
INFO CAN_FEC_7_8
INFO CAN_FEC_AUTO
INFO CAN_GUARD_INTERVAL_AUTO
INFO CAN_HIERARCHY_AUTO
INFO CAN_INVERSION_AUTO
INFO CAN_QAM_16
INFO CAN_QAM_64
INFO CAN_QAM_AUTO
INFO CAN_QPSK
INFO CAN_RECOVER
INFO CAN_TRANSMISSION_MODE_AUTO
INFO DVB API Version 5.10, Current v5 delivery system: UNDEFINED
INFO Supported delivery system:
INFO DVBT
INFO Got parameters for DVBT:
INFO FREQUENCY = 0
INFO MODULATION = QPSK
INFO BANDWIDTH_HZ = 0
INFO INVERSION = OFF
INFO CODE_RATE_HP = NONE
INFO CODE_RATE_LP = NONE
INFO GUARD_INTERVAL = 1/32
INFO TRANSMISSION_MODE = 2K
INFO HIERARCHY = NONE
INFO DELIVERY_SYSTEM = DVBT
INFO FREQUENCY = 0
INFO MODULATION = QPSK
INFO BANDWIDTH_HZ = 0
INFO INVERSION = OFF
INFO CODE_RATE_HP = NONE
INFO CODE_RATE_LP = NONE
INFO GUARD_INTERVAL = 1/32
INFO TRANSMISSION_MODE = 2K
INFO HIERARCHY = NONE
INFO DELIVERY_SYSTEM = DVBT

