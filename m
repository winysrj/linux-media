Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53519 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3L3Mtl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:41 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so5061862eae.33
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:40 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 18/18] libdvbv5: README updated for shared libdvbv5
Date: Mon, 30 Dec 2013 13:48:51 +0100
Message-Id: <1388407731-24369-18-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 README        |  8 ++++----
 README.libv4l | 12 ++++++++++++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/README b/README
index 0cccc00..a9f8089 100644
--- a/README
+++ b/README
@@ -3,13 +3,13 @@ v4l-utils
 
 Linux V4L2 and DVB API utilities and v4l libraries (libv4l).
 You can always find the latest development v4l-utils in the git repo:
-http://git.linuxtv.org/v4l-utils.git 
+http://git.linuxtv.org/v4l-utils.git
 
 
-v4l libraries (libv4l)
-----------------------
+v4l libraries (libv4l, libdvbv5)
+--------------------------------
 
-See README.lib for more information on libv4l, libv4l is released
+See README.libv4l for more information on libv4l, libv4l is released
 under the GNU Lesser General Public License.
 
 
diff --git a/README.libv4l b/README.libv4l
index 0be503f..7170801 100644
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
 
-- 
1.8.3.2

