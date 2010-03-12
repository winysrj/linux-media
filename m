Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-204-227.junet.se ([80.244.204.227]:2041 "EHLO
	istvan.hopto.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932092Ab0CLLCH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 06:02:07 -0500
Received: from alefors.se (90-231-211-223-no124.tbcn.telia.com [90.231.211.223])
	by istvan.hopto.org (Postfix) with ESMTP id 89000401F
	for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 11:39:59 +0100 (CET)
Received: from W037D355 ([10.0.0.1]:33224)
	by alefors.se with [XMail 1.26 ESMTP Server]
	id <S2062> for <linux-media@vger.kernel.org> from <magnus@alefors.se>;
	Fri, 12 Mar 2010 11:43:09 +0100
From: "Magnus H" <magnus@alefors.se>
To: <linux-media@vger.kernel.org>
Subject: tzap -r doesn't work on new Swedish DVB-T channels
Date: Fri, 12 Mar 2010 11:39:50 +0100
Message-ID: <000201cac1d0$582d42c0$0887c840$@se>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: sv
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi. Since february there are some new h264 SD channels in the Swedish DVB-T
network. I get a lock with tzap, I can watch the channels in VDR but I get
no output on /dev/dvb/adapterX/dvr0 then running tzap -r on 506 MHz. On all
other transponders I get a stream on dvr0. Scan finds some strange channels
that don't provide a name on this frequency:

[04b0]:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRAN
SMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:1200:3
[0316]:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRAN
SMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:790:3
[0320]:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRAN
SMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:800:3
Boxer
Navigator:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:T
RANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:65534:3
[0302]:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRAN
SMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:770:3
[02ee]:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRAN
SMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:750:3
BBC World
News:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSM
ISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:560:3
Discovery
T&L:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMI
SSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:570:3
Discovery
Science:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRA
NSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:580:3
Disney
XD:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMIS
SION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:590:3
Showtime:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TR
ANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:600:3
7:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISS
ION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:810:3
Star!:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANS
MISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:960:3

Can anyone point me in the right direction in the tzap code to try to find
the reason for this?

/Magnus H


