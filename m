Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1349 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383Ab3E1I2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 04:28:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: leo@lumanate.com, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [REVIEW PATCH 0/3] hdpvr: various fixes
Date: Tue, 28 May 2013 10:27:51 +0200
Message-Id: <1369729674-1802-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first patch fixes a bug in querystd: if there is no signal, then
querystd should return V4L2_STD_UNKNOWN. There are more drivers that
return the wrong value here, I have a patch series pending to fix that
and also to improve the spec.

The second does a code cleanup that improves readability, but it doesn't
change the logic.

The third patch is based on a patch from Mauro and a patch from Leo:

https://patchwork.linuxtv.org/patch/18573/
https://linuxtv.org/patch/18399/

This improves the error handling in case usb_control_msg() returns an
error.

Regards,

	Hans

