Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44903 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbbKPKVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 05/16] [media] demux.h: Some documentation fixups for the header
Date: Mon, 16 Nov 2015 08:21:02 -0200
Message-Id: <78c7e8322d21e3de1d7ce675e33413e1435d75d7.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DocBook description of this header has two issues:
- It calls the Kernel ABI as API, instead of kABI;
- It mentions that the DVB frontend kABI is not described
  within the document. As this will actually generate a
  single DocBook, this is actually not true, now that
  the documentation for the frontend was added.

So, fix both issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/demux.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index f716e14f995f..6d3b95b8939d 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -35,31 +35,31 @@
 /**
  * DOC: Digital TV Demux
  *
- * The kernel demux API defines a driver-internal interface for registering
- * low-level, hardware specific driver to a hardware independent demux layer.
- * It is only of interest for Digital TV device driver writers.
- * The header file for this API is named demux.h and located in
+ * The Kernel Digital TV Demux kABI defines a driver-internal interface for
+ * registering low-level, hardware specific driver to a hardware independent
+ * demux layer. It is only of interest for Digital TV device driver writers.
+ * The header file for this kABI is named demux.h and located in
  * drivers/media/dvb-core.
  *
- * The demux API should be implemented for each demux in the system. It is
+ * The demux kABI should be implemented for each demux in the system. It is
  * used to select the TS source of a demux and to manage the demux resources.
- * When the demux client allocates a resource via the demux API, it receives
- * a pointer to the API of that	resource.
+ * When the demux client allocates a resource via the demux kABI, it receives
+ * a pointer to the kABI of that resource.
  *
  * Each demux receives its TS input from a DVB front-end or from memory, as
- * set via this demux API. In a system with more than one front-end, the API
+ * set via this demux kABI. In a system with more than one front-end, the kABI
  * can be used to select one of the DVB front-ends as a TS source for a demux,
  * unless this is fixed in the HW platform.
  *
- * The demux API only controls front-ends regarding to their connections with
- * demuxes; the APIs used to set the other front-end parameters, such as
- * tuning, are not defined in this document.
+ * The demux kABI only controls front-ends regarding to their connections with
+ * demuxes; the kABI used to set the other front-end parameters, such as
+ * tuning, are devined via the Digital TV Frontend kABI.
  *
  * The functions that implement the abstract interface demux should be defined
  * static or module private and registered to the Demux core for external
  * access. It is not necessary to implement every function in the struct
  * &dmx_demux. For example, a demux interface might support Section filtering,
- * but not PES filtering. The API client is expected to check the value of any
+ * but not PES filtering. The kABI client is expected to check the value of any
  * function pointer before calling the function: the value of NULL means
  * that the function is not available.
  *
@@ -71,7 +71,7 @@
  * Even a simple memory allocation without using %GFP_ATOMIC can result in a
  * kernel thread being put to sleep if swapping is needed. For example, the
  * Linux Kernel calls the functions of a network device interface from a
- * bottom half context. Thus, if a demux API function is called from network
+ * bottom half context. Thus, if a demux kABI function is called from network
  * device code, the function must not sleep.
  */
 
-- 
2.5.0

