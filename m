Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:8438 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbcF3Kg1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 06:36:27 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] cec.h/cec-funcs.h: add option to use BSD license
Date: Thu, 30 Jun 2016 12:19:32 +0200
Message-Id: <1467281973-6889-2-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1467281973-6889-1-git-send-email-hans.verkuil@cisco.com>
References: <1467281973-6889-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Like the videodev2.h and other headers, explicitly allow these headers
to be used with the BSD license.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/linux/cec-funcs.h | 16 ++++++++++++++++
 include/linux/cec.h       | 16 ++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
index 8ee1029..19486009 100644
--- a/include/linux/cec-funcs.h
+++ b/include/linux/cec-funcs.h
@@ -7,6 +7,22 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
  *
+ * Alternatively you can redistribute this file under the terms of the
+ * BSD license as stated below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ * 3. The names of its contributors may not be used to endorse or promote
+ *    products derived from this software without specific prior written
+ *    permission.
+ *
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
diff --git a/include/linux/cec.h b/include/linux/cec.h
index 40924e7..6678afe 100644
--- a/include/linux/cec.h
+++ b/include/linux/cec.h
@@ -7,6 +7,22 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
  *
+ * Alternatively you can redistribute this file under the terms of the
+ * BSD license as stated below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ * 3. The names of its contributors may not be used to endorse or promote
+ *    products derived from this software without specific prior written
+ *    permission.
+ *
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- 
2.7.0

