Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55484 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaFVMuW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jun 2014 08:50:22 -0400
Received: by mail-wg0-f44.google.com with SMTP id x13so5394199wgg.15
        for <linux-media@vger.kernel.org>; Sun, 22 Jun 2014 05:50:21 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 0/2] Clean up public libdvbv5 interface 
Date: Sun, 22 Jun 2014 14:49:45 +0200
Message-Id: <1403441387-31604-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

If we want to enable libdvbv5 from v4l-utils by default its
exported interface should be as clean as possible.

This series prefixes all functions with _dvb. I omitted
symbols starting with atsc and isdb.

Thanks,
Gregor

Gregor Jasny (2):
  Hide parse_string.h content in shared library interface
  Prefix exported functions with dvb_

 lib/include/libdvbv5/crc32.h                   |   2 +-
 lib/include/libdvbv5/desc_extension.h          |   8 +-
 lib/include/libdvbv5/descriptors.h             |   4 +-
 lib/include/libdvbv5/dvb-demux.h               |   2 +-
 lib/include/libdvbv5/dvb-file.h                |  38 +++---
 lib/include/libdvbv5/dvb-sat.h                 |   4 +-
 lib/include/libdvbv5/dvb-scan.h                |   6 +-
 lib/include/libdvbv5/nit.h                     |   3 +-
 lib/libdvbv5/crc32.c                           |   2 +-
 lib/libdvbv5/descriptors.c                     |  16 +--
 lib/libdvbv5/descriptors/desc_ca.c             |   4 +-
 lib/libdvbv5/descriptors/desc_cable_delivery.c |   4 +-
 lib/libdvbv5/descriptors/desc_event_extended.c |   2 +-
 lib/libdvbv5/descriptors/desc_event_short.c    |   2 +-
 lib/libdvbv5/descriptors/desc_extension.c      |  10 +-
 lib/libdvbv5/descriptors/desc_sat.c            |   6 +-
 lib/libdvbv5/dvb-demux.c                       |   2 +-
 lib/libdvbv5/dvb-file.c                        |  80 ++++++------
 lib/libdvbv5/dvb-sat.c                         |   6 +-
 lib/libdvbv5/dvb-scan.c                        | 163 +++++++++++++------------
 lib/libdvbv5/parse_string.h                    |   8 ++
 lib/libdvbv5/tables/eit.c                      |  12 +-
 lib/libdvbv5/tables/nit.c                      |   3 +-
 utils/dvb/dvb-fe-tool.c                        |   2 +-
 utils/dvb/dvb-format-convert.c                 |  10 +-
 utils/dvb/dvbv5-scan.c                         |  24 ++--
 utils/dvb/dvbv5-zap.c                          |  12 +-
 27 files changed, 224 insertions(+), 211 deletions(-)

-- 
1.9.1

