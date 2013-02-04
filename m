Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4775 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3BDMgg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 07:36:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [RFC PATCH 1/8] stk-webcam: various fixes.
Date: Mon,  4 Feb 2013 13:36:13 +0100
Message-Id: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series updates this driver to the control framework, switches
it to unlocked_ioctl, fixes a variety of V4L2 compliance issues.

It compiles, but to my knowledge nobody has hardware to test this :-(

If anyone has hardware to test this, please let me know!

Regards,

	Hans

