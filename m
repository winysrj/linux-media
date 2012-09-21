Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2904 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab2IULoj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 07:44:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFC PATCH 0/3] In non-blocking mode return EAGAIN in hwseek
Date: Fri, 21 Sep 2012 13:44:25 +0200
Message-Id: <1348227868-20895-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series resolves a problem with S_HW_FREQ_SEEK when called in
non-blocking mode. Currently this would actually block during the seek.

This is not a good idea. This patch changes the spec and the drivers to
return -EAGAIN when called in non-blocking mode.

In the future actual support for non-blocking mode might be added to
selected drivers, but that will require a new event (SEEK_READY or something
like that), and I am not convinced it is worth the effort anyway.

Regards,

	Hans

