Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40460 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaJHMKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 08:10:05 -0400
Received: by mail-pd0-f178.google.com with SMTP id y10so6883300pdj.9
        for <linux-media@vger.kernel.org>; Wed, 08 Oct 2014 05:10:05 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [PATCH 0/4] v4l-utils:libdvbv5,dvb: add basic support for ISDB-S 
Date: Wed,  8 Oct 2014 21:09:37 +0900
Message-Id: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This patch series adds tuning and scanning features for ISDB-S.
Other part of the libdvbv5 API may not work for ISDB-S.
At least the charset conversion and the parser for extended
event descriptors do not work now,
as they require some ISDB-S(/T) specific modifications.

Akihiro Tsukada (4):
  v4l-utils/libdvbv5: avoid crash when failed to get a channel name
  v4l-utils/libdvbv5: add support for ISDB-S tuning
  v4l-utils/libdvbv5: add support for ISDB-S scanning
  v4l-utils/dvbv5-scan: add support for ISDB-S scanning

 lib/include/libdvbv5/dvb-scan.h |   2 +
 lib/libdvbv5/dvb-fe.c           |   6 +-
 lib/libdvbv5/dvb-file.c         |  32 +++++++---
 lib/libdvbv5/dvb-sat.c          |  11 ++++
 lib/libdvbv5/dvb-scan.c         | 125 +++++++++++++++++++++++++++++++++++++++-
 lib/libdvbv5/parse_string.c     |  23 ++++++++
 utils/dvb/dvb-format-convert.c  |   3 +-
 utils/dvb/dvbv5-scan.c          |  14 +++++
 8 files changed, 203 insertions(+), 13 deletions(-)

-- 
2.1.2

