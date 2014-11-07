Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60640 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbaKGMfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 07:35:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: jean-michel.hautbois@vodalys.com
Subject: [PATCH 0/3] adv: fix G/S_EDID behavior
Date: Fri,  7 Nov 2014 13:34:54 +0100
Message-Id: <1415363697-32583-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes the adv7604, adv7842 and adv7511 G/S_EDID behavior.
All three have been tested with v4l2-compliance and pass.

Jean-Michel, I based the adv7604 patch on your patch, but I reworked it a bit.
I hope you don't mind.

Regards,

	Hans

