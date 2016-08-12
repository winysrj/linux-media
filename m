Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49566 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbcHLJuC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 05:50:02 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 778B21800A9
	for <linux-media@vger.kernel.org>; Fri, 12 Aug 2016 11:49:57 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH for 4.8 0/2] pulse8-cec fixes
Date: Fri, 12 Aug 2016 11:49:55 +0200
Message-Id: <1470995397-47335-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Two fixes for the pulse8-cec driver. Thanks to Pulse-Eight for
providing me with the additional information so I could resolve
these issues.

Regards,

	Hans

Hans Verkuil (2):
  pulse8-cec: set correct Signal Free Time
  pulse8-cec: fix error handling

 drivers/staging/media/pulse8-cec/pulse8-cec.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.8.1

