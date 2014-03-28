Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:65364 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaC1Qnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 12:43:53 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so4258823eek.18
        for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 09:43:52 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH v2] libdvbv5: shared lib and installing headers
Date: Fri, 28 Mar 2014 17:42:49 +0100
Message-Id: <1396024969-7528-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- move headers to subdirectory for correct install location
- fix includes in dvb table and descriptor parsers
- fix compile warnings

Signed-off-by: André Roth <neolynx@gmail.com>
---
 README                                             |   6 +-
 README.libv4l                                      |  12 ++
 lib/include/{descriptors => libdvbv5}/atsc_eit.h   |   4 +-
 .../{descriptors => libdvbv5}/atsc_header.h        |   0
 .../desc_atsc_service_location.h                   |   0
 .../desc_cable_delivery.h                          |   0
 .../desc_event_extended.h                          |   0
 .../{descriptors => libdvbv5}/desc_event_short.h   |   0
 .../{descriptors => libdvbv5}/desc_extension.h     |   0
 .../desc_frequency_list.h                          |   0
 .../{descriptors => libdvbv5}/desc_hierarchy.h     |   0
 .../desc_isdbt_delivery.h                          |   0
 .../{descriptors => libdvbv5}/desc_language.h      |   0
 .../desc_logical_channel.h                         |   0
 .../{descriptors => libdvbv5}/desc_network_name.h  |   0
 .../desc_partial_reception.h                       |   0
 lib/include/{descriptors => libdvbv5}/desc_sat.h   |   0
 .../{descriptors => libdvbv5}/desc_service.h       |   0
 .../{descriptors => libdvbv5}/desc_service_list.h  |   0
 .../desc_service_location.h                        |   0
 .../{descriptors => libdvbv5}/desc_t2_delivery.h   |   0
 .../desc_terrestrial_delivery.h                    |   0
 .../{descriptors => libdvbv5}/desc_ts_info.h       |   0
 lib/include/{ => libdvbv5}/descriptors.h           |   0
 lib/include/{ => libdvbv5}/dvb-demux.h             |   0
 lib/include/{ => libdvbv5}/dvb-fe.h                |   0
 lib/include/{ => libdvbv5}/dvb-file.h              |   0
 lib/include/{ => libdvbv5}/dvb-frontend.h          |   0
 lib/include/{ => libdvbv5}/dvb-log.h               |   0
 lib/include/{ => libdvbv5}/dvb-sat.h               |   0
 lib/include/{ => libdvbv5}/dvb-scan.h              |   4 +-
 lib/include/{ => libdvbv5}/dvb-v5-std.h            |   0
 lib/include/{descriptors => libdvbv5}/eit.h        |   4 +-
 lib/include/{descriptors => libdvbv5}/header.h     |   0
 lib/include/{descriptors => libdvbv5}/mgt.h        |   4 +-
 lib/include/{descriptors => libdvbv5}/mpeg_es.h    |   0
 lib/include/{descriptors => libdvbv5}/mpeg_pes.h   |   0
 lib/include/{descriptors => libdvbv5}/mpeg_ts.h    |   0
 lib/include/{descriptors => libdvbv5}/nit.h        |   4 +-
 lib/include/{descriptors => libdvbv5}/pat.h        |   2 +-
 lib/include/{descriptors => libdvbv5}/pmt.h        |   2 +-
 lib/include/{descriptors => libdvbv5}/sdt.h        |   4 +-
 lib/include/{descriptors => libdvbv5}/vct.h        |   4 +-
 lib/libdvbv5/Makefile.am                           | 138 ++++++++++++++-------
 lib/libdvbv5/descriptors.c                         |  62 ++++-----
 lib/libdvbv5/descriptors/atsc_eit.c                |   4 +-
 lib/libdvbv5/descriptors/atsc_header.c             |   6 +-
 .../descriptors/desc_atsc_service_location.c       |   8 +-
 lib/libdvbv5/descriptors/desc_cable_delivery.c     |   6 +-
 lib/libdvbv5/descriptors/desc_event_extended.c     |   8 +-
 lib/libdvbv5/descriptors/desc_event_short.c        |   8 +-
 lib/libdvbv5/descriptors/desc_extension.c          |   8 +-
 lib/libdvbv5/descriptors/desc_frequency_list.c     |   6 +-
 lib/libdvbv5/descriptors/desc_hierarchy.c          |   6 +-
 lib/libdvbv5/descriptors/desc_isdbt_delivery.c     |   8 +-
 lib/libdvbv5/descriptors/desc_language.c           |   6 +-
 lib/libdvbv5/descriptors/desc_logical_channel.c    |   8 +-
 lib/libdvbv5/descriptors/desc_network_name.c       |   6 +-
 lib/libdvbv5/descriptors/desc_partial_reception.c  |   8 +-
 lib/libdvbv5/descriptors/desc_sat.c                |   6 +-
 lib/libdvbv5/descriptors/desc_service.c            |   8 +-
 lib/libdvbv5/descriptors/desc_service_list.c       |   6 +-
 lib/libdvbv5/descriptors/desc_service_location.c   |  11 +-
 lib/libdvbv5/descriptors/desc_t2_delivery.c        |   8 +-
 .../descriptors/desc_terrestrial_delivery.c        |   6 +-
 lib/libdvbv5/descriptors/desc_ts_info.c            |   8 +-
 lib/libdvbv5/descriptors/eit.c                     |   4 +-
 lib/libdvbv5/descriptors/header.c                  |   6 +-
 lib/libdvbv5/descriptors/mgt.c                     |   4 +-
 lib/libdvbv5/descriptors/mpeg_es.c                 |   6 +-
 lib/libdvbv5/descriptors/mpeg_pes.c                |   6 +-
 lib/libdvbv5/descriptors/mpeg_ts.c                 |   6 +-
 lib/libdvbv5/descriptors/nit.c                     |   4 +-
 lib/libdvbv5/descriptors/pat.c                     |   6 +-
 lib/libdvbv5/descriptors/pmt.c                     |   6 +-
 lib/libdvbv5/descriptors/sdt.c                     |   4 +-
 lib/libdvbv5/descriptors/vct.c                     |   6 +-
 lib/libdvbv5/dvb-demux.c                           |   2 +-
 lib/libdvbv5/dvb-fe.c                              |   4 +-
 lib/libdvbv5/dvb-file.c                            |  48 +++----
 lib/libdvbv5/dvb-legacy-channel-format.c           |   4 +-
 lib/libdvbv5/dvb-log.c                             |   2 +-
 lib/libdvbv5/dvb-sat.c                             |   4 +-
 lib/libdvbv5/dvb-scan.c                            |  44 +++----
 lib/libdvbv5/dvb-v5-std.c                          |   2 +-
 lib/libdvbv5/dvb-v5.h                              |   2 +-
 lib/libdvbv5/dvb-zap-format.c                      |   4 +-
 lib/libdvbv5/gen_dvb_structs.pl                    |   4 +-
 lib/libdvbv5/parse_string.c                        |   4 +-
 utils/dvb/dvb-fe-tool.c                            |   2 +-
 utils/dvb/dvb-format-convert.c                     |   6 +-
 utils/dvb/dvbv5-scan.c                             |   8 +-
 utils/dvb/dvbv5-zap.c                              |   8 +-
 93 files changed, 332 insertions(+), 273 deletions(-)
 rename lib/include/{descriptors => libdvbv5}/atsc_eit.h (97%)
 rename lib/include/{descriptors => libdvbv5}/atsc_header.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_atsc_service_location.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_cable_delivery.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_event_extended.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_event_short.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_extension.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_frequency_list.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_hierarchy.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_isdbt_delivery.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_language.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_logical_channel.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_network_name.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_partial_reception.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_sat.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_service.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_service_list.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_service_location.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_t2_delivery.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_terrestrial_delivery.h (100%)
 rename lib/include/{descriptors => libdvbv5}/desc_ts_info.h (100%)
 rename lib/include/{ => libdvbv5}/descriptors.h (100%)
 rename lib/include/{ => libdvbv5}/dvb-demux.h (100%)
 rename lib/include/{ => libdvbv5}/dvb-fe.h (100%)
 rename lib/include/{ => libdvbv5}/dvb-file.h (100%)
 rename lib/include/{ => libdvbv5}/dvb-frontend.h (100%)
 rename lib/include/{ => libdvbv5}/dvb-log.h (100%)
 rename lib/include/{ => libdvbv5}/dvb-sat.h (100%)
 rename lib/include/{ => libdvbv5}/dvb-scan.h (98%)
 rename lib/include/{ => libdvbv5}/dvb-v5-std.h (100%)
 rename lib/include/{descriptors => libdvbv5}/eit.h (97%)
 rename lib/include/{descriptors => libdvbv5}/header.h (100%)
 rename lib/include/{descriptors => libdvbv5}/mgt.h (96%)
 rename lib/include/{descriptors => libdvbv5}/mpeg_es.h (100%)
 rename lib/include/{descriptors => libdvbv5}/mpeg_pes.h (100%)
 rename lib/include/{descriptors => libdvbv5}/mpeg_ts.h (100%)
 rename lib/include/{descriptors => libdvbv5}/nit.h (97%)
 rename lib/include/{descriptors => libdvbv5}/pat.h (98%)
 rename lib/include/{descriptors => libdvbv5}/pmt.h (99%)
 rename lib/include/{descriptors => libdvbv5}/sdt.h (97%)
 rename lib/include/{descriptors => libdvbv5}/vct.h (97%)

