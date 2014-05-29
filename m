Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.redembedded.com ([82.219.14.93]:43459 "EHLO
	mail1.redembedded.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbaE2PW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 11:22:27 -0400
Received: from exmail.redembedded.com ([10.82.128.38]:62765)
	by mail1.redembedded.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
	(Exim 4.76)
	(envelope-from <robert.barker@redembedded.com>)
	id 1Wq1bn-0001JA-MF
	for linux-media@vger.kernel.org; Thu, 29 May 2014 15:47:07 +0100
Message-ID: <53874874.90402@redembedded.com>
Date: Thu, 29 May 2014 15:47:16 +0100
From: Rob Barker <robert.barker@redembedded.com>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
Subject: [PATCH] v4l-utils: libdvbv5: fix compilation issue
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removed unnecessary header file to fix issue with some compilers.

Signed-off-by: Rob Barker <robert.barker@redembedded.com>
---

diff --git a/lib/include/libdvbv5/descriptors.h
b/lib/include/libdvbv5/descriptors.h
index 94d85a9..cda958e 100644
--- a/lib/include/libdvbv5/descriptors.h
+++ b/lib/include/libdvbv5/descriptors.h
@@ -26,7 +26,6 @@
  #ifndef _DESCRIPTORS_H
  #define _DESCRIPTORS_H

-#include <arpa/inet.h>
  #include <unistd.h>
  #include <stdint.h>
--
Rob Barker
Red Embedded

This E-mail and any attachments hereto are strictly confidential and intended solely for the addressee. If you are not the intended addressee please notify the sender by return and delete the message.

You must not disclose, forward or copy this E-mail or attachments to any third party without the prior consent of the sender.

Red Embedded Consulting, Company Number 06688270 Registered in England: The Waterfront, Salts Mill Rd, Saltaire, BD17 7EZ
