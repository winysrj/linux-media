Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2624 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab1I3MUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 08:20:04 -0400
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p8UCK26H075990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 14:20:03 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost.localdomain (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 114905EE0323
	for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 14:20:00 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 0/7] V4L menu reorganization
Date: Fri, 30 Sep 2011 14:18:27 +0200
Message-Id: <1317385114-7475-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v2:

- Make a separate section for ISA and parport drivers, so no longer
  call it legacy.
- Make a separate section for PCI(e) drivers.

I haven't made a separate section for platform drivers. I want to wait with
that until Guennadi's patch series is merged.

Regards,

	Hans

