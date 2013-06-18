Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:57449 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868Ab3FROUf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 10:20:35 -0400
Received: from [2001:7e8:2221:300:230:5ff:fec0:2d3b] (helo=devbox)
	by ibiza.bxl.tuxicoman.be with smtp (Exim 4.80.1)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1Uowli-0006xE-B7
	for linux-media@vger.kernel.org; Tue, 18 Jun 2013 16:20:23 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 0/6] v4l-utils: v4l-utils: Fix satellite support in dvbv5-{scan,zap} tools
Date: Tue, 18 Jun 2013 16:19:03 +0200
Message-Id: <cover.1371561676.git.gmsoft@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This set of patch fix sat support for dvbv5 libs and utils.
In this set, a different approach is used. The polarization parameter is stored in
the DTV_POLARIZATION property.

  Guy

Guy Martin (6):
  libdvbv5: Remove buggy parsing of extra DTV_foo parameters
  libdvbv5: Add parsing of POLARIZATION
  libdvbv5: Export dvb_fe_is_satellite()
  libdvbv5: Fix satellite handling and apply polarization parameter to
    the frontend
  libdvbv5: Use a temporary copy of the dvb parameters when tuning
  dvbv5-zap: Parse the LNB from the channel file

 lib/include/dvb-fe.h      |  2 +-
 lib/include/dvb-file.h    |  1 -
 lib/include/dvb-sat.h     |  1 -
 lib/libdvbv5/dvb-fe.c     | 79 ++++++++++++++++++-----------------------
 lib/libdvbv5/dvb-file.c   | 90 +++++++++++++++--------------------------------
 lib/libdvbv5/dvb-sat.c    | 68 +++++++++++++----------------------
 lib/libdvbv5/dvb-v5-std.c |  9 ++---
 utils/dvb/dvbv5-zap.c     |  9 +++++
 8 files changed, 100 insertions(+), 159 deletions(-)

-- 
1.8.1.5


