Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2782 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3CTSjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 14:39:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>
Subject: [REVIEW PATCH 00/11] hdpvr cleanup
Date: Wed, 20 Mar 2013 19:38:51 +0100
Message-Id: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series updates the hdpvr driver to the latest v4l2 frameworks
(except, as usual, vb2).

It has been tested with my hdpvr and a HDTV signal generator and it looks
pretty good. I did discover that you need the latest firmware to have the
hdpvr handle input and format switches correctly. I had major problems with
the old firmware that was on my box when I started testing.

Janne, there is no entry for this driver in the MAINTAINERS file. Are you
still maintainer for this driver? If so, can you make a MAINTAINERS entry
for this driver?

Regards,

	Hans

