Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1028 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaHUUTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:19:47 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id s7LKJi7h023767
	for <linux-media@vger.kernel.org>; Thu, 21 Aug 2014 22:19:46 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 7065E2A2E5A
	for <linux-media@vger.kernel.org>; Thu, 21 Aug 2014 22:19:37 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/12] More sparse fixes
Date: Thu, 21 Aug 2014 22:19:24 +0200
Message-Id: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is a second round of sparse fixes.

After this the remaining sparse warnings are in cx88 (I'm cleaning that one up
anyway, so I'm not going to fix these warnings until after the cleanup is done),
saa7164 (non-trivial to fix, will do this later), some hard ones that will need
more time and probably some discussion and a few that are false positives.

Regards,

        Hans

