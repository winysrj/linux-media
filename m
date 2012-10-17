Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3535 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab2JQJSk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 05:18:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <mats.randgaard@cisco.com>
Subject: [RFC PATCH for v3.7 0/4] adv7604: sync with the latest Cisco internal code
Date: Wed, 17 Oct 2012 11:18:29 +0200
Message-Id: <1350465513-7304-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series syncs up the adv7604 driver in 3.7-rc1 with the latest
version that's in the Cisco internal tree.

Nothing major, just a small cleanup and three bug fixes.

There were no changes for the ad9389b that was also merged for 3.7-rc1.

If there are no comments, then I'll make a pull request for this during the
weekend.

Regards,

	Hans

