Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2928 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2EKHz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>
Subject: saa7146 & related drivers clean up
Date: Fri, 11 May 2012 09:54:54 +0200
Message-Id: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series cleans up saa7146, mxb, hexium-orion, hexium-gemini and
av7110. These drivers now all pass the v4l2-compliance tests.

I've tested with all of these cards, the only driver I was unable to test is the
budget driver as I don't have hardware for it.

All changes only apply to the V4L2 side of these drivers.

Two patches relate to vivi: I've extended the number of supported pixelformats.
This makes it easier to test the various variants.

If someone happens to have a budget card and can run test-compliance for it,
then I'd appreciate this.

Regards,

	Hans

