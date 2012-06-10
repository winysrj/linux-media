Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1579 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2FJKzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:55:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [RFCv1 PATCH 00/11] cx88: convert to the control framework
Date: Sun, 10 Jun 2012 12:54:46 +0200
Message-Id: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series converts the cx88 driver to use the control framework,
and it also fixes various other things so that v4l2-compliance likes it
a lot better.

It also replaces .ioctl with .unlocked_ioctl in cx88-blackbird. I don't
think I need to do extra locking myself, but let me know if I have to.

This work is part of my effort to bring all v4l2 drivers up to speed with
regards to all the new frameworks that we have. And yes, I am ignoring vb2
at the moment as this is already hard enough, especially for a complex
driver like cx88.

Note that is patch series assumes that these patches are already applied:

http://patchwork.linuxtv.org/patch/11509/

Regards,

	Hans