diff --git a/README b/README
index c4f6c0c..a9f8089 100644
--- a/README
+++ b/README
@@ -3,11 +3,11 @@ v4l-utils
 
 Linux V4L2 and DVB API utilities and v4l libraries (libv4l).
 You can always find the latest development v4l-utils in the git repo:
-http://git.linuxtv.org/v4l-utils.git 
+http://git.linuxtv.org/v4l-utils.git
 
 
-v4l libraries (libv4l)
-----------------------
+v4l libraries (libv4l, libdvbv5)
+--------------------------------
 
 See README.libv4l for more information on libv4l, libv4l is released
 under the GNU Lesser General Public License.
diff --git a/README.libv4l b/README.libv4l
index ffe6366..d101c2c 100644
--- a/README.libv4l
+++ b/README.libv4l
@@ -59,6 +59,18 @@ hardware can _really_ do it should use ENUM_FMT, not randomly try a bunch of
 S_FMT's). For more details on the v4l2_ functions see libv4l2.h .
 
 
+libdvbv5
+--------
+
+This library provides the DVBv5 API to userspace programs. It can be used to
+open DVB adapters, tune transponders and read PES and other data streams.
+There are as well several parsers for DVB, ATSC, ISBT formats.
+
+The API is currently EXPERIMENTAL and likely to change.
+Run configure with --enable-libdvbv5 in order to build a shared lib and
+install the header files.
+
+
 wrappers
 --------
 
diff --git a/lib/include/descriptors/atsc_eit.h b/lib/include/libdvbv5/atsc_eit.h
similarity index 97%
rename from lib/include/descriptors/atsc_eit.h
rename to lib/include/libdvbv5/atsc_eit.h
index 3bc5df6..0c0d830 100644
--- a/lib/include/descriptors/atsc_eit.h
+++ b/lib/include/libdvbv5/atsc_eit.h
@@ -25,8 +25,8 @@
 #include <unistd.h> /* ssize_t */
 #include <time.h>
 
-#include "descriptors/atsc_header.h"
-#include "descriptors.h"
+#include <libdvbv5/atsc_header.h>
+#include <libdvbv5/descriptors.h>
 
 #define ATSC_TABLE_EIT        0xCB
 
diff --git a/lib/include/descriptors/atsc_header.h b/lib/include/libdvbv5/atsc_header.h
similarity index 100%
rename from lib/include/descriptors/atsc_header.h
rename to lib/include/libdvbv5/atsc_header.h
diff --git a/lib/include/descriptors/desc_atsc_service_location.h b/lib/include/libdvbv5/desc_atsc_service_location.h
similarity index 100%
rename from lib/include/descriptors/desc_atsc_service_location.h
rename to lib/include/libdvbv5/desc_atsc_service_location.h
diff --git a/lib/include/descriptors/desc_cable_delivery.h b/lib/include/libdvbv5/desc_cable_delivery.h
similarity index 100%
rename from lib/include/descriptors/desc_cable_delivery.h
rename to lib/include/libdvbv5/desc_cable_delivery.h
diff --git a/lib/include/descriptors/desc_event_extended.h b/lib/include/libdvbv5/desc_event_extended.h
similarity index 100%
rename from lib/include/descriptors/desc_event_extended.h
rename to lib/include/libdvbv5/desc_event_extended.h
diff --git a/lib/include/descriptors/desc_event_short.h b/lib/include/libdvbv5/desc_event_short.h
similarity index 100%
rename from lib/include/descriptors/desc_event_short.h
rename to lib/include/libdvbv5/desc_event_short.h
diff --git a/lib/include/descriptors/desc_extension.h b/lib/include/libdvbv5/desc_extension.h
similarity index 100%
rename from lib/include/descriptors/desc_extension.h
rename to lib/include/libdvbv5/desc_extension.h
diff --git a/lib/include/descriptors/desc_frequency_list.h b/lib/include/libdvbv5/desc_frequency_list.h
similarity index 100%
rename from lib/include/descriptors/desc_frequency_list.h
rename to lib/include/libdvbv5/desc_frequency_list.h
diff --git a/lib/include/descriptors/desc_hierarchy.h b/lib/include/libdvbv5/desc_hierarchy.h
similarity index 100%
rename from lib/include/descriptors/desc_hierarchy.h
rename to lib/include/libdvbv5/desc_hierarchy.h
diff --git a/lib/include/descriptors/desc_isdbt_delivery.h b/lib/include/libdvbv5/desc_isdbt_delivery.h
similarity index 100%
rename from lib/include/descriptors/desc_isdbt_delivery.h
rename to lib/include/libdvbv5/desc_isdbt_delivery.h
diff --git a/lib/include/descriptors/desc_language.h b/lib/include/libdvbv5/desc_language.h
similarity index 100%
rename from lib/include/descriptors/desc_language.h
rename to lib/include/libdvbv5/desc_language.h
diff --git a/lib/include/descriptors/desc_logical_channel.h b/lib/include/libdvbv5/desc_logical_channel.h
similarity index 100%
rename from lib/include/descriptors/desc_logical_channel.h
rename to lib/include/libdvbv5/desc_logical_channel.h
diff --git a/lib/include/descriptors/desc_network_name.h b/lib/include/libdvbv5/desc_network_name.h
similarity index 100%
rename from lib/include/descriptors/desc_network_name.h
rename to lib/include/libdvbv5/desc_network_name.h
diff --git a/lib/include/descriptors/desc_partial_reception.h b/lib/include/libdvbv5/desc_partial_reception.h
similarity index 100%
rename from lib/include/descriptors/desc_partial_reception.h
rename to lib/include/libdvbv5/desc_partial_reception.h
diff --git a/lib/include/descriptors/desc_sat.h b/lib/include/libdvbv5/desc_sat.h
similarity index 100%
rename from lib/include/descriptors/desc_sat.h
rename to lib/include/libdvbv5/desc_sat.h
diff --git a/lib/include/descriptors/desc_service.h b/lib/include/libdvbv5/desc_service.h
similarity index 100%
rename from lib/include/descriptors/desc_service.h
rename to lib/include/libdvbv5/desc_service.h
diff --git a/lib/include/descriptors/desc_service_list.h b/lib/include/libdvbv5/desc_service_list.h
similarity index 100%
rename from lib/include/descriptors/desc_service_list.h
rename to lib/include/libdvbv5/desc_service_list.h
diff --git a/lib/include/descriptors/desc_service_location.h b/lib/include/libdvbv5/desc_service_location.h
similarity index 100%
rename from lib/include/descriptors/desc_service_location.h
rename to lib/include/libdvbv5/desc_service_location.h
diff --git a/lib/include/descriptors/desc_t2_delivery.h b/lib/include/libdvbv5/desc_t2_delivery.h
similarity index 100%
rename from lib/include/descriptors/desc_t2_delivery.h
rename to lib/include/libdvbv5/desc_t2_delivery.h
diff --git a/lib/include/descriptors/desc_terrestrial_delivery.h b/lib/include/libdvbv5/desc_terrestrial_delivery.h
similarity index 100%
rename from lib/include/descriptors/desc_terrestrial_delivery.h
rename to lib/include/libdvbv5/desc_terrestrial_delivery.h
diff --git a/lib/include/descriptors/desc_ts_info.h b/lib/include/libdvbv5/desc_ts_info.h
similarity index 100%
rename from lib/include/descriptors/desc_ts_info.h
rename to lib/include/libdvbv5/desc_ts_info.h
diff --git a/lib/include/descriptors.h b/lib/include/libdvbv5/descriptors.h
similarity index 100%
rename from lib/include/descriptors.h
rename to lib/include/libdvbv5/descriptors.h
diff --git a/lib/include/dvb-demux.h b/lib/include/libdvbv5/dvb-demux.h
similarity index 100%
rename from lib/include/dvb-demux.h
rename to lib/include/libdvbv5/dvb-demux.h
diff --git a/lib/include/dvb-fe.h b/lib/include/libdvbv5/dvb-fe.h
similarity index 100%
rename from lib/include/dvb-fe.h
rename to lib/include/libdvbv5/dvb-fe.h
diff --git a/lib/include/dvb-file.h b/lib/include/libdvbv5/dvb-file.h
similarity index 100%
rename from lib/include/dvb-file.h
rename to lib/include/libdvbv5/dvb-file.h
diff --git a/lib/include/dvb-frontend.h b/lib/include/libdvbv5/dvb-frontend.h
similarity index 100%
rename from lib/include/dvb-frontend.h
rename to lib/include/libdvbv5/dvb-frontend.h
diff --git a/lib/include/dvb-log.h b/lib/include/libdvbv5/dvb-log.h
similarity index 100%
rename from lib/include/dvb-log.h
rename to lib/include/libdvbv5/dvb-log.h
diff --git a/lib/include/dvb-sat.h b/lib/include/libdvbv5/dvb-sat.h
similarity index 100%
rename from lib/include/dvb-sat.h
rename to lib/include/libdvbv5/dvb-sat.h
diff --git a/lib/include/dvb-scan.h b/lib/include/libdvbv5/dvb-scan.h
similarity index 98%
rename from lib/include/dvb-scan.h
rename to lib/include/libdvbv5/dvb-scan.h
index 2a3a58f..9c47c95 100644
--- a/lib/include/dvb-scan.h
+++ b/lib/include/libdvbv5/dvb-scan.h
@@ -22,9 +22,9 @@
 #include <stdint.h>
 #include <linux/dvb/dmx.h>
 
