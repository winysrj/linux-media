Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:54258 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920Ab3ENJiB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 05:38:01 -0400
Received: from lan226.bxl.tuxicoman.be ([172.19.1.226] helo=me)
	by ibiza.bxl.tuxicoman.be with smtp (Exim 4.80.1)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1UcBg5-0002w2-Py
	for linux-media@vger.kernel.org; Tue, 14 May 2013 11:37:50 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] v4l-utils: Fix satellite support in dvbv5-{scan,zap} tools
Date: Tue, 14 May 2013 11:23:50 +0200
Message-Id: <cover.1368522021.git.gmsoft@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi all,

These patches fix satellite support in current dvbv5-{scan,zap} tools by
fixing the parsing of the POLARIZATION parameter as well as applying those
parameters to the frontend.

This pathset is a broken down and improved version of the previous patch I send in
my mail "Fix POLARIZATION support for dvbv5-scan". Please disregard this previous patch.

  Guy


Guy Martin (5):
  libdvbv5: Remove buggy parsing of extra DTV_foo properties
  libdvbv5: Add parsing of POLARIZATION
  libdvbv5: Export dvb_fe_is_satellite()
  libdvbv5: Apply polarization parameters to the frontend
  dvbv5-zap: Copy satellite parameters before tuning
  dvbv5-scan:  Likewise

 lib/include/dvb-fe.h      |  3 ++-
 lib/include/dvb-file.h    |  2 +-
 lib/libdvbv5/dvb-fe.c     | 14 +++++------
 lib/libdvbv5/dvb-file.c   | 44 +++++++---------------------------
 lib/libdvbv5/dvb-sat.c    | 60 ++++++++++++++++++++---------------------------
 lib/libdvbv5/dvb-v5-std.c |  9 -------
 utils/dvb/dvbv5-scan.c    | 14 +++++++++++
 utils/dvb/dvbv5-zap.c     | 14 +++++++++++
 8 files changed, 72 insertions(+), 88 deletions(-)

-- 
1.8.1.5


