Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4934 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929Ab2FBL62 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2012 07:58:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [RFCv1 PATCH 0/6] Clean up zr364xx
Date: Sat,  2 Jun 2012 13:58:14 +0200
Message-Id: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series (intended for 3.6) cleans up the zr364xx driver.

It's updated to the latest frameworks (except vb2) and I've tested it
with an Aiptek DV3300.

It now passes the v4l2-compliance tests.

Regards,

	Hans