-#include "descriptors.h"
+#include <libdvbv5/descriptors.h>
 
-#include "dvb-sat.h"
+#include <libdvbv5/dvb-sat.h>
 
 /* According with ISO/IEC 13818-1:2007 */
 
diff --git a/lib/include/dvb-v5-std.h b/lib/include/libdvbv5/dvb-v5-std.h
similarity index 100%
rename from lib/include/dvb-v5-std.h
rename to lib/include/libdvbv5/dvb-v5-std.h
diff --git a/lib/include/descriptors/eit.h b/lib/include/libdvbv5/eit.h
similarity index 97%
rename from lib/include/descriptors/eit.h
rename to lib/include/libdvbv5/eit.h
index e0ecee3..62e070d 100644
--- a/lib/include/descriptors/eit.h
+++ b/lib/include/libdvbv5/eit.h
@@ -26,8 +26,8 @@
 #include <unistd.h> /* ssize_t */
 #include <time.h>
 
-#include "descriptors/header.h"
-#include "descriptors.h"
+#include <libdvbv5/header.h>
+#include <libdvbv5/descriptors.h>
 
 #define DVB_TABLE_EIT        0x4E
 #define DVB_TABLE_EIT_OTHER  0x4F
diff --git a/lib/include/descriptors/header.h b/lib/include/libdvbv5/header.h
similarity index 100%
rename from lib/include/descriptors/header.h
rename to lib/include/libdvbv5/header.h
diff --git a/lib/include/descriptors/mgt.h b/lib/include/libdvbv5/mgt.h
similarity index 96%
rename from lib/include/descriptors/mgt.h
rename to lib/include/libdvbv5/mgt.h
index 9c583b4..346cbb5 100644
--- a/lib/include/descriptors/mgt.h
+++ b/lib/include/libdvbv5/mgt.h
@@ -24,8 +24,8 @@
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
 
-#include "descriptors/atsc_header.h"
-#include "descriptors.h"
+#include <libdvbv5/atsc_header.h>
+#include <libdvbv5/descriptors.h>
 
 #define ATSC_TABLE_MGT 0xC7
 
diff --git a/lib/include/descriptors/mpeg_es.h b/lib/include/libdvbv5/mpeg_es.h
similarity index 100%
rename from lib/include/descriptors/mpeg_es.h
rename to lib/include/libdvbv5/mpeg_es.h
diff --git a/lib/include/descriptors/mpeg_pes.h b/lib/include/libdvbv5/mpeg_pes.h
similarity index 100%
rename from lib/include/descriptors/mpeg_pes.h
rename to lib/include/libdvbv5/mpeg_pes.h
diff --git a/lib/include/descriptors/mpeg_ts.h b/lib/include/libdvbv5/mpeg_ts.h
similarity index 100%
rename from lib/include/descriptors/mpeg_ts.h
rename to lib/include/libdvbv5/mpeg_ts.h
diff --git a/lib/include/descriptors/nit.h b/lib/include/libdvbv5/nit.h
similarity index 97%
rename from lib/include/descriptors/nit.h
rename to lib/include/libdvbv5/nit.h
index 52bdc6a..a2c4950 100644
--- a/lib/include/descriptors/nit.h
+++ b/lib/include/libdvbv5/nit.h
@@ -25,8 +25,8 @@
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
 
-#include "descriptors/header.h"
-#include "descriptors.h"
+#include <libdvbv5/header.h>
+#include <libdvbv5/descriptors.h>
 
 #define DVB_TABLE_NIT      0x40
 #define DVB_TABLE_NIT2     0x41
diff --git a/lib/include/descriptors/pat.h b/lib/include/libdvbv5/pat.h
similarity index 98%
rename from lib/include/descriptors/pat.h
rename to lib/include/libdvbv5/pat.h
index 1f74741..a3f9b30 100644
--- a/lib/include/descriptors/pat.h
+++ b/lib/include/libdvbv5/pat.h
@@ -25,7 +25,7 @@
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
 
-#include "descriptors/header.h"
+#include <libdvbv5/header.h>
 
 #define DVB_TABLE_PAT      0
 #define DVB_TABLE_PAT_PID  0
diff --git a/lib/include/descriptors/pmt.h b/lib/include/libdvbv5/pmt.h
similarity index 99%
rename from lib/include/descriptors/pmt.h
rename to lib/include/libdvbv5/pmt.h
index 0ca8210..59debf0 100644
--- a/lib/include/descriptors/pmt.h
+++ b/lib/include/libdvbv5/pmt.h
@@ -25,7 +25,7 @@
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
 
-#include "descriptors/header.h"
+#include <libdvbv5/header.h>
 
 #define DVB_TABLE_PMT      2
 
diff --git a/lib/include/descriptors/sdt.h b/lib/include/libdvbv5/sdt.h
similarity index 97%
rename from lib/include/descriptors/sdt.h
rename to lib/include/libdvbv5/sdt.h
index 9d27bd4..3d5b1d7 100644
--- a/lib/include/descriptors/sdt.h
+++ b/lib/include/libdvbv5/sdt.h
@@ -25,8 +25,8 @@
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
 
-#include "descriptors/header.h"
-#include "descriptors.h"
+#include <libdvbv5/header.h>
+#include <libdvbv5/descriptors.h>
 
 #define DVB_TABLE_SDT      0x42
 #define DVB_TABLE_SDT2     0x46
diff --git a/lib/include/descriptors/vct.h b/lib/include/libdvbv5/vct.h
similarity index 97%
rename from lib/include/descriptors/vct.h
rename to lib/include/libdvbv5/vct.h
index bb3250f..8044af1 100644
--- a/lib/include/descriptors/vct.h
+++ b/lib/include/libdvbv5/vct.h
@@ -25,8 +25,8 @@
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
 
-#include "descriptors/atsc_header.h"
-#include "descriptors.h"
+#include <libdvbv5/atsc_header.h>
+#include <libdvbv5/descriptors.h>
 
 #define ATSC_TABLE_TVCT     0xc8
 #define ATSC_TABLE_CVCT     0xc9
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index c6d2a42..ddf9ea1 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -1,8 +1,50 @@
 if WITH_LIBDVBV5
 lib_LTLIBRARIES = libdvbv5.la
