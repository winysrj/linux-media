Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53343 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaHWQnC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Aug 2014 12:43:02 -0400
Received: by mail-wi0-f178.google.com with SMTP id hi2so873351wib.5
        for <linux-media@vger.kernel.org>; Sat, 23 Aug 2014 09:43:01 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 0/5] Further clean up libdvbv5
Date: Sat, 23 Aug 2014 18:42:38 +0200
Message-Id: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here you'll find some patches to clean up libdvbv5. I tried to
reduce exported symbols of the shared library to easy
maintenance in the future.

Thanks,
Gregor

Gregor Jasny (5):
  libdvbv5: Remove dvbsat_polarization_name (same as dvb_sat_pol_name)
  libdvbv5: Rename and hide charset definitions
  libdvbv5: Hide unused and unexposed cnr_to_qual_s tables
  libdvbv5: Make dvb_xxx_charset const strings
  libdvbv5: Make dummy_fe static

 lib/include/libdvbv5/descriptors.h             |  2 --
 lib/include/libdvbv5/dvb-sat.h                 |  2 --
 lib/libdvbv5/descriptors.c                     |  3 ---
 lib/libdvbv5/descriptors/desc_event_extended.c |  2 +-
 lib/libdvbv5/descriptors/desc_event_short.c    |  4 ++--
 lib/libdvbv5/descriptors/desc_network_name.c   |  2 +-
 lib/libdvbv5/descriptors/desc_service.c        |  4 ++--
 lib/libdvbv5/descriptors/desc_ts_info.c        |  2 +-
 lib/libdvbv5/dvb-fe.c                          |  6 +++---
 lib/libdvbv5/dvb-sat.c                         |  7 -------
 lib/libdvbv5/parse_string.c                    | 12 ++++++++----
 lib/libdvbv5/parse_string.h                    |  7 +++++--
 lib/libdvbv5/tables/vct.c                      |  2 +-
 13 files changed, 24 insertions(+), 31 deletions(-)

-- 
2.1.0

