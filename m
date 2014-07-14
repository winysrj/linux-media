Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1386 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaGNM7f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 08:59:35 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6ECxV8P027619
	for <linux-media@vger.kernel.org>; Mon, 14 Jul 2014 14:59:33 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from test-media.192.168.1.1 (test [192.168.1.27])
	by tschai.lan (Postfix) with ESMTPSA id 684EA2A1FD1
	for <linux-media@vger.kernel.org>; Mon, 14 Jul 2014 14:59:14 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/12] Pending v4l2 core/doc fixes
Date: Mon, 14 Jul 2014 14:59:00 +0200
Message-Id: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first 9 have been posted before, the last three are new. These are
all little fixes for issues I found while working on the vivi replacement.

Usually all for fairly obscure corner cases, but that's what you write a
test driver for, after all.

If there are no objections, then I'll make a pull request on Friday.

Regards,

	Hans

