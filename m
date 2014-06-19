Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56187 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932894AbaFSRXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 13:23:13 -0400
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 803A52123A
	for <linux-media@vger.kernel.org>; Thu, 19 Jun 2014 13:23:12 -0400 (EDT)
Received: from localhost.localdomain (unknown [122.166.155.116])
	by mail.messagingengine.com (Postfix) with ESMTPA id 72429C007AB
	for <linux-media@vger.kernel.org>; Thu, 19 Jun 2014 13:23:11 -0400 (EDT)
From: Ramakrishnan Muthukrishnan <ram@fastmail.in>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH] media: remove V4L2_FL_USE_FH_PRIO flag and its usage.
Date: Thu, 19 Jun 2014 22:52:56 +0530
Message-Id: <1403198580-3126-1-git-send-email-ram@fastmail.in>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since all the drivers that use `struct v4l2_fh' use the core priority
checking, instead of doing it themselves, the flag V4L2_FL_USE_FH_PRIO
can be removed.

This patch series removes the use of this flag in the v4l2-core and also
removes the setting of this flag from the drivers and finally removes the
flag itself.

