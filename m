Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4931 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaHTW7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:39 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id s7KMxZ61088004
	for <linux-media@vger.kernel.org>; Thu, 21 Aug 2014 00:59:37 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 194CC2A2E5A
	for <linux-media@vger.kernel.org>; Thu, 21 Aug 2014 00:59:30 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/29] Sparse fixes
Date: Thu, 21 Aug 2014 00:58:59 +0200
Message-Id: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After attending a session on coccinelle, smatch and sparse I got inspired
to clean up a lot of sparse warnings.

Most are trivial, but I found a true bug in kinect. Also a lot of these
fixes relate to big/little endian.

