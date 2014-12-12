Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47214 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967664AbaLLN2J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:28:09 -0500
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C50772A008C
	for <linux-media@vger.kernel.org>; Fri, 12 Dec 2014 14:28:01 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/7] cx25821: convert to vb2
Date: Fri, 12 Dec 2014 14:27:53 +0100
Message-Id: <1418390880-39009-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series converts this driver to the vb2 framework.

I have tested video capture with my cx25821 board. Audio capture
DMA works as well, but since my board doesn't have an audio line-in
I couldn't test it with actual audio.

This patch series also removes the last case of btcx-risc abuse, so
that module can now be merged again with bttv, which is where it
belongs.

Regards,

	Hans

