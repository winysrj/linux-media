Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50334 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaJZLq6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 07:46:58 -0400
Received: by mail-pa0-f43.google.com with SMTP id eu11so3729687pac.30
        for <linux-media@vger.kernel.org>; Sun, 26 Oct 2014 04:46:58 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2 0/7] v4l-utils/libdvbv5,dvb: add support for ISDB-S
Date: Sun, 26 Oct 2014 20:46:16 +0900
Message-Id: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This patch series adds tuning and scanning features for ISDB-S,
and required modifications to libdvbv5 and utils/dvb to support it.

Other part of the libdvbv5 API may not work for ISDB-S.
At least the the parser for extended event descriptors do not work now,
as they require some ISDB-S(/T) specific modifications.

Changes from v1:
* added COUNTER property to distingush country variant of ISDB-T
* added character conversion modules
* reflected the reviews on v1.

Akihiro Tsukada (7):
  v4l-utils/libdvbv5: fix auto generating of channel names
  v4l-utils/libdvbv5: add support for ISDB-S tuning
  v4l-utils/libdvbv5: add support for ISDB-S scanning
  v4l-utils/dvb: add COUNTRY property
  v4l-utils/libdvbv5: add gconv module for the text translation of
    ISDB-S/T.
  v4l-utils/libdvbv5: don't discard config-supplied parameters
  v4l-utils/libdvbv5, dvbv5-scan: generalize channel duplication check

 configure.ac                      |   4 +
 lib/Makefile.am                   |   5 +-
 lib/gconv/arib-std-b24.c          | 775 +++++++++++++++++++++++++++++++++++
 lib/gconv/en300-468-tab00.c       | 564 ++++++++++++++++++++++++++
 lib/gconv/gconv-modules           |   7 +
 lib/gconv/gconv.map               |   8 +
 lib/gconv/iconv/loop.c            | 523 ++++++++++++++++++++++++
 lib/gconv/iconv/skeleton.c        | 829 ++++++++++++++++++++++++++++++++++++++
 lib/gconv/jisx0213.h              | 102 +++++
 lib/include/libdvbv5/countries.h  | 308 ++++++++++++++
 lib/include/libdvbv5/dvb-fe.h     |   4 +
 lib/include/libdvbv5/dvb-scan.h   |   9 +-
 lib/include/libdvbv5/dvb-v5-std.h |   7 +-
 lib/libdvbv5/Makefile.am          |   2 +
 lib/libdvbv5/countries.c          | 403 ++++++++++++++++++
 lib/libdvbv5/dvb-fe.c             |  58 ++-
 lib/libdvbv5/dvb-file.c           |  68 +++-
 lib/libdvbv5/dvb-sat.c            |   9 +
 lib/libdvbv5/dvb-scan.c           | 122 +++++-
 lib/libdvbv5/dvb-v5-std.c         |   6 +-
 lib/libdvbv5/parse_string.c       |  15 +-
 utils/dvb/dvb-format-convert.c    |   3 +-
 utils/dvb/dvbv5-scan.c            |  28 +-
 utils/dvb/dvbv5-zap.c             |  11 +
 24 files changed, 3815 insertions(+), 55 deletions(-)
 create mode 100644 lib/gconv/arib-std-b24.c
 create mode 100644 lib/gconv/en300-468-tab00.c
 create mode 100644 lib/gconv/gconv-modules
 create mode 100644 lib/gconv/gconv.map
 create mode 100644 lib/gconv/iconv/loop.c
 create mode 100644 lib/gconv/iconv/skeleton.c
 create mode 100644 lib/gconv/jisx0213.h
 create mode 100644 lib/include/libdvbv5/countries.h
 create mode 100644 lib/libdvbv5/countries.c

-- 
2.1.2

