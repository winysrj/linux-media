Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3006 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3DJLP6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 07:15:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [REVIEW PATCH 0/2] dt3155v4l: Two fixes.
Date: Wed, 10 Apr 2013 13:15:45 +0200
Message-Id: <1365592547-21951-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This small patch series fixes two different bugs in dt3155v4l: it fixes a
mutex locking bug in the open() function and it switches the driver to the
monotonic clock (as all drivers should use).

I've tested this on actual hardware, and I hope to post more fixes for this
driver for 3.11. But I'd like to get these two fixes in for 3.10 since
especially the first bug makes the driver unusable.

Regards,

	Hans