-include_HEADERS = ../include/dvb-demux.h ../include/dvb-v5-std.h \
-  ../include/dvb-file.h ../include/dvb-frontend.h ../include/dvb-fe.h \
-  ../include/dvb-sat.h ../include/dvb-scan.h
+
+otherincludedir = $(includedir)/libdvbv5
+otherinclude_HEADERS = \
+	../include/libdvbv5/dvb-demux.h \
+	../include/libdvbv5/dvb-v5-std.h \
+	../include/libdvbv5/dvb-file.h \
+	../include/libdvbv5/dvb-frontend.h \
+	../include/libdvbv5/dvb-fe.h \
+	../include/libdvbv5/dvb-sat.h \
+	../include/libdvbv5/dvb-scan.h \
+	../include/libdvbv5/dvb-log.h \
+	../include/libdvbv5/descriptors.h \
+	../include/libdvbv5/header.h \
+	../include/libdvbv5/pat.h \
+	../include/libdvbv5/pmt.h \
+	../include/libdvbv5/desc_language.h \
+	../include/libdvbv5/desc_network_name.h \
+	../include/libdvbv5/desc_cable_delivery.h \
+	../include/libdvbv5/desc_sat.h \
+	../include/libdvbv5/desc_terrestrial_delivery.h \
+	../include/libdvbv5/desc_t2_delivery.h \
+	../include/libdvbv5/desc_service.h \
+	../include/libdvbv5/desc_frequency_list.h \
+	../include/libdvbv5/desc_service_list.h \
+	../include/libdvbv5/desc_event_short.h \
+	../include/libdvbv5/desc_event_extended.h \
+	../include/libdvbv5/desc_atsc_service_location.h \
+	../include/libdvbv5/desc_hierarchy.h \
+	../include/libdvbv5/desc_extension.h \
+	../include/libdvbv5/desc_isdbt_delivery.h \
+	../include/libdvbv5/desc_logical_channel.h \
+	../include/libdvbv5/desc_ts_info.h \
+	../include/libdvbv5/desc_partial_reception.h \
+	../include/libdvbv5/nit.h \
+	../include/libdvbv5/sdt.h \
+	../include/libdvbv5/vct.h \
+	../include/libdvbv5/atsc_header.h \
+	../include/libdvbv5/mgt.h \
+	../include/libdvbv5/eit.h \
+	../include/libdvbv5/atsc_eit.h \
+	../include/libdvbv5/desc_service_location.h \
+	../include/libdvbv5/mpeg_ts.h \
+	../include/libdvbv5/mpeg_pes.h \
+	../include/libdvbv5/mpeg_es.h
+
 pkgconfig_DATA = libdvbv5.pc
 LIBDVBV5_VERSION = -version-info 0
 else
@@ -10,50 +52,54 @@ noinst_LTLIBRARIES = libdvbv5.la
 endif
 
 libdvbv5_la_SOURCES = \
-  dvb-demux.c ../include/dvb-demux.h \
-  dvb-fe.c ../include/dvb-fe.h \
-  dvb-log.c ../include/dvb-log.h \
-  dvb-file.c ../include/dvb-file.h \
-  ../include/dvb-frontend.h \
-  dvb-v5.h dvb-v5.c \
-  ../include/dvb-v5-std.h dvb-v5-std.c \
-  dvb-legacy-channel-format.c \
-  dvb-zap-format.c \
-  dvb-sat.c ../include/dvb-sat.h \
-  dvb-scan.c ../include/dvb-scan.h \
-  parse_string.c parse_string.h \
-  crc32.c crc32.h \
-  descriptors.c ../include/descriptors.h \
-  descriptors/header.c ../include/descriptors/header.h \
-  descriptors/pat.c  ../include/descriptors/pat.h \
-  descriptors/pmt.c  ../include/descriptors/pmt.h \
-  descriptors/desc_language.c  ../include/descriptors/desc_language.h \
-  descriptors/desc_network_name.c  ../include/descriptors/desc_network_name.h \
-  descriptors/desc_cable_delivery.c  ../include/descriptors/desc_cable_delivery.h \
-  descriptors/desc_sat.c  ../include/descriptors/desc_sat.h \
-  descriptors/desc_terrestrial_delivery.c  ../include/descriptors/desc_terrestrial_delivery.h \
-  descriptors/desc_t2_delivery.c  ../include/descriptors/desc_t2_delivery.h \
-  descriptors/desc_service.c  ../include/descriptors/desc_service.h \
-  descriptors/desc_frequency_list.c  ../include/descriptors/desc_frequency_list.h \
-  descriptors/desc_service_list.c  ../include/descriptors/desc_service_list.h \
-  descriptors/desc_event_short.c  ../include/descriptors/desc_event_short.h \
-  descriptors/desc_event_extended.c  ../include/descriptors/desc_event_extended.h \
-  descriptors/desc_atsc_service_location.c ../include/descriptors/desc_atsc_service_location.h \
-  descriptors/desc_hierarchy.c  ../include/descriptors/desc_hierarchy.h \
-  descriptors/desc_extension.c  ../include/descriptors/desc_extension.h \
-  descriptors/desc_isdbt_delivery.c  ../include/descriptors/desc_isdbt_delivery.h \
-  descriptors/desc_logical_channel.c  ../include/descriptors/desc_logical_channel.h \
-  descriptors/desc_ts_info.c  ../include/descriptors/desc_ts_info.h \
-  descriptors/desc_partial_reception.c  ../include/descriptors/desc_partial_reception.h \
-  descriptors/nit.c  ../include/descriptors/nit.h \
-  descriptors/sdt.c  ../include/descriptors/sdt.h \
-  descriptors/vct.c  ../include/descriptors/vct.h \
-  descriptors/atsc_header.c ../include/descriptors/atsc_header.h \
-  descriptors/mgt.c  ../include/descriptors/mgt.h \
-  descriptors/eit.c  ../include/descriptors/eit.h \
-  descriptors/atsc_eit.c  ../include/descriptors/atsc_eit.h
+	crc32.c crc32.h \
+	../include/dvb-frontend.h \
+	dvb-legacy-channel-format.c \
+	dvb-zap-format.c \
+	dvb-v5.c	dvb-v5.h \
+	parse_string.c	parse_string.h \
+	dvb-demux.c	../include/dvb-demux.h \
+	dvb-fe.c	../include/dvb-fe.h \
+	dvb-log.c	../include/dvb-log.h \
+	dvb-file.c	../include/dvb-file.h \
+	dvb-v5-std.c	../include/dvb-v5-std.h \
+	dvb-sat.c	../include/dvb-sat.h \
+	dvb-scan.c	../include/dvb-scan.h \
+	descriptors.c	../include/descriptors.h \
+	descriptors/header.c		../include/libdvbv5/header.h \
+	descriptors/atsc_header.c	../include/libdvbv5/atsc_header.h \
+	descriptors/pat.c		../include/libdvbv5/pat.h \
+	descriptors/pmt.c		../include/libdvbv5/pmt.h \
+	descriptors/nit.c		../include/libdvbv5/nit.h \
+	descriptors/sdt.c		../include/libdvbv5/sdt.h \
+	descriptors/vct.c		../include/libdvbv5/vct.h \
+	descriptors/mgt.c		../include/libdvbv5/mgt.h \
+	descriptors/eit.c		../include/libdvbv5/eit.h \
+	descriptors/atsc_eit.c		../include/libdvbv5/atsc_eit.h \
+	descriptors/desc_language.c		../include/libdvbv5/desc_language.h \
+	descriptors/desc_network_name.c		../include/libdvbv5/desc_network_name.h \
+	descriptors/desc_cable_delivery.c	../include/libdvbv5/desc_cable_delivery.h \
+	descriptors/desc_sat.c			../include/libdvbv5/desc_sat.h \
+	descriptors/desc_terrestrial_delivery.c  ../include/libdvbv5/desc_terrestrial_delivery.h \
+	descriptors/desc_t2_delivery.c		../include/libdvbv5/desc_t2_delivery.h \
+	descriptors/desc_service.c		../include/libdvbv5/desc_service.h \
+	descriptors/desc_frequency_list.c	../include/libdvbv5/desc_frequency_list.h \
+	descriptors/desc_service_list.c		../include/libdvbv5/desc_service_list.h \
+	descriptors/desc_event_short.c		../include/libdvbv5/desc_event_short.h \
+	descriptors/desc_event_extended.c	../include/libdvbv5/desc_event_extended.h \
+	descriptors/desc_atsc_service_location.c ../include/libdvbv5/desc_atsc_service_location.h \
+	descriptors/desc_hierarchy.c		../include/libdvbv5/desc_hierarchy.h \
+	descriptors/desc_extension.c		../include/libdvbv5/desc_extension.h \
+	descriptors/desc_isdbt_delivery.c	../include/libdvbv5/desc_isdbt_delivery.h \
+	descriptors/desc_logical_channel.c	../include/libdvbv5/desc_logical_channel.h \
+	descriptors/desc_ts_info.c		../include/libdvbv5/desc_ts_info.h \
+	descriptors/desc_partial_reception.c	../include/libdvbv5/desc_partial_reception.h \
+	descriptors/desc_service_location.c	../include/libdvbv5/desc_service_location.h \
+	descriptors/mpeg_ts.c		../include/libdvbv5/mpeg_ts.h \
+	descriptors/mpeg_pes.c		../include/libdvbv5/mpeg_pes.h \
+	descriptors/mpeg_es.c		../include/libdvbv5/mpeg_es.h
 
-libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC)
+libdvbv5_la_CPPFLAGS = -I../.. $(ENFORCE_LIBDVBV5_STATIC)
 libdvbv5_la_LDFLAGS = $(LIBDVBV5_VERSION) $(ENFORCE_LIBDVBV5_STATIC) -lm
 libdvbv5_la_LIBADD = $(LTLIBICONV)
 
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 92ebc54..91cc4a6 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -22,39 +22,39 @@
 #include <stdlib.h>
 #include <stdio.h>
 
