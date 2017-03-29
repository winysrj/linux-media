Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38606 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752667AbdC2Syc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 14:54:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 07/22] usb/anchors.txt: convert to ReST and add to driver-api book
Date: Wed, 29 Mar 2017 15:54:06 -0300
Message-Id: <067de4865e1ea6d7790fd98aa6c757f7d8a7e8c6.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document describe some USB core functions. Add it to the
driver-api book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../anchors.txt => driver-api/usb/anchors.rst}     | 36 ++++++++++++----------
 Documentation/driver-api/usb/index.rst             |  1 +
 2 files changed, 21 insertions(+), 16 deletions(-)
 rename Documentation/{usb/anchors.txt => driver-api/usb/anchors.rst} (75%)

diff --git a/Documentation/usb/anchors.txt b/Documentation/driver-api/usb/anchors.rst
similarity index 75%
rename from Documentation/usb/anchors.txt
rename to Documentation/driver-api/usb/anchors.rst
index fe6a99a32bbd..4b248e691bd6 100644
--- a/Documentation/usb/anchors.txt
+++ b/Documentation/driver-api/usb/anchors.rst
@@ -1,3 +1,6 @@
+USB Anchors
+~~~~~~~~~~~
+
 What is anchor?
 ===============
 
@@ -13,7 +16,7 @@ Allocation and Initialisation
 =============================
 
 There's no API to allocate an anchor. It is simply declared
-as struct usb_anchor. init_usb_anchor() must be called to
+as struct usb_anchor. :c:func:`init_usb_anchor` must be called to
 initialise the data structure.
 
 Deallocation
@@ -26,52 +29,53 @@ Association and disassociation of URBs with anchors
 ===================================================
 
 An association of URBs to an anchor is made by an explicit
-call to usb_anchor_urb(). The association is maintained until
+call to :c:func:`usb_anchor_urb`. The association is maintained until
 an URB is finished by (successful) completion. Thus disassociation
 is automatic. A function is provided to forcibly finish (kill)
 all URBs associated with an anchor.
-Furthermore, disassociation can be made with usb_unanchor_urb()
+Furthermore, disassociation can be made with :c:func:`usb_unanchor_urb`
 
 Operations on multitudes of URBs
 ================================
 
-usb_kill_anchored_urbs()
-------------------------
+:c:func:`usb_kill_anchored_urbs`
+--------------------------------
 
 This function kills all URBs associated with an anchor. The URBs
 are called in the reverse temporal order they were submitted.
 This way no data can be reordered.
 
-usb_unlink_anchored_urbs()
---------------------------
+:c:func:`usb_unlink_anchored_urbs`
+----------------------------------
+
 
 This function unlinks all URBs associated with an anchor. The URBs
 are processed in the reverse temporal order they were submitted.
-This is similar to usb_kill_anchored_urbs(), but it will not sleep.
+This is similar to :c:func:`usb_kill_anchored_urbs`, but it will not sleep.
 Therefore no guarantee is made that the URBs have been unlinked when
 the call returns. They may be unlinked later but will be unlinked in
 finite time.
 
-usb_scuttle_anchored_urbs()
----------------------------
+:c:func:`usb_scuttle_anchored_urbs`
+-----------------------------------
 
 All URBs of an anchor are unanchored en masse.
 
-usb_wait_anchor_empty_timeout()
--------------------------------
+:c:func:`usb_wait_anchor_empty_timeout`
+---------------------------------------
 
 This function waits for all URBs associated with an anchor to finish
 or a timeout, whichever comes first. Its return value will tell you
 whether the timeout was reached.
 
-usb_anchor_empty()
-------------------
+:c:func:`usb_anchor_empty`
+--------------------------
 
 Returns true if no URBs are associated with an anchor. Locking
 is the caller's responsibility.
 
-usb_get_from_anchor()
----------------------
+:c:func:`usb_get_from_anchor`
+-----------------------------
 
 Returns the oldest anchored URB of an anchor. The URB is unanchored
 and returned with a reference. As you may mix URBs to several
diff --git a/Documentation/driver-api/usb/index.rst b/Documentation/driver-api/usb/index.rst
index cf2fa2e8d236..5dfb04b2d730 100644
--- a/Documentation/driver-api/usb/index.rst
+++ b/Documentation/driver-api/usb/index.rst
@@ -6,6 +6,7 @@ Linux USB API
 
    usb
    gadget
+   anchors
    writing_usb_driver
    writing_musb_glue_layer
 
-- 
2.9.3
