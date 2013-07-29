Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1694 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3G2Mlc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:41:32 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id r6TCfKJK058264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 29 Jul 2013 14:41:23 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 2A15135E0403
	for <linux-media@vger.kernel.org>; Mon, 29 Jul 2013 14:41:15 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/8] dv-timings improvements, cleanups and fixes
Date: Mon, 29 Jul 2013 14:40:53 +0200
Message-Id: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series collects all dv-timings helper code into a new
v4l2-dv-timings module. There aren't that many drivers that use HDTV
timings, so it makes no sense to have a lot of HDTV related code in
v4l2-common.

It also fixes a few bugs (Prabhakar: please check patch 7/8!) and it
adds new helper functions that allows drivers to select timings based
on their hardware capabilities.

This reorganization will also make it easier in the near future to add
functionality that uses VIC codes to retrieve the corresponding CEA-861
timing.

Regards,

	Hans

