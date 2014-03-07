Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4321 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaCGKhz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 05:37:55 -0500
Received: from tschai.lan (173-38-208-170.cisco.com [173.38.208.170])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s27Abqlx006339
	for <linux-media@vger.kernel.org>; Fri, 7 Mar 2014 11:37:54 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E81D82A1887
	for <linux-media@vger.kernel.org>; Fri,  7 Mar 2014 11:37:50 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH for v3.14 0/3] Three fixes
Date: Fri,  7 Mar 2014 11:37:46 +0100
Message-Id: <1394188669-22260-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes three bugs that have been there for a long time:

1/3: since 3.7
2/3: since 3.12
3/3: since forever (at least 2.6.31, the oldest I checked)

I'll make a pull request for this on Monday if there are no comments.

Regards,

	Hans

