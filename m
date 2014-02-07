Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1429 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbaBGMUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 07:20:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: edubezval@gmail.com
Subject: [RFC PATCH 0/7] si4713 enhancements, add miro RDS support
Date: Fri,  7 Feb 2014 13:19:33 +0100
Message-Id: <1391775580-29907-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds some missing RDS functionality to the si4713
driver. In addition it adds back support for RDS to the radio-miropcm20
driver that was dropped somewhere around the 2.6.2x timeframe.

It's been tested with a miropcm20 board, an si4713 board and a si470x
based usb stick.

Regards,

	Hans

