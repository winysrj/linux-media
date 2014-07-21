Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3691 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbaGUNqJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 09:46:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH 0/7] si4713/miropcm20: RDS enhancements
Date: Mon, 21 Jul 2014 15:45:36 +0200
Message-Id: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds a bunch of missing RDS TX controls and implements
them in the si4713 driver. It also adds back RDS support to the miropcm20
driver.

The Alternate Frequencies control is a u32 array since there can be up to
25 alternate frequencies. This was also the reason why I am only now posting
this series since it had to wait for compound control support to go in.

I've tested both drivers with my si4713 and miropcm20 boards.

Regards,

	Hans

