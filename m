Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1356 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbaGRF6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 01:58:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] DocBook media: document new VBI defines
Date: Fri, 18 Jul 2014 07:58:42 +0200
Message-Id: <1405663122-12149-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405663122-12149-1-git-send-email-hverkuil@xs4all.nl>
References: <1405663122-12149-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add defines for the start line numbers of each field for both
525 and 625 line formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/dev-raw-vbi.xml    | 12 +++++++++---
 Documentation/DocBook/media/v4l/dev-sliced-vbi.xml |  9 ++++++++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-raw-vbi.xml b/Documentation/DocBook/media/v4l/dev-raw-vbi.xml
index b788c72..f4b61b6 100644
--- a/Documentation/DocBook/media/v4l/dev-raw-vbi.xml
+++ b/Documentation/DocBook/media/v4l/dev-raw-vbi.xml
@@ -150,9 +150,15 @@ signal. Drivers shall not convert the sample format by software.</para></entry>
 	      <entry>This is the scanning system line number
 associated with the first line of the VBI image, of the first and the
 second field respectively. See <xref linkend="vbi-525" /> and
-<xref linkend="vbi-625" /> for valid values. VBI input drivers can
-return start values 0 if the hardware cannot reliable identify
-scanning lines, VBI acquisition may not require this
+<xref linkend="vbi-625" /> for valid values.
+The <constant>V4L2_VBI_ITU_525_F1_START</constant>,
+<constant>V4L2_VBI_ITU_525_F2_START</constant>,
+<constant>V4L2_VBI_ITU_625_F1_START</constant> and
+<constant>V4L2_VBI_ITU_625_F2_START</constant> defines give the start line
+numbers for each field for each 525 or 625 line format as a convenience.
+Don't forget that ITU line numbering starts at 1, not 0.
+VBI input drivers can return start values 0 if the hardware cannot
+reliable identify scanning lines, VBI acquisition may not require this
 information.</entry>
 	    </row>
 	    <row>
diff --git a/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml b/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
index 548f8ea..7a8bf30 100644
--- a/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
+++ b/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
@@ -185,7 +185,14 @@ tables, sigh. --></para></entry>
 	    <entry></entry>
 	    <entry spanname="hspan">Drivers must set
 <structfield>service_lines</structfield>[0][0] and
-<structfield>service_lines</structfield>[1][0] to zero.</entry>
+<structfield>service_lines</structfield>[1][0] to zero.
+The <constant>V4L2_VBI_ITU_525_F1_START</constant>,
+<constant>V4L2_VBI_ITU_525_F2_START</constant>,
+<constant>V4L2_VBI_ITU_625_F1_START</constant> and
+<constant>V4L2_VBI_ITU_625_F2_START</constant> defines give the start
+line numbers for each field for each 525 or 625 line format as a
+convenience.  Don't forget that ITU line numbering starts at 1, not 0.
+</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
2.0.0

