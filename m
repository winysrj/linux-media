Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43185 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754589AbcHSNFK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 10/15] [media] adjust remaining tables at DVB uAPI documentation
Date: Fri, 19 Aug 2016 10:05:00 -0300
Message-Id: <9a946e73535dd550904586bcb5b21c04f70abb72.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a few broken tables on LaTeX output at the DVB
uAPI documentation. Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/audio-fopen.rst        | 2 ++
 Documentation/media/uapi/dvb/ca-fopen.rst           | 2 ++
 Documentation/media/uapi/dvb/dmx-fread.rst          | 3 ++-
 Documentation/media/uapi/dvb/dmx-fwrite.rst         | 2 ++
 Documentation/media/uapi/dvb/dmx-set-pes-filter.rst | 2 +-
 Documentation/media/uapi/dvb/dmx-start.rst          | 2 +-
 Documentation/media/uapi/dvb/dmx_types.rst          | 1 +
 Documentation/media/uapi/dvb/fe-get-info.rst        | 1 +
 Documentation/media/uapi/dvb/fe-read-status.rst     | 1 +
 Documentation/media/uapi/dvb/video-fopen.rst        | 2 ++
 10 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/dvb/audio-fopen.rst b/Documentation/media/uapi/dvb/audio-fopen.rst
index ec3b23aa79b3..3ef4fd62ffb6 100644
--- a/Documentation/media/uapi/dvb/audio-fopen.rst
+++ b/Documentation/media/uapi/dvb/audio-fopen.rst
@@ -80,6 +80,8 @@ AUDIO_GET_STATUS. All other call will return with an error code.
 Return Value
 ------------
 
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/dvb/ca-fopen.rst b/Documentation/media/uapi/dvb/ca-fopen.rst
index f284461cce20..9960fc76189c 100644
--- a/Documentation/media/uapi/dvb/ca-fopen.rst
+++ b/Documentation/media/uapi/dvb/ca-fopen.rst
@@ -79,6 +79,8 @@ the device in this mode will fail, and an error code will be returned.
 Return Value
 ------------
 
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/dvb/dmx-fread.rst b/Documentation/media/uapi/dvb/dmx-fread.rst
index d25b19e4f696..266c9ca259c9 100644
--- a/Documentation/media/uapi/dvb/dmx-fread.rst
+++ b/Documentation/media/uapi/dvb/dmx-fread.rst
@@ -53,10 +53,11 @@ data. The filtered data is transferred from the driver’s internal
 circular buffer to buf. The maximum amount of data to be transferred is
 implied by count.
 
-
 Return Value
 ------------
 
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/dvb/dmx-fwrite.rst b/Documentation/media/uapi/dvb/dmx-fwrite.rst
index 9efd81a1b5c8..3d76470bef60 100644
--- a/Documentation/media/uapi/dvb/dmx-fwrite.rst
+++ b/Documentation/media/uapi/dvb/dmx-fwrite.rst
@@ -59,6 +59,8 @@ The amount of data to be transferred is implied by count.
 Return Value
 ------------
 
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst b/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
index addc321011ce..d71db779b6fd 100644
--- a/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
@@ -61,7 +61,7 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
-
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
 
 .. flat-table::
     :header-rows:  0
diff --git a/Documentation/media/uapi/dvb/dmx-start.rst b/Documentation/media/uapi/dvb/dmx-start.rst
index 9835d1e78400..959b5eee2647 100644
--- a/Documentation/media/uapi/dvb/dmx-start.rst
+++ b/Documentation/media/uapi/dvb/dmx-start.rst
@@ -53,7 +53,7 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
-
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
 
 .. flat-table::
     :header-rows:  0
diff --git a/Documentation/media/uapi/dvb/dmx_types.rst b/Documentation/media/uapi/dvb/dmx_types.rst
index 7a8900af2680..efd564035958 100644
--- a/Documentation/media/uapi/dvb/dmx_types.rst
+++ b/Documentation/media/uapi/dvb/dmx_types.rst
@@ -12,6 +12,7 @@ Demux Data Types
 Output for the demux
 ====================
 
+.. tabularcolumns:: |p{5.0cm}|p{12.5cm}|
 
 .. _dmx-output:
 
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index 80644072087f..85973be62b0c 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -160,6 +160,7 @@ frontend capabilities
 Capabilities describe what a frontend can do. Some capabilities are
 supported only on some specific frontend types.
 
+.. tabularcolumns:: |p{5.5cm}|p{12.0cm}|
 
 .. _fe-caps:
 
diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
index defe30d036ec..def8160d6807 100644
--- a/Documentation/media/uapi/dvb/fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/fe-read-status.rst
@@ -56,6 +56,7 @@ The fe_status parameter is used to indicate the current state and/or
 state changes of the frontend hardware. It is produced using the enum
 :ref:`fe_status <fe-status>` values on a bitmask
 
+.. tabularcolumns:: |p{3.5cm}|p{14.0cm}|
 
 .. _fe-status:
 
diff --git a/Documentation/media/uapi/dvb/video-fopen.rst b/Documentation/media/uapi/dvb/video-fopen.rst
index 9e5471557b83..9addca95516e 100644
--- a/Documentation/media/uapi/dvb/video-fopen.rst
+++ b/Documentation/media/uapi/dvb/video-fopen.rst
@@ -82,6 +82,8 @@ return an error code.
 Return Value
 ------------
 
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-- 
2.7.4


