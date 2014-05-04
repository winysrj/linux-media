Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep19.mx.upcmail.net ([62.179.121.39]:63351 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaEDCJw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 May 2014 22:09:52 -0400
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: linux-media@vger.kernel.org,
	pkg-vdr-dvb-devel@lists.alioth.debian.org
Cc: Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH 0/6] [dvb-apps] Various dvb-apps fixes and enhancements
Date: Sun,  4 May 2014 02:51:15 +0100
Message-Id: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The following patch set contains various fixes and enhancements found
during the packaging of the next version of Debian's dvb-apps package.

A number of these patches have lived as Debian specific patches for a
long time, however, there is no reason not to upstream them for
everyone's benefit.

Jon

Jonathan McCrohan (6):
  dvb-apps: fix typos throughout the dvb-apps tree
  dvbscan: fix infinite loop parsing arguments
  dvb-apps: make zap flush stdout after status line
  dvb-apps: pass LDFLAGS to alevt and lib binaries
  alevt: fix FTBFS with libpng15
  dvb-apps: add man pages

 Make.rules                            |  5 ++-
 Makefile                              |  1 +
 lib/libdvben50221/en50221_transport.c |  4 +-
 lib/libdvbsec/dvbsec_cfg.h            |  2 +-
 man/Makefile                          | 13 ++++++
 man/atsc_epg.1                        | 35 +++++++++++++++
 man/av7110_loadkeys.1                 | 26 +++++++++++
 man/azap.1                            | 35 +++++++++++++++
 man/czap.1                            | 46 +++++++++++++++++++
 man/dib3000-watch.1                   | 34 ++++++++++++++
 man/dst_test.1                        | 41 +++++++++++++++++
 man/dvbdate.1                         | 38 ++++++++++++++++
 man/dvbnet.1                          | 38 ++++++++++++++++
 man/dvbscan.1                         | 72 +++++++++++++++++++++++++++++
 man/dvbtraffic.1                      | 26 +++++++++++
 man/femon.1                           | 32 +++++++++++++
 man/gnutv.1                           | 79 ++++++++++++++++++++++++++++++++
 man/gotox.1                           | 33 ++++++++++++++
 man/lsdvb.1                           |  9 ++++
 man/scan.1                            | 85 +++++++++++++++++++++++++++++++++++
 man/szap.1                            | 57 +++++++++++++++++++++++
 man/tzap.1                            | 56 +++++++++++++++++++++++
 man/zap.1                             | 44 ++++++++++++++++++
 util/alevt/Makefile                   |  6 +--
 util/alevt/exp-gfx.c                  |  3 +-
 util/dib3000-watch/dib3000-watch.c    |  2 +-
 util/dvbscan/dvbscan.c                |  3 +-
 util/scan/scan.c                      |  2 +-
 util/szap/czap.c                      |  3 +-
 util/szap/szap.c                      |  1 +
 30 files changed, 818 insertions(+), 13 deletions(-)
 create mode 100644 man/Makefile
 create mode 100644 man/atsc_epg.1
 create mode 100644 man/av7110_loadkeys.1
 create mode 100644 man/azap.1
 create mode 100644 man/czap.1
 create mode 100644 man/dib3000-watch.1
 create mode 100644 man/dst_test.1
 create mode 100644 man/dvbdate.1
 create mode 100644 man/dvbnet.1
 create mode 100644 man/dvbscan.1
 create mode 100644 man/dvbtraffic.1
 create mode 100644 man/femon.1
 create mode 100644 man/gnutv.1
 create mode 100644 man/gotox.1
 create mode 100644 man/lsdvb.1
 create mode 100644 man/scan.1
 create mode 100644 man/szap.1
 create mode 100644 man/tzap.1
 create mode 100644 man/zap.1

-- 
1.9.2

