Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48677 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbaKEIR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 03:17:59 -0500
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4778F2A0432
	for <linux-media@vger.kernel.org>; Wed,  5 Nov 2014 09:17:54 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/8] Fix sparse warnings/error
Date: Wed,  5 Nov 2014 09:17:44 +0100
Message-Id: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another round of sparse fixes. After this there are two drivers that still
have a lot of warnings: cx88 (caused by a sparse bug, I've reported this on
the sparse mailinglist) and saa7164.

Regards,

	Hans

