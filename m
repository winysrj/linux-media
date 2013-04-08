Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1444 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934608Ab3DHKrw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:47:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>
Subject: [REVIEW PATCH 0/7] radio-si4713: driver overhaul
Date: Mon,  8 Apr 2013 12:47:34 +0200
Message-Id: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series makes radio-si4713 compliant with v4l2-compliance.

Eduardo, thanks for testing the previous code. I hope this version resolves
all the issues we found. Can you test again?

This code is also available here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/si4713b

Make sure you also update v4l2-compliance: I found a bug in the way RDS
capabilities were tested.

Regards,

	Hans

