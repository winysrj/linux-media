Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:37715 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964963AbaLMLxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:53:11 -0500
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E576B2A008E
	for <linux-media@vger.kernel.org>; Sat, 13 Dec 2014 12:53:01 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/10] Sparse fixes
Date: Sat, 13 Dec 2014 12:52:50 +0100
Message-Id: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes almost all remaining sparse warnings. The only one
still there is this one in this platform driver:

.../platform/timblogiw.c:562:22: warning: context imbalance in 'buffer_queue' - unexpected unlock

Note that due to a bug in the daily build process not all media drivers were
checked with sparse. Now that I've fixed the build script I got a bunch of new
sparse warnings and one error. Those new sparse messages are addressed by
patches 6-10. Several of those fix real bugs too.

Regards,

	Hans

