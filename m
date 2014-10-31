Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49494 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbaJaNOI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:14:08 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so7595968pab.8
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 06:14:07 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 0/7] v4l-utils/libdvbv5,dvb: add support for ISDB-S
Date: Fri, 31 Oct 2014 22:13:37 +0900
Message-Id: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This patch series adds tuning and scanning features for ISDB-S,
and required modifications to libdvbv5 and utils/dvb to support it.
Other features of the libdvbv5 API may not work for ISDB-S.

Changes from v2:
 * rebased to the recent master (db6a15ad)
 * removed the unnecessary/wrong patches pointed out by the reviews
 * re-ordered the patches, non ISDB-S/T specific ones first
 * re-wrote countries.[ch], to include 3-letter country code support
 * make charset conversions of ARIB-STD-B24 encodings bidirectional
 * add SOBs

Akihiro Tsukada (7):
  v4l-utils/libdvbv5, dvbv5-scan: generalize channel duplication check
  v4l-utils/libdvbv5: add as many channels as possible in scanning
    DVB-T2
  v4l-utils/libdvbv5: wrong frequency in the output of satellite delsys
    scans
  v4l-utils/libdvbv5: add support for ISDB-S tuning
  v4l-utils/libdvbv5: add support for ISDB-S scanning
  v4l-utils/dvb: add COUNTRY property
  v4l-utils/libdvbv5: add gconv module for the text conversions of
    ISDB-S/T.

 configure.ac                      |   13 +
 lib/Makefile.am                   |    6 +-
 lib/gconv/arib-std-b24.c          | 1592 +++++++++++++++++++++++++++++++++++++
 lib/gconv/en300-468-tab00.c       |  564 +++++++++++++
 lib/gconv/gconv-modules           |    8 +
 lib/gconv/gconv.map               |    8 +
 lib/gconv/iconv/loop.c            |  523 ++++++++++++
 lib/gconv/iconv/skeleton.c        |  829 +++++++++++++++++++
 lib/gconv/jis0201.h               |   63 ++
 lib/gconv/jis0208.h               |  112 +++
 lib/gconv/jisx0213.h              |  102 +++
 lib/include/libdvbv5/countries.h  |  307 +++++++
 lib/include/libdvbv5/dvb-fe.h     |   14 +
 lib/include/libdvbv5/dvb-scan.h   |    9 +-
 lib/include/libdvbv5/dvb-v5-std.h |    7 +-
 lib/libdvbv5/Makefile.am          |    2 +
 lib/libdvbv5/countries.c          |  427 ++++++++++
 lib/libdvbv5/dvb-fe-priv.h        |    6 +-
 lib/libdvbv5/dvb-fe.c             |   93 ++-
 lib/libdvbv5/dvb-file.c           |   33 +
 lib/libdvbv5/dvb-sat.c            |    9 +
 lib/libdvbv5/dvb-scan.c           |  114 ++-
 lib/libdvbv5/dvb-v5-std.c         |    6 +-
 lib/libdvbv5/parse_string.c       |    8 +-
 utils/dvb/dvb-format-convert.c    |    3 +-
 utils/dvb/dvbv5-scan.c            |   26 +-
 utils/dvb/dvbv5-zap.c             |   10 +
 27 files changed, 4856 insertions(+), 38 deletions(-)
 create mode 100644 lib/gconv/arib-std-b24.c
 create mode 100644 lib/gconv/en300-468-tab00.c
 create mode 100644 lib/gconv/gconv-modules
 create mode 100644 lib/gconv/gconv.map
 create mode 100644 lib/gconv/iconv/loop.c
 create mode 100644 lib/gconv/iconv/skeleton.c
 create mode 100644 lib/gconv/jis0201.h
 create mode 100644 lib/gconv/jis0208.h
 create mode 100644 lib/gconv/jisx0213.h
 create mode 100644 lib/include/libdvbv5/countries.h
 create mode 100644 lib/libdvbv5/countries.c

-- 
2.1.3

