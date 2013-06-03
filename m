Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3918 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3FCJhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:11 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id r539axxC001109
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 3 Jun 2013 11:37:02 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id CC6AD35E004A
	for <linux-media@vger.kernel.org>; Mon,  3 Jun 2013 11:36:53 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 00/13] Remove current_norm
Date: Mon,  3 Jun 2013 11:36:37 +0200
Message-Id: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The use of current_norm to keep track of the current standard has been
deprecated for quite some time. This patch series converts the last users
of current_norm to g_std so we can drop it from the core.

It was a bad idea to introduce this at the time: since it is a per-device
node field it didn't work for drivers that create multiple nodes, all sharing
the same tuner (e.g. video and vbi nodes, or a raw video node and a compressed
video node). In addition it was very surprising behavior that g_std was
implemented in the core. Often drivers implemented both g_std and current_norm,
because they didn't understand how it should be used.

Since the benefits were very limited (if they were there at all), it is better
to just drop it and require that drivers just implement g_std.

Regards,

	Hans