-#include "descriptors.h"
-#include "dvb-fe.h"
-#include "dvb-scan.h"
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
+#include <libdvbv5/dvb-scan.h>
 #include "parse_string.h"
-#include "dvb-frontend.h"
-#include "dvb-v5-std.h"
-#include "dvb-log.h"
+#include <libdvbv5/dvb-frontend.h>
+#include <libdvbv5/dvb-v5-std.h>
+#include <libdvbv5/dvb-log.h>
 
-#include "descriptors/pat.h"
-#include "descriptors/pmt.h"
-#include "descriptors/nit.h"
-#include "descriptors/sdt.h"
-#include "descriptors/eit.h"
-#include "descriptors/vct.h"
-#include "descriptors/mgt.h"
-#include "descriptors/atsc_eit.h"
-#include "descriptors/desc_language.h"
-#include "descriptors/desc_network_name.h"
-#include "descriptors/desc_cable_delivery.h"
-#include "descriptors/desc_sat.h"
-#include "descriptors/desc_terrestrial_delivery.h"
-#include "descriptors/desc_isdbt_delivery.h"
-#include "descriptors/desc_service.h"
-#include "descriptors/desc_service_list.h"
-#include "descriptors/desc_frequency_list.h"
-#include "descriptors/desc_event_short.h"
-#include "descriptors/desc_event_extended.h"
-#include "descriptors/desc_atsc_service_location.h"
-#include "descriptors/desc_hierarchy.h"
-#include "descriptors/desc_ts_info.h"
-#include "descriptors/desc_logical_channel.h"
-#include "descriptors/desc_partial_reception.h"
-#include "descriptors/desc_extension.h"
+#include <libdvbv5/pat.h>
+#include <libdvbv5/pmt.h>
+#include <libdvbv5/nit.h>
+#include <libdvbv5/sdt.h>
+#include <libdvbv5/eit.h>
+#include <libdvbv5/vct.h>
+#include <libdvbv5/mgt.h>
+#include <libdvbv5/atsc_eit.h>
+#include <libdvbv5/desc_language.h>
+#include <libdvbv5/desc_network_name.h>
+#include <libdvbv5/desc_cable_delivery.h>
+#include <libdvbv5/desc_sat.h>
+#include <libdvbv5/desc_terrestrial_delivery.h>
+#include <libdvbv5/desc_isdbt_delivery.h>
+#include <libdvbv5/desc_service.h>
+#include <libdvbv5/desc_service_list.h>
+#include <libdvbv5/desc_frequency_list.h>
+#include <libdvbv5/desc_event_short.h>
+#include <libdvbv5/desc_event_extended.h>
+#include <libdvbv5/desc_atsc_service_location.h>
+#include <libdvbv5/desc_hierarchy.h>
+#include <libdvbv5/desc_ts_info.h>
+#include <libdvbv5/desc_logical_channel.h>
+#include <libdvbv5/desc_partial_reception.h>
+#include <libdvbv5/desc_extension.h>
 
 ssize_t dvb_desc_init(const uint8_t *buf, struct dvb_desc *desc)
 {
diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
index f8afc76..86a7b11 100644
--- a/lib/libdvbv5/descriptors/atsc_eit.c
+++ b/lib/libdvbv5/descriptors/atsc_eit.c
@@ -18,8 +18,8 @@
  *
  */
 
-#include "descriptors/atsc_eit.h"
-#include "dvb-fe.h"
+#include <libdvbv5/atsc_eit.h>
+#include <libdvbv5/dvb-fe.h>
 
 void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
diff --git a/lib/libdvbv5/descriptors/atsc_header.c b/lib/libdvbv5/descriptors/atsc_header.c
index ed152ce..06d1bb1 100644
--- a/lib/libdvbv5/descriptors/atsc_header.c
+++ b/lib/libdvbv5/descriptors/atsc_header.c
@@ -18,9 +18,9 @@
  *
  */
 
-#include "descriptors/atsc_header.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/atsc_header.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 int atsc_table_header_init(struct atsc_table_header *t)
 {
diff --git a/lib/libdvbv5/descriptors/desc_atsc_service_location.c b/lib/libdvbv5/descriptors/desc_atsc_service_location.c
index 5779ff0..5e3f461 100644
--- a/lib/libdvbv5/descriptors/desc_atsc_service_location.c
+++ b/lib/libdvbv5/descriptors/desc_atsc_service_location.c
@@ -18,9 +18,9 @@
  *
  */
 
-#include "descriptors.h"
-#include "descriptors/desc_atsc_service_location.h"
-#include "dvb-fe.h"
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/desc_atsc_service_location.h>
+#include <libdvbv5/dvb-fe.h>
 
 void atsc_desc_service_location_init(struct dvb_v5_fe_parms *parms,
 				     const uint8_t *buf, struct dvb_desc *desc)
@@ -84,4 +84,4 @@ void atsc_desc_service_location_free(struct dvb_desc *desc)
 
 	if (s_loc->elementary)
 		free(s_loc->elementary);
-}
\ No newline at end of file
+}
diff --git a/lib/libdvbv5/descriptors/desc_cable_delivery.c b/lib/libdvbv5/descriptors/desc_cable_delivery.c
index 3494b14..2cfc679 100644
--- a/lib/libdvbv5/descriptors/desc_cable_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_cable_delivery.c
@@ -20,9 +20,9 @@
  * Described at ETSI EN 300 468 V1.11.1 (2010-04)
  */
 
-#include "descriptors/desc_cable_delivery.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/desc_cable_delivery.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
diff --git a/lib/libdvbv5/descriptors/desc_event_extended.c b/lib/libdvbv5/descriptors/desc_event_extended.c
index 89ad840..51c7d2b 100644
--- a/lib/libdvbv5/descriptors/desc_event_extended.c
+++ b/lib/libdvbv5/descriptors/desc_event_extended.c
@@ -19,10 +19,10 @@
  *
  */
 
-#include "descriptors/desc_event_extended.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
-#include "parse_string.h"
+#include <libdvbv5/desc_event_extended.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
+#include <parse_string.h>
 
 void dvb_desc_event_extended_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
diff --git a/lib/libdvbv5/descriptors/desc_event_short.c b/lib/libdvbv5/descriptors/desc_event_short.c
index d0fdaeb..8525579 100644
--- a/lib/libdvbv5/descriptors/desc_event_short.c
+++ b/lib/libdvbv5/descriptors/desc_event_short.c
@@ -19,10 +19,10 @@
  *
  */
 
-#include "descriptors/desc_event_short.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
-#include "parse_string.h"
+#include <libdvbv5/desc_event_short.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
+#include <parse_string.h>
 
 void dvb_desc_event_short_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
diff --git a/lib/libdvbv5/descriptors/desc_extension.c b/lib/libdvbv5/descriptors/desc_extension.c
index 63715aa..400372f 100644
--- a/lib/libdvbv5/descriptors/desc_extension.c
+++ b/lib/libdvbv5/descriptors/desc_extension.c
@@ -18,10 +18,10 @@
  *
  */
 
-#include "descriptors.h"
-#include "descriptors/desc_extension.h"
-#include "descriptors/desc_t2_delivery.h"
-#include "dvb-fe.h"
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/desc_extension.h>
+#include <libdvbv5/desc_t2_delivery.h>
+#include <libdvbv5/dvb-fe.h>
 
 const struct dvb_ext_descriptor dvb_ext_descriptors[] = {
 	[0 ...255 ] = {
diff --git a/lib/libdvbv5/descriptors/desc_frequency_list.c b/lib/libdvbv5/descriptors/desc_frequency_list.c
index b39f61c..9a911a3 100644
--- a/lib/libdvbv5/descriptors/desc_frequency_list.c
+++ b/lib/libdvbv5/descriptors/desc_frequency_list.c
@@ -19,9 +19,9 @@
  *
  */
 
-#include "descriptors/desc_frequency_list.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/desc_frequency_list.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
diff --git a/lib/libdvbv5/descriptors/desc_hierarchy.c b/lib/libdvbv5/descriptors/desc_hierarchy.c
index 37e6d6e..b6e0adc 100644
--- a/lib/libdvbv5/descriptors/desc_hierarchy.c
+++ b/lib/libdvbv5/descriptors/desc_hierarchy.c
@@ -19,9 +19,9 @@
  *
  */
 
-#include "descriptors/desc_hierarchy.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/desc_hierarchy.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_desc_hierarchy_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
diff --git a/lib/libdvbv5/descriptors/desc_isdbt_delivery.c b/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
index 4257e79..df04580 100644
--- a/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_isdbt_delivery.c
@@ -18,9 +18,9 @@
  *
  */
 
-#include "descriptors.h"
-#include "descriptors/desc_isdbt_delivery.h"
-#include "dvb-fe.h"
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/desc_isdbt_delivery.h>
+#include <libdvbv5/dvb-fe.h>
 
 void isdbt_desc_delivery_init(struct dvb_v5_fe_parms *parms,
 			      const uint8_t *buf, struct dvb_desc *desc)
@@ -100,4 +100,4 @@ void isdbt_desc_delivery_free(struct dvb_desc *desc)
 	const struct isdbt_desc_terrestrial_delivery_system *d = (const void *) desc;
 
 	free(d->frequency);
-}
\ No newline at end of file
+}
diff --git a/lib/libdvbv5/descriptors/desc_language.c b/lib/libdvbv5/descriptors/desc_language.c
index bd09872..3d234e1 100644
--- a/lib/libdvbv5/descriptors/desc_language.c
+++ b/lib/libdvbv5/descriptors/desc_language.c
@@ -19,9 +19,9 @@
  *
  */
 
