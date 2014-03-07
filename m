Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4673 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbaCGO0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 09:26:31 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id s27EQRdb062372
	for <linux-media@vger.kernel.org>; Fri, 7 Mar 2014 15:26:30 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 7167A2A1887
	for <linux-media@vger.kernel.org>; Fri,  7 Mar 2014 15:26:26 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 0/5] DocBook media updates
Date: Fri,  7 Mar 2014 15:26:19 +0100
Message-Id: <1394202384-5762-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After doing a lot of work on v4l2-compliance I found some wrong and some
missing information in the spec. This patch series fixes and clarifies
them.

The first clarifies two corner cases: what happens with queued buffers is
STREAMON fails, and what happens if buffers are queued, STREAMON was never
called, and STREAMOFF is called.

The second fixed a bug in a code example.

The third clarifies the use of several v4l2_buffer/plane fields. In particular
who is responsible for setting them, the application or the driver.

The fourth fixes the FIELD_ALTERNATE description: sizeimage is really
that of the field, not of the frame. It makes no sense to do it the way
that the spec describes, and all the drivers implementing FIELD_ALTERNATE
set sizeimage to the field height times bytesperline.

The last patch does the same as the third but for v4l2_pix_format(_mplane).

Regards,

	Hans

