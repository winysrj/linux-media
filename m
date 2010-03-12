Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.kapsch.net ([148.198.2.17]:50480 "EHLO mx02.kapsch.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab0CLLCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 06:02:00 -0500
From: =?iso-8859-1?Q?H=F6rlin_Magnus?= <Magnus.Hoerlin@kapsch.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 12 Mar 2010 11:38:38 +0100
Subject: tzap -r doesn't work on new Swedish DVB-T channels
Message-ID: <7C87E377F5AEAC4F97A30AAB61B2CC283E74702C@s037b252.kapsch.co.at>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi. Since february there are some new h264 SD channels in the Swedish DVB-T network. I get a lock with tzap, I can watch the channels in VDR but I get no output on /dev/dvb/adapterX/dvr0 then running tzap -r on 506 MHz. On all other transponders I get a stream on dvr0. Scan finds some strange channels that don't provide a name on this frequency:

[04b0]:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:1200:3
[0316]:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:790:3
[0320]:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:800:3
Boxer Navigator:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:65534:3
[0302]:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:770:3
[02ee]:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:750:3
BBC World News:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:560:3
Discovery T&L:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:570:3
Discovery Science:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:580:3
Disney XD:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:590:3
Showtime:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:600:3
7:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:810:3
Star!:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:960:3

Can anyone point me in the right direction in the tzap code to try to find the reason for this?

/Magnus H


The information contained in this e-mail message is privileged and
confidential and is for the exclusive use of the addressee. The person
who receives this message and who is not the addressee, one of his
employees or an agent entitled to hand it over to the addressee, is
informed that he may not use, disclose or reproduce the contents
thereof, and is kindly asked to notify the sender and delete the e-mail
immediately.


