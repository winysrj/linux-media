Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3331 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2ISOiY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 10:38:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [RFCv1 PATCH 0/6] vb2 & multiplanar fixes/changes
Date: Wed, 19 Sep 2012 16:37:34 +0200
Message-Id: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RFC PATCH series is related to this email I sent:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg52193.html

I've decided to fix the plane verification problem. This is done in the
first three patches. The fourth patch fills in the length field as I
proposed in the mail above.

The fifth fixes a bug for PREPARE_BUF in the multiplanar case that I came
across by accident.

The last patch updates the DocBook and clarifies a number of things.

Comments are welcome, in particular with regards to the fourth patch.

	Hans

