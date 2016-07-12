Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:57464 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbcGLOKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 10:10:45 -0400
Received: from cobaltpc1.rd.cisco.com ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id u6CEAglN002174
	(version=TLSv1/SSLv3 cipher=AES128-SHA256 bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 12 Jul 2016 14:10:43 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] CEC improvements
Date: Tue, 12 Jul 2016 16:10:40 +0200
Message-Id: <1468332642-24915-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two CEC patches: one adds a sanity check, the other splits the timestamp into
two: one for rx and one for tx.

The work on the CEC compliance test made us realize that you need this information
it order to diagnose problems like reply messages that take too long.

A documentation patch will follow.

Regards,

	Hans

Hans Verkuil (2):
  cec: add sanity check for msg->len
  cec: split the timestamp into an rx and tx timestamp

 drivers/staging/media/cec/cec-adap.c | 27 +++++++++++++++------------
 include/linux/cec.h                  | 18 ++++++++++--------
 2 files changed, 25 insertions(+), 20 deletions(-)

-- 
2.7.0

