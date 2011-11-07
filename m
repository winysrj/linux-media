Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4619 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1KGKhj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 05:37:39 -0500
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id pA7AbaFm070319
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 7 Nov 2011 11:37:37 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost.localdomain (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 2E0AC11800D6
	for <linux-media@vger.kernel.org>; Mon,  7 Nov 2011 11:37:30 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 0/3] Per-device-node capabilities
Date: Mon,  7 Nov 2011 11:37:23 +0100
Message-Id: <1320662246-8531-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the recent V4L-DVB workshop we discussed the meaning of the capabilities
field as returned by QUERYCAP. Historically these capabilities refer to the
capabilities of the video device as a whole, and not to the capabilities of the
filehandle through which QUERYCAP was called.

So QUERYCAP would give the same capabilities for video device nodes as it would
for vbi or radio device nodes.

For more complex devices it is very desirable to give the caps for just the
current device node.

This patch series adds this functionality to V4L2 by adding a new global
capability bit and a new device_caps field:

#define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */

struct v4l2_capability {
	...
	__u32   device_caps;    /* Device node capabilities */
	...
}

It implements it for vivi and ivtv as well.

I haven't updated the documentation yet as I want to get a round of
feedback first. Especially with regards to the naming: I decided to call it
'device_caps' since for applications the term 'device' is fairly unambiguous
IMHO.

Comments?

	Hans

