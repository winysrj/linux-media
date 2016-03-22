Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:37068 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497AbcCVK34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 06:29:56 -0400
Received: from cobaltpc1.rd.cisco.com ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id u2MATrYi001203
	(version=TLSv1/SSLv3 cipher=AES128-SHA256 bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 22 Mar 2016 10:29:53 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] EDID/DV_TIMINGS docbook fixes
Date: Tue, 22 Mar 2016 11:30:26 +0100
Message-Id: <1458642629-15742-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes a few issues I found in the documentation.

Hans Verkuil (3):
  vidioc-g-edid.xml: be explicit about zeroing the reserved array
  vidioc-enum-dv-timings.xml: explicitly state that pad and reserved
    should be zeroed
  vidioc-dv-timings-cap.xml: explicitly state that pad and reserved
    should be zeroed

 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml  | 12 +++++++-----
 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml |  5 +++--
 Documentation/DocBook/media/v4l/vidioc-g-edid.xml          | 10 ++++++----
 3 files changed, 16 insertions(+), 11 deletions(-)

-- 
2.7.0

