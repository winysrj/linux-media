Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1163 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3A3OyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 09:54:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>
Subject: [RFC PATCH 0/6] convert radio-miropcm20 to the latest frameworks
Date: Wed, 30 Jan 2013 15:53:58 +0100
Message-Id: <1359557644-10982-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I worked on this driver last year but never had the opportunity to post this
work until now. It's cleaned up, rebased, tested on my miropcm20 and it passes
all v4l2-compliance tests.

I've also worked on RDS support for this driver, but that's not ready yet
as that needs more testing.

Regards,

	Hans

