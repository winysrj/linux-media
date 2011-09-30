Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3024 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab1I3JBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 05:01:30 -0400
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id p8U91KZ8092114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 11:01:29 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost.localdomain (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 712695EE0323
	for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 11:01:18 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 0/7] V4L menu reorganization
Date: Fri, 30 Sep 2011 11:01:09 +0200
Message-Id: <1317373276-5818-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the second version of my patch series reorganizing the V4L menu.
It's based on the latest v3.2 staging tree.

Changes to v1:

- Remove unnecessary USB dependency.
- Reorganize the radio menu as well.

I did not sort the drivers alphabetically (yet). I'm not quite sure whether
that's really a good idea, and we can always do that later.

This series is meant for v3.2, but I won't make a pull request until
Guennadi's pull request is merged first. I'm sure I will have to redo my
patches once his series is in.

Regards,

	Hans

