Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44660 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbaIBCEI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Sep 2014 22:04:08 -0400
Message-ID: <54052590.6060808@iki.fi>
Date: Tue, 02 Sep 2014 05:04:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: dvbv5-scan segfaults when invalid freqs got from tables
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
Could you look that one too?

There is utterly broken data got from tables and it crashes always.

Antti

[crope@localhost dvb]$ ./dvbv5-scan mux-Oulu-t2
Scanning frequency #1 177500000
Lock   (0x1f)
Service Showtime, provider DNA: reserved
Service Eurosport 2, provider DNA: reserved
Service Nelonen Maailma, provider DNA: reserved
Service Nelonen Nappula, provider DNA: reserved
Service Nelonen Prime, provider DNA: reserved
Service National Geographic, provider DNA: reserved
Service Investigation Discovery, provider DNA: reserved
Service Nelonen PRO 2 HD, provider DNA: reserved
Service MTV Sport 1 HD, provider DNA: reserved
Service Nelonen PRO 2 HD, provider DNA: reserved
Service Nelonen PRO 3, provider DNA: reserved
WARNING  Service ID 103 not found on PMT!
Service Nelonen PRO 4 , provider DNA: reserved
WARNING  Service ID 104 not found on PMT!
Service Nelonen PRO 5, provider DNA: reserved
WARNING  Service ID 105 not found on PMT!
Service Nelonen PRO 6, provider DNA: reserved
WARNING  Service ID 106 not found on PMT!
Service Nelonen PRO 7, provider DNA: reserved
WARNING  Service ID 107 not found on PMT!
Service Nelonen PRO 8, provider DNA: reserved
WARNING  Service ID 108 not found on PMT!
New transponder/channel found: #6: 1510003450
New transponder/channel found: #7: -2110588416
New transponder/channel found: #8: -587352536
New transponder/channel found: #9: 410
New transponder/channel found: #10: 511181010
New transponder/channel found: #11: -2133687758
New transponder/channel found: #12: -2132410148
New transponder/channel found: #13: 1745048284
New transponder/channel found: #14: 59046400
New transponder/channel found: #15: -1225129104
New transponder/channel found: #16: -603751716
New transponder/channel found: #17: 589880320
New transponder/channel found: #18: -1728445454
New transponder/channel found: #19: -100422436
New transponder/channel found: #20: 61004800
New transponder/channel found: #21: -891551084
New transponder/channel found: #22: -541710336
New transponder/channel found: #23: 106270
New transponder/channel found: #24: -536651392
New transponder/channel found: #25: 1375964032
New transponder/channel found: #26: 1308867968
New transponder/channel found: #27: -1241286784
New transponder/channel found: #28: 1879277952
New transponder/channel found: #29: 2049126272
New transponder/channel found: #30: -2080137344
New transponder/channel found: #31: -1744569984
New transponder/channel found: #32: -234638464
New transponder/channel found: #33: -1409046144
New transponder/channel found: #34: -1576808064
New transponder/channel found: #35: -905798784
New transponder/channel found: #36: -1778513088
New transponder/channel found: #37: -1520083210
Scanning frequency #2 205500000
Lock   (0x1f)
DMX_SET_FILTER failed (PID = 0x0000): 27 File too large
ERROR    error while waiting for PAT table
Scanning frequency #3 219500000
Lock   (0x1f)
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #4 498000000
Lock   (0x1f)
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #5 570000000
Lock   (0x1f)
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #6 1510003450
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #7 -2110588416
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #8 -587352536
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #9 410
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #10 511181010
ERROR    command STREAM_ID (42) not found during store
        (0x00)
Scanning frequency #11 -2133687758
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #12 -2132410148
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #13 1745048284
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #14 59046400
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #15 -1225129104
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #16 -603751716
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #17 589880320
ERROR    command STREAM_ID (42) not found during store
        (0x00)
Scanning frequency #18 -1728445454
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #19 -100422436
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #20 61004800
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #21 -891551084
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #22 -541710336
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #23 106270
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #24 -536651392
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #25 1375964032
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #26 1308867968
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #27 -1241286784
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #28 1879277952
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #29 2049126272
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #30 -2080137344
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #31 -1744569984
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #32 -234638464
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #33 -1409046144
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #34 -1576808064
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #35 -905798784
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #36 -1778513088
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
Scanning frequency #37 -1520083210
ERROR    command STREAM_ID (42) not found during store
ERROR    FE_SET_PROPERTY: Invalid argument
ERROR    dvb_fe_set_parms failed: Invalid argument
*** Error in 
`/home/crope/linuxtv/code/v4l-utils/utils/dvb/.libs/lt-dvbv5-scan': 
double free or corruption (fasttop): 0x00000000016b7030 ***
Segmentation fault (core dumped)
[crope@localhost dvb]$

-- 
http://palosaari.fi/
