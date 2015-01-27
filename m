Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40484 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932412AbbA0Qze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 11:55:34 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 03E8A2A0092
	for <linux-media@vger.kernel.org>; Tue, 27 Jan 2015 17:55:03 +0100 (CET)
Message-ID: <54C7C2E6.9000805@xs4all.nl>
Date: Tue, 27 Jan 2015 17:55:02 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES for v3.19] vivid: Y offset should depend on quant. range
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I discovered this bug today and it explains why vivid behaved so strangely
when generating full range Y'CbCr patterns. It was introduced in 3.19, so it
would be really nice if this can be fixed before 3.19 is released.

Regards,

	Hans

The following changes since commit 8d44aeefcd79e9be3b6db4f37efc7544995b619e:

  [media] rtl28xxu: change module unregister order (2015-01-27 10:57:58 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19c

for you to fetch changes up to 593a7b12b9dfe06ed39d6a22ebf8774992341130:

  vivid: Y offset should depend on quant. range (2015-01-27 17:46:17 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      vivid: Y offset should depend on quant. range

 drivers/media/platform/vivid/vivid-tpg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)
