Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6141tdS028345
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:01:55 -0400
Received: from calf.ext.ti.com (calf.ext.ti.com [198.47.26.144])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6141hWv012731
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:01:43 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by calf.ext.ti.com (8.13.7/8.13.7) with ESMTP id m6141X2s004223
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:01:38 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id m6141W6t010749
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:01:32 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m6141WG19264
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:01:32 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m6141WTd017643
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:01:32 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m6141WhG017641
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 23:01:32 -0500
Date: Mon, 30 Jun 2008 23:01:32 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080701040132.GA17632@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 2/16] OMAP3 camera driver V4L2 CCP2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Sameer Venkatraman <sameerv@ti.com>

V4L2: Adding Compact Camera Port definitions.

Adding Compact Camera Port (CCP) 2 class structures.

Signed-off-by: Sameer Venkatraman <sameerv@ti.com>
Signed-off-by: Mohit Jalori <mjalori@ti.com>
---
 v4l2-int-device.h |  101 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 101 insertions(+)

--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -103,6 +103,11 @@ enum v4l2_if_type {
 	 * on certain image sensors.
 	 */
 	V4L2_IF_TYPE_BT656,
+	/*
+	 * Compact Camera Port (CCP) 2. CCP 2 class 0 is also known as
+	 * Camera Serial Interface (CSI) 1.
+	 */
+	V4L2_IF_TYPE_CCP2,
 };
 
 enum v4l2_if_type_bt656_mode {
@@ -149,10 +154,106 @@ struct v4l2_if_type_bt656 {
 	u32 clock_curr;
 };
 
+enum v4l2_if_type_ccp2_mode {
+	V4L2_IF_TYPE_CCP2_MODE_SERIAL = 0,
+	V4L2_IF_TYPE_CCP2_MODE_PARALLEL
+};
+
+enum v4l2_if_type_ccp2_edge {
+	V4L2_IF_TYPE_CCP2_EDGE_RISING = 0,
+	V4L2_IF_TYPE_CCP2_EDGE_FALLING
+};
+
+enum v4l2_if_type_ccp2_signalling {
+	V4L2_IF_TYPE_CCP2_SIGNALLING_DATA_CLOCK = 0,
+	V4L2_IF_TYPE_CCP2_SIGNALLING_DATA_STROBE
+};
+
+struct v4l2_if_type_ccp2 {
+	/*
+	 * CCP 2 class:
+	 *
+	 * 0: CCP 2 class 0 or CSI 1
+	 * 1: CCP 2 class 1 or 2
+	 *
+	 * These restrictions apply to CCP 2 class 0 / CSI 1:
+	 *
+	 * - Data / strobe signaling may not be used.
+	 *
+	 * - CRC may not be used.
+	 *
+	 * - The only logical channel which can be used is 0.
+	 *
+	 * - RAW6 and RAW7 data types may not be used.
+	 *
+	 * - DPCM (de)compression may not be used.
+	 */
+	unsigned class:1;
+	/*
+	 * 0: don't use crc
+	 * 1: use crc
+	 */
+	unsigned crc:1;
+	/*
+	 * 0: serial mode
+	 * 1: parallel mode
+	 */
+	unsigned mode:1;
+	/*
+	 * 0: output changes on clock rising edge
+	 * 1: output changes on clock falling edge
+	 *
+	 * Sampling must be done on opposite edge.
+	 *
+	 * FIXME: Does this affect data / strobe signalling??
+	 */
+	unsigned edge:1;
+	/*
+	 * 0: data / clock signalling
+	 * 1: data / strobe signalling
+	 */
+	unsigned signalling:1;
+	/*
+	 * 0: strobe / clock signal not inverted
+	 * 1: strobe / clock signal inverted
+	 */
+	unsigned strobe_clock_inv:1;
+	/*
+	 * Vertical sync edge at beginning of image data.
+	 *
+	 * 0: rising
+	 * 1: falling
+	 */
+	unsigned vs_edge:1;
+	/* Logical channel number; 0--7. */
+	unsigned channel:3;
+	/* V4L2_PIX_FMT_... */
+	u32 format;
+	/* Number of empty scanlines in the beginning of the frame. */
+	unsigned data_start:14;
+	/*
+	 * Number of scanlines of real pixel data, i.e. you'll, in the
+	 * end, get this many scanlines to your image.
+	 */
+	unsigned data_size:14;
+	/* In Hz. */
+	u32 clock_min;
+	u32 clock_max;
+	/* Desired external clock rate. */
+	u32 clock_curr;
+};
+
+enum v4l2_if_soc_cap{
+	V4L2_IF_CAP_RAW,
+	V4L2_IF_CAP_SOC
+};
+
 struct v4l2_ifparm {
+	enum v4l2_if_soc_cap capability;
 	enum v4l2_if_type if_type;
 	union {
 		struct v4l2_if_type_bt656 bt656;
+		struct v4l2_if_type_ccp2 ccp2;
 	} u;
 };
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
