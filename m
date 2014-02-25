Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3820 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaBYKEl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com
Subject: [RFCv1 PATCH 00/20] vb2: more fixes, add dmabuf/expbuf (PART 2)
Date: Tue, 25 Feb 2014 11:04:05 +0100
Message-Id: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series follows on from PART 1: the REVIEWv1 vb2 patch series
just posted.

Patches 1-3 and 11-20 are various code improvements and fixes based
on extensive testing with v4l2-compliance and several test drivers
(vivi and viloop, to be posted later).

Patches 4-10 add support for dmabuf and expbuf to vb2-dma-sg and adds
expbuf support to vmalloc.

This has seen extensive testing as well, but more is needed, in particular
with 'real' hardware as opposed to virtual drivers. I hope to be able to
do some testing for that this week.

Regards,

	Hans