-#include "descriptors/desc_language.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/desc_language.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
diff --git a/lib/libdvbv5/descriptors/desc_logical_channel.c b/lib/libdvbv5/descriptors/desc_logical_channel.c
index 5eb5855..d3edbd9 100644
--- a/lib/libdvbv5/descriptors/desc_logical_channel.c
+++ b/lib/libdvbv5/descriptors/desc_logical_channel.c
@@ -22,10 +22,10 @@
  *	http://tdt.telecom.pt/recursos/apresentacoes/Signalling Specifications for DTT deployment in Portugal.pdf
  */
 
-#include "descriptors.h"
-#include "descriptors/desc_logical_channel.h"
-#include "dvb-fe.h"
-#include "parse_string.h"
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/desc_logical_channel.h>
+#include <libdvbv5/dvb-fe.h>
+#include <parse_string.h>
 
 void dvb_desc_logical_channel_init(struct dvb_v5_fe_parms *parms,
 			      const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_network_name.c b/lib/libdvbv5/descriptors/desc_network_name.c
index c3ce3e4..b48cec1 100644
--- a/lib/libdvbv5/descriptors/desc_network_name.c
+++ b/lib/libdvbv5/descriptors/desc_network_name.c
@@ -19,9 +19,9 @@
  *
  */
 
-#include "descriptors/desc_network_name.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/desc_network_name.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 #include "parse_string.h"
 
 void dvb_desc_network_name_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_partial_reception.c b/lib/libdvbv5/descriptors/desc_partial_reception.c
index 614a256..58d3fe6 100644
--- a/lib/libdvbv5/descriptors/desc_partial_reception.c
+++ b/lib/libdvbv5/descriptors/desc_partial_reception.c
@@ -19,10 +19,10 @@
  * Described on ARIB STD-B10 as Partial reception descriptor
  */
 
-#include "descriptors.h"
-#include "descriptors/desc_partial_reception.h"
-#include "dvb-fe.h"
-#include "parse_string.h"
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/desc_partial_reception.h>
+#include <libdvbv5/dvb-fe.h>
+#include <parse_string.h>
 
 void isdb_desc_partial_reception_init(struct dvb_v5_fe_parms *parms,
 			      const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/desc_sat.c b/lib/libdvbv5/descriptors/desc_sat.c
index 3a8bcf5..510de25 100644
--- a/lib/libdvbv5/descriptors/desc_sat.c
+++ b/lib/libdvbv5/descriptors/desc_sat.c
@@ -19,9 +19,9 @@
  *
  */
 
-#include "descriptors/desc_sat.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/desc_sat.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
index 81d3d60..e73bf78 100644
--- a/lib/libdvbv5/descriptors/desc_service.c
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -19,10 +19,10 @@
  *
  */
 
-#include "descriptors/desc_service.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
-#include "parse_string.h"
+#include <libdvbv5/desc_service.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
+#include <parse_string.h>
 
 void dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
diff --git a/lib/libdvbv5/descriptors/desc_service_list.c b/lib/libdvbv5/descriptors/desc_service_list.c
index 36ecc95..f3c5c79 100644
--- a/lib/libdvbv5/descriptors/desc_service_list.c
+++ b/lib/libdvbv5/descriptors/desc_service_list.c
@@ -19,9 +19,9 @@
  *
  */
 
-#include "descriptors/desc_service_list.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/desc_service_list.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
diff --git a/lib/libdvbv5/descriptors/desc_service_location.c b/lib/libdvbv5/descriptors/desc_service_location.c
index 52cb06d..f386f57 100644
--- a/lib/libdvbv5/descriptors/desc_service_location.c
+++ b/lib/libdvbv5/descriptors/desc_service_location.c
@@ -18,19 +18,20 @@
  *
  */
 
-#include "descriptors/desc_service_location.h"
-#include "dvb-fe.h"
+#include <libdvbv5/desc_service_location.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
 	struct dvb_desc_service_location *service_location = (struct dvb_desc_service_location *) desc;
-	uint8_t *endbuf = buf + desc->length;
+	const uint8_t *endbuf = buf + desc->length;
 	ssize_t size = sizeof(struct dvb_desc_service_location) - sizeof(struct dvb_desc);
 	struct dvb_desc_service_location_element *element;
 	int i;
 
 	if (buf + size > endbuf) {
-		dvb_logerr("%s: short read %d/%zd bytes", __FUNCTION__, endbuf - buf, size);
+		dvb_logerr("%s: short read %zd/%zd bytes", __FUNCTION__, endbuf - buf, size);
 		return;
 	}
 
@@ -43,7 +44,7 @@ void dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t
 
 	size = service_location->elements * sizeof(struct dvb_desc_service_location_element);
 	if (buf + size > endbuf) {
-		dvb_logerr("%s: short read %d/%zd bytes", __FUNCTION__, endbuf - buf, size);
+		dvb_logerr("%s: short read %zd/%zd bytes", __FUNCTION__, endbuf - buf, size);
 		return;
 	}
 	service_location->element = malloc(size);
diff --git a/lib/libdvbv5/descriptors/desc_t2_delivery.c b/lib/libdvbv5/descriptors/desc_t2_delivery.c
index ab4361d..a563164 100644
--- a/lib/libdvbv5/descriptors/desc_t2_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_t2_delivery.c
@@ -19,10 +19,10 @@
  * Based on ETSI EN 300 468 V1.11.1 (2010-04)
  */
 
-#include "descriptors.h"
-#include "descriptors/desc_extension.h"
-#include "descriptors/desc_t2_delivery.h"
-#include "dvb-fe.h"
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/desc_extension.h>
+#include <libdvbv5/desc_t2_delivery.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
 			       const uint8_t *buf,
diff --git a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
index 9414a72..d7ebe1d 100644
--- a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
+++ b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
@@ -21,9 +21,9 @@
  *
  */
 
-#include "descriptors/desc_terrestrial_delivery.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/desc_terrestrial_delivery.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
 {
diff --git a/lib/libdvbv5/descriptors/desc_ts_info.c b/lib/libdvbv5/descriptors/desc_ts_info.c
index 0efb5f7..02fcb82 100644
--- a/lib/libdvbv5/descriptors/desc_ts_info.c
+++ b/lib/libdvbv5/descriptors/desc_ts_info.c
@@ -19,10 +19,10 @@
  * Described on ARIB STD-B10 as TS information descriptor
  */
 
-#include "descriptors.h"
-#include "descriptors/desc_ts_info.h"
-#include "dvb-fe.h"
-#include "parse_string.h"
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/desc_ts_info.h>
+#include <libdvbv5/dvb-fe.h>
+#include <parse_string.h>
 
 void dvb_desc_ts_info_init(struct dvb_v5_fe_parms *parms,
 			      const uint8_t *buf, struct dvb_desc *desc)
diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
index 123dc91..1b64e29 100644
--- a/lib/libdvbv5/descriptors/eit.c
+++ b/lib/libdvbv5/descriptors/eit.c
@@ -19,8 +19,8 @@
  *
  */
 
-#include "descriptors/eit.h"
-#include "dvb-fe.h"
+#include <libdvbv5/eit.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
diff --git a/lib/libdvbv5/descriptors/header.c b/lib/libdvbv5/descriptors/header.c
index f1ed873..da3f970 100644
--- a/lib/libdvbv5/descriptors/header.c
+++ b/lib/libdvbv5/descriptors/header.c
@@ -19,9 +19,9 @@
  *
  */
 
-#include "descriptors/header.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/header.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 int dvb_table_header_init(struct dvb_table_header *t)
 {
diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/descriptors/mgt.c
index 7279982..ba57c84 100644
--- a/lib/libdvbv5/descriptors/mgt.c
+++ b/lib/libdvbv5/descriptors/mgt.c
@@ -18,8 +18,8 @@
  *
  */
 
-#include "descriptors/mgt.h"
-#include "dvb-fe.h"
+#include <libdvbv5/mgt.h>
+#include <libdvbv5/dvb-fe.h>
 
 void atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
diff --git a/lib/libdvbv5/descriptors/mpeg_es.c b/lib/libdvbv5/descriptors/mpeg_es.c
index 0564c21..f9cfbd7 100644
--- a/lib/libdvbv5/descriptors/mpeg_es.c
+++ b/lib/libdvbv5/descriptors/mpeg_es.c
@@ -18,9 +18,9 @@
  *
  */
 
-#include "descriptors/mpeg_es.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/mpeg_es.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 int dvb_mpeg_es_seq_start_init(const uint8_t *buf, ssize_t buflen, struct dvb_mpeg_es_seq_start *seq_start)
 {
diff --git a/lib/libdvbv5/descriptors/mpeg_pes.c b/lib/libdvbv5/descriptors/mpeg_pes.c
index b8adbbf..6ce9f66 100644
--- a/lib/libdvbv5/descriptors/mpeg_pes.c
+++ b/lib/libdvbv5/descriptors/mpeg_pes.c
@@ -18,9 +18,9 @@
  *
  */
 
-#include "descriptors/mpeg_pes.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/mpeg_pes.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 ssize_t dvb_mpeg_pes_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table)
 {
diff --git a/lib/libdvbv5/descriptors/mpeg_ts.c b/lib/libdvbv5/descriptors/mpeg_ts.c
index f17b29c..e1e115f 100644
--- a/lib/libdvbv5/descriptors/mpeg_ts.c
+++ b/lib/libdvbv5/descriptors/mpeg_ts.c
@@ -18,9 +18,9 @@
  *
  */
 
-#include "descriptors/mpeg_ts.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/mpeg_ts.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 ssize_t dvb_mpeg_ts_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
 {
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/descriptors/nit.c
index 4e603eb..054a924 100644
--- a/lib/libdvbv5/descriptors/nit.c
+++ b/lib/libdvbv5/descriptors/nit.c
@@ -19,8 +19,8 @@
  *
  */
 
-#include "descriptors/nit.h"
-#include "dvb-fe.h"
+#include <libdvbv5/nit.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, uint8_t *table, ssize_t *table_length)
diff --git a/lib/libdvbv5/descriptors/pat.c b/lib/libdvbv5/descriptors/pat.c
index 180d30a..2000729 100644
--- a/lib/libdvbv5/descriptors/pat.c
+++ b/lib/libdvbv5/descriptors/pat.c
@@ -19,9 +19,9 @@
  *
  */
 
-#include "descriptors/pat.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/pat.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, uint8_t *table, ssize_t *table_length)
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
index 1ba89ed..32ee7e4 100644
--- a/lib/libdvbv5/descriptors/pmt.c
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -19,9 +19,9 @@
  *
  */
 
-#include "descriptors/pmt.h"
-#include "descriptors.h"
-#include "dvb-fe.h"
+#include <libdvbv5/pmt.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/dvb-fe.h>
 
 #include <string.h> /* memcpy */
 
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/descriptors/sdt.c
index 30207b2..5e0c924 100644
--- a/lib/libdvbv5/descriptors/sdt.c
+++ b/lib/libdvbv5/descriptors/sdt.c
@@ -19,8 +19,8 @@
  *
  */
 
-#include "descriptors/sdt.h"
-#include "dvb-fe.h"
+#include <libdvbv5/sdt.h>
+#include <libdvbv5/dvb-fe.h>
 
 void dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, uint8_t *table, ssize_t *table_length)
diff --git a/lib/libdvbv5/descriptors/vct.c b/lib/libdvbv5/descriptors/vct.c
index cb75b8b..0f051ac 100644
--- a/lib/libdvbv5/descriptors/vct.c
+++ b/lib/libdvbv5/descriptors/vct.c
@@ -19,9 +19,9 @@
  *
  */
 
-#include "descriptors/vct.h"
-#include "dvb-fe.h"
-#include "parse_string.h"
+#include <libdvbv5/vct.h>
+#include <libdvbv5/dvb-fe.h>
+#include <parse_string.h>
 
 void atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
 			ssize_t buflen, uint8_t *table, ssize_t *table_length)
diff --git a/lib/libdvbv5/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
index 91636f5..919e7cb 100644
--- a/lib/libdvbv5/dvb-demux.c
+++ b/lib/libdvbv5/dvb-demux.c
@@ -38,7 +38,7 @@
 #include <fcntl.h>
 #include <stdlib.h> /* free */
 
-#include "dvb-demux.h"
+#include <libdvbv5/dvb-demux.h>
 
 int dvb_dmx_open(int adapter, int demux)
 {
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 4975ff9..0841546 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -19,8 +19,8 @@
 #include <sys/types.h>
 
 #include "dvb-v5.h"
-#include "dvb-v5-std.h"
-#include "dvb-fe.h"
+#include <libdvbv5/dvb-v5-std.h>
+#include <libdvbv5/dvb-fe.h>
 
 #include <inttypes.h>
 #include <math.h>
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 3e0394e..84ff725 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -24,30 +24,30 @@
 #include <strings.h> /* strcasecmp */
 #include <unistd.h>
 
-#include "dvb-file.h"
-#include "dvb-v5-std.h"
-#include "dvb-scan.h"
-#include "dvb-log.h"
-#include "descriptors.h"
-#include "descriptors/nit.h"
-#include "descriptors/sdt.h"
-#include "descriptors/pat.h"
-#include "descriptors/pmt.h"
-#include "descriptors/vct.h"
-#include "descriptors/desc_ts_info.h"
-#include "descriptors/desc_logical_channel.h"
-#include "descriptors/desc_language.h"
-#include "descriptors/desc_network_name.h"
-#include "descriptors/desc_cable_delivery.h"
-#include "descriptors/desc_sat.h"
-#include "descriptors/desc_terrestrial_delivery.h"
-#include "descriptors/desc_service.h"
-#include "descriptors/desc_service_list.h"
-#include "descriptors/desc_frequency_list.h"
-#include "descriptors/desc_event_short.h"
-#include "descriptors/desc_event_extended.h"
-#include "descriptors/desc_atsc_service_location.h"
-#include "descriptors/desc_hierarchy.h"
+#include <libdvbv5/dvb-file.h>
+#include <libdvbv5/dvb-v5-std.h>
+#include <libdvbv5/dvb-scan.h>
+#include <libdvbv5/dvb-log.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/nit.h>
+#include <libdvbv5/sdt.h>
+#include <libdvbv5/pat.h>
+#include <libdvbv5/pmt.h>
+#include <libdvbv5/vct.h>
+#include <libdvbv5/desc_ts_info.h>
+#include <libdvbv5/desc_logical_channel.h>
+#include <libdvbv5/desc_language.h>
+#include <libdvbv5/desc_network_name.h>
+#include <libdvbv5/desc_cable_delivery.h>
+#include <libdvbv5/desc_sat.h>
+#include <libdvbv5/desc_terrestrial_delivery.h>
+#include <libdvbv5/desc_service.h>
+#include <libdvbv5/desc_service_list.h>
+#include <libdvbv5/desc_frequency_list.h>
+#include <libdvbv5/desc_event_short.h>
+#include <libdvbv5/desc_event_extended.h>
+#include <libdvbv5/desc_atsc_service_location.h>
+#include <libdvbv5/desc_hierarchy.h>
 
 int store_entry_prop(struct dvb_entry *entry,
 		     uint32_t cmd, uint32_t value)
diff --git a/lib/libdvbv5/dvb-legacy-channel-format.c b/lib/libdvbv5/dvb-legacy-channel-format.c
index 90f08ad..9acf52c 100644
--- a/lib/libdvbv5/dvb-legacy-channel-format.c
+++ b/lib/libdvbv5/dvb-legacy-channel-format.c
@@ -21,8 +21,8 @@
 #include <stdlib.h>
 #include <string.h>
 
-#include "dvb-file.h"
-#include "dvb-v5-std.h"
+#include <libdvbv5/dvb-file.h>
+#include <libdvbv5/dvb-v5-std.h>
 
 /*
  * Standard channel.conf format for DVB-T, DVB-C, DVB-S and ATSC
diff --git a/lib/libdvbv5/dvb-log.c b/lib/libdvbv5/dvb-log.c
index 8bb34ca..11b9fde 100644
--- a/lib/libdvbv5/dvb-log.c
+++ b/lib/libdvbv5/dvb-log.c
@@ -19,7 +19,7 @@
  *
  */
 
-#include "dvb-log.h"
+#include <libdvbv5/dvb-log.h>
 
 #include <stdio.h>
 #include <unistd.h>
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index e307a3d..df2ffcd 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -23,8 +23,8 @@
 #include <unistd.h>
 #include <strings.h> /* strcasecmp */
 
-#include "dvb-fe.h"
-#include "dvb-v5-std.h"
+#include <libdvbv5/dvb-fe.h>
+#include <libdvbv5/dvb-v5-std.h>
 
 static const struct dvb_sat_lnb lnb[] = {
 	{
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index bc40dab..d4490fb 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -38,30 +38,30 @@
 #include <stdlib.h>
 #include <sys/time.h>
 
-#include "dvb-scan.h"
-#include "dvb-frontend.h"
-#include "descriptors.h"
+#include <libdvbv5/dvb-scan.h>
+#include <libdvbv5/dvb-frontend.h>
+#include <libdvbv5/descriptors.h>
 #include "parse_string.h"
 #include "crc32.h"
-#include "dvb-fe.h"
-#include "dvb-file.h"
-#include "dvb-scan.h"
-#include "dvb-log.h"
-#include "dvb-demux.h"
-#include "descriptors.h"
-#include "descriptors/header.h"
-#include "descriptors/pat.h"
-#include "descriptors/pmt.h"
-#include "descriptors/nit.h"
-#include "descriptors/sdt.h"
-#include "descriptors/vct.h"
-#include "descriptors/desc_extension.h"
-#include "descriptors/desc_cable_delivery.h"
-#include "descriptors/desc_isdbt_delivery.h"
-#include "descriptors/desc_partial_reception.h"
-#include "descriptors/desc_terrestrial_delivery.h"
-#include "descriptors/desc_t2_delivery.h"
-#include "descriptors/desc_sat.h"
+#include <libdvbv5/dvb-fe.h>
+#include <libdvbv5/dvb-file.h>
+#include <libdvbv5/dvb-scan.h>
+#include <libdvbv5/dvb-log.h>
+#include <libdvbv5/dvb-demux.h>
+#include <libdvbv5/descriptors.h>
+#include <libdvbv5/header.h>
+#include <libdvbv5/pat.h>
+#include <libdvbv5/pmt.h>
+#include <libdvbv5/nit.h>
+#include <libdvbv5/sdt.h>
+#include <libdvbv5/vct.h>
+#include <libdvbv5/desc_extension.h>
+#include <libdvbv5/desc_cable_delivery.h>
+#include <libdvbv5/desc_isdbt_delivery.h>
+#include <libdvbv5/desc_partial_reception.h>
+#include <libdvbv5/desc_terrestrial_delivery.h>
+#include <libdvbv5/desc_t2_delivery.h>
+#include <libdvbv5/desc_sat.h>
 
 static int poll(struct dvb_v5_fe_parms *parms, int fd, unsigned int seconds)
 {
diff --git a/lib/libdvbv5/dvb-v5-std.c b/lib/libdvbv5/dvb-v5-std.c
index d193e83..0316d64 100644
--- a/lib/libdvbv5/dvb-v5-std.c
+++ b/lib/libdvbv5/dvb-v5-std.c
@@ -21,7 +21,7 @@
  */
 #include <stddef.h>
 
-#include "dvb-v5-std.h"
+#include <libdvbv5/dvb-v5-std.h>
 #include "dvb-v5.h"
 
 const unsigned int sys_dvbt_props[] = {
diff --git a/lib/libdvbv5/dvb-v5.h b/lib/libdvbv5/dvb-v5.h
index 1d920ce..bf2f550 100644
--- a/lib/libdvbv5/dvb-v5.h
+++ b/lib/libdvbv5/dvb-v5.h
@@ -3,7 +3,7 @@
  */
 #ifndef _DVB_V5_CONSTS_H
 #define _DVB_V5_CONSTS_H
-#include "../include/dvb-frontend.h"
+#include <libdvbv5/dvb-frontend.h>
 struct fe_caps_name {
 	unsigned  idx;
 	char *name;
diff --git a/lib/libdvbv5/dvb-zap-format.c b/lib/libdvbv5/dvb-zap-format.c
index 5739e05..7b67cd6 100644
--- a/lib/libdvbv5/dvb-zap-format.c
+++ b/lib/libdvbv5/dvb-zap-format.c
@@ -22,8 +22,8 @@
 #include <stdlib.h>
 #include <string.h>
 
-#include "dvb-file.h"
-#include "dvb-v5-std.h"
+#include <libdvbv5/dvb-file.h>
+#include <libdvbv5/dvb-v5-std.h>
 
 /*
  * Standard channel.conf format for DVB-T, DVB-C, DVB-S and ATSC
diff --git a/lib/libdvbv5/gen_dvb_structs.pl b/lib/libdvbv5/gen_dvb_structs.pl
index 80e2642..df69700 100755
--- a/lib/libdvbv5/gen_dvb_structs.pl
+++ b/lib/libdvbv5/gen_dvb_structs.pl
@@ -481,7 +481,7 @@ print OUT <<EOF;
  */
 #ifndef _DVB_V5_CONSTS_H
 #define _DVB_V5_CONSTS_H
-#include "../include/dvb-frontend.h"
+#include <libdvbv5/dvb-frontend.h>
 EOF
 output_arrays ("fe_caps_name", \%fe_caps, "unsigned", 1, 1);
 output_arrays ("fe_status_name", \%fe_status, "unsigned", 1, 1);
@@ -510,7 +510,7 @@ print OUT <<EOF;
  */
 #include <stddef.h>
 
-#include "dvb-v5.h"
+#include <libdvbv5/dvb-v5.h>
 
 EOF
 output_arrays ("fe_caps_name", \%fe_caps, "unsigned", 1, 0);
diff --git a/lib/libdvbv5/parse_string.c b/lib/libdvbv5/parse_string.c
index ce3dc06..0e94cf2 100644
--- a/lib/libdvbv5/parse_string.c
+++ b/lib/libdvbv5/parse_string.c
@@ -30,8 +30,8 @@
 #include <strings.h> /* strcasecmp */
 
 #include "parse_string.h"
-#include "dvb-log.h"
-#include "dvb-fe.h"
+#include <libdvbv5/dvb-log.h>
+#include <libdvbv5/dvb-fe.h>
 
 #define CS_OPTIONS "//TRANSLIT"
 
diff --git a/utils/dvb/dvb-fe-tool.c b/utils/dvb/dvb-fe-tool.c
index 46612f2..d9d63af 100644
--- a/utils/dvb/dvb-fe-tool.c
+++ b/utils/dvb/dvb-fe-tool.c
@@ -18,7 +18,7 @@
  *
  */
 
-#include "dvb-file.h"
+#include "libdvbv5/dvb-file.h"
 #include <config.h>
 #include <argp.h>
 #include <stdlib.h>
diff --git a/utils/dvb/dvb-format-convert.c b/utils/dvb/dvb-format-convert.c
index 4f53295..ab3cd79 100644
--- a/utils/dvb/dvb-format-convert.c
+++ b/utils/dvb/dvb-format-convert.c
@@ -31,9 +31,9 @@
 
 #include <config.h>
 
-#include "dvb-file.h"
-#include "dvb-demux.h"
-#include "dvb-scan.h"
+#include "libdvbv5/dvb-file.h"
+#include "libdvbv5/dvb-demux.h"
+#include "libdvbv5/dvb-scan.h"
 
 #define PROGRAM_NAME	"dvb-format-convert"
 
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index d47ac57..501b332 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -33,10 +33,10 @@
 #include <config.h>
 
 #include <linux/dvb/dmx.h>
-#include "dvb-file.h"
-#include "dvb-demux.h"
-#include "dvb-v5-std.h"
-#include "dvb-scan.h"
+#include "libdvbv5/dvb-file.h"
+#include "libdvbv5/dvb-demux.h"
+#include "libdvbv5/dvb-v5-std.h"
+#include "libdvbv5/dvb-scan.h"
 
 #define PROGRAM_NAME	"dvbv5-scan"
 #define DEFAULT_OUTPUT  "dvb_channel.conf"
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index d4a4b98..eea201e 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -37,10 +37,10 @@
 #include <config.h>
 
 #include <linux/dvb/dmx.h>
-#include "dvb-file.h"
-#include "dvb-demux.h"
-#include "dvb-scan.h"
-#include "descriptors/header.h"
+#include "libdvbv5/dvb-file.h"
+#include "libdvbv5/dvb-demux.h"
+#include "libdvbv5/dvb-scan.h"
+#include "libdvbv5/header.h"
 
 #define CHANNEL_FILE	"channels.conf"
 #define PROGRAM_NAME	"dvbv5-zap"
-- 
1.8.3.2

