Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab3AOCbd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 21:31:33 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0F2VXaA014214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 21:31:33 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv10 00/15] DVB QoS statistics API
Date: Tue, 15 Jan 2013 00:30:46 -0200
Message-Id: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DVBv5 methods to retrieve QoS statistics.

Those methods allow per-layer and global statistics.

Implemented 2 QoS statistics on mb86a20s, one global only
(signal strengh), and one per layer (BER).

Tested with a modified version of dvbv5-zap, that allows monitoring
those stats. Test data follows

Tested with 1-segment at layer A, and 12-segment at layer B:

[ 3735.973058] i2c i2c-4: mb86a20s_layer_bitrate: layer A bitrate: 440 kbps; counter = 196608 (0x030000)
[ 3735.976803] i2c i2c-4: mb86a20s_layer_bitrate: layer B bitrate: 16851 kbps; counter = 8257536 (0x7e0000)

a) Global stats:

Signal strength:
	QOS_SIGNAL_STRENGTH[0] = 4096

BER (sum of BE count and bit counts for both layers):
	QOS_BIT_ERROR_COUNT[0] = 1087865
	QOS_TOTAL_BITS_COUNT[0] = 67043313

b) Per-layer stats:

Layer A BER:
	QOS_BIT_ERROR_COUNT[1] = 236
	QOS_TOTAL_BITS_COUNT[1] = 917490

Layer B BER:
	QOS_BIT_ERROR_COUNT[2] = 1087629
	QOS_TOTAL_BITS_COUNT[2] = 66125823

TODO:
	- add more statistics at mb86a20s;
	- implement support for DTV_QOS_ENUM;
	- some cleanups at get_frontend logic at dvb core, to avoid
	  it to be called outside the DVB thread loop.

All the above changes can be done a little later during this development
cycle, so my plan is to merge it upstream at the beginning of the 
next week, to allow others to test.

I added an ugly hack on my experimental v4l-utils tree, to allow
testing it:
	http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/shortlog/refs/heads/stats

GIT url for it is:
	git://linuxtv.org/mchehab/experimental-v4l-utils.git stats


---

    v6: Add DocBook documentation.
    v7: Some fixes as suggested by Antti
    v8: Documentation fix, compilation fix and name the stats struct,
        for its reusage inside the core
    v9: counters need 32 bits. So, change the return data types to
        s32/u32 types
    v10: Counters changed to 64 bits for monotonic increment
	 Don't create a separate get_stats callback. get_frontend
	 is already good enough for it.


Mauro Carvalho Chehab (15):
  mb86a20s: improve error handling at get_frontend
  dvb: Add DVBv5 stats properties for Quality of Service
  dvb: the core logic to handle the DVBv5 QoS properties
  mb86a20s: Update QoS statistics at FE read_status
  mb86a20s: functions reorder
  mb86a20s: Fix i2c gate on error
  mb86a20s: improve debug for RF level
  mb86a20s: fix interleaving and FEC retrival
  mb86a20s: convert it to use dev_info/dev_err/dev_dbg
  mb86a20s: -EBUSY is expected when getting QoS measures
  mb86a20s: make AGC work better
  mb86a20s: Some improvements for BER measurement
  mb86a20s: improve bit error count for BER
  dvb: increase API version
  mb86a20s: global stat is just a sum, and not an increment

 Documentation/DocBook/media/dvb/dvbapi.xml      |    2 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml |  115 ++-
 drivers/media/dvb-core/dvb_frontend.c           |   53 ++
 drivers/media/dvb-core/dvb_frontend.h           |   11 +
 drivers/media/dvb-frontends/mb86a20s.c          | 1024 ++++++++++++++++++-----
 include/uapi/linux/dvb/frontend.h               |   83 +-
 include/uapi/linux/dvb/version.h                |    2 +-
 7 files changed, 1066 insertions(+), 224 deletions(-)

-- 
1.7.11.7

