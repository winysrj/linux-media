Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.redembedded.com ([82.219.14.93]:29614 "EHLO
	mail1.redembedded.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbaE2PU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 11:20:57 -0400
Received: from exmail.redembedded.com ([10.82.128.38]:55354)
	by mail1.redembedded.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
	(Exim 4.76)
	(envelope-from <robert.barker@redembedded.com>)
	id 1Wq28L-0001ct-DE
	for linux-media@vger.kernel.org; Thu, 29 May 2014 16:20:45 +0100
Message-ID: <53875055.2020907@redembedded.com>
Date: Thu, 29 May 2014 16:20:53 +0100
From: Rob Barker <robert.barker@redembedded.com>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
Subject: [PATCH] v4l-utils: libdvbv5: Find other TS in NIT pointer fix
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_scan_add_entry() is modified to return the pointer to the newly
created entry (the last in the list), so the add_update_nit_ functions
now modify the correct element, instead of the penultimate one.  This
fixes the finding of other TS in NIT scan feature.

Signed-off-by: Rob Barker <robert.barker@redembedded.com>
---
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 297ac59..9a7997b 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -741,7 +741,7 @@ struct dvb_entry *dvb_scan_add_entry(struct
dvb_v5_fe_parms *parms,
                                 n, freq);
                         entry->next = new_entry;
                         new_entry->next = NULL;
-                       return entry;
+                       return new_entry;
                 }
         }

--
Rob Barker
Red Embedded

This E-mail and any attachments hereto are strictly confidential and intended solely for the addressee. If you are not the intended addressee please notify the sender by return and delete the message.

You must not disclose, forward or copy this E-mail or attachments to any third party without the prior consent of the sender.

Red Embedded Consulting, Company Number 06688270 Registered in England: The Waterfront, Salts Mill Rd, Saltaire, BD17 7EZ
