Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1946 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaHJLSf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 07:18:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: wbrack@mmm.com.hk
Subject: [PATCH 0/2] Add driver for tw68xx PCI grabber boards
Date: Sun, 10 Aug 2014 13:17:11 +0200
Message-Id: <1407669433-13571-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the tw68 driver. The driver has been out-of-tree for many
years on gitorious: https://gitorious.org/tw68/tw68-v2

I have refactored and ported that driver to the latest V4L2 core frameworks.

Tested with my Techwell tw6805a and tw6816 grabber boards.

Note that there is no audio support. If anyone is interested in adding alsa
support, please contact me. It's definitely doable.

These devices are quite common and people are using the out-of-tree driver,
so it would be nice to have proper support for this in the mainline kernel.

Regards,

	Hans

