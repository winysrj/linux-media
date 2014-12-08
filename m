Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38226 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752334AbaLHQX4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 11:23:56 -0500
Received: from telek.fritz.box (telek [192.168.1.29])
	by tschai.lan (Postfix) with ESMTPSA id C33D52A0004
	for <linux-media@vger.kernel.org>; Mon,  8 Dec 2014 17:23:51 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 for v3.19 0/2] cx88: fix broken driver
Date: Mon,  8 Dec 2014 17:23:48 +0100
Message-Id: <1418055830-12687-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first patch was due to the dma-sg changes and the cx88 vb2 conversion
going in as separate patch series, and the cx88 wasn't patched with the
dma-sg changes.

The second was a nasty leftover line from the vb2 conversion that took me
the whole day to track down. One of those annoying bugs that you *know*
must be something obvious, except that you don't see it until suddenly
you do...

Regards,

	Hans

