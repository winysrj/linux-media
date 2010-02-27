Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43197 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933964Ab0B0VdS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 16:33:18 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <1267306076.16186.103.camel@localhost>
References: <1267306076.16186.103.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 27 Feb 2010 21:33:15 +0000
Message-ID: <1267306395.16186.110.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH firmware 6/6] Add firmware for lgs8g75
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is taken from the lgs8gxx driver as of 2.6.32-rc5.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
The binary changes are omitted from this message as they are impossible
to review.

Ben.

 WHENCE     |    9 +++++++++
 lgs8g75.fw |  Bin 0 -> 262 bytes
 2 files changed, 9 insertions(+), 0 deletions(-)
 create mode 100644 lgs8g75.fw

diff --git a/WHENCE b/WHENCE
index d62468e..659e255 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1184,3 +1184,12 @@ Found in hex form in kernel source.
 
 --------------------------------------------------------------------------
 
+Driver: lgs8gxx - Legend Silicon GB20600 demodulator driver
+
+File: lgs8g75.fw
+
+Licence: Unknown
+
+Found in hex form in kernel source.
+
+--------------------------------------------------------------------------

