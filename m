Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:1686 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbcF3KZL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 06:25:11 -0400
Received: from cobaltpc1.rd.cisco.com ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id u5UAJXNs008005
	(version=TLSv1/SSLv3 cipher=AES128-SHA256 bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Jun 2016 10:19:34 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] One fix, one license change
Date: Thu, 30 Jun 2016 12:19:31 +0200
Message-Id: <1467281973-6889-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dual license the CEC headers, just as we do for videodev2.h.
Also fix an array out-of-bounds bug.

Hans Verkuil (2):
  cec.h/cec-funcs.h: add option to use BSD license
  cec-adap: prevent write to out-of-bounds array index

 drivers/staging/media/cec/cec-adap.c | 13 ++++++++-----
 include/linux/cec-funcs.h            | 16 ++++++++++++++++
 include/linux/cec.h                  | 16 ++++++++++++++++
 3 files changed, 40 insertions(+), 5 deletions(-)

-- 
2.7.0

