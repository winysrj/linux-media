Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3173 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaIQJOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 05:14:52 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8H9Em4F075265
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 11:14:50 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5EA1A2A0553
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 11:14:34 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] vb2/saa7134 regression/documentation fixes
Date: Wed, 17 Sep 2014 11:14:28 +0200
Message-Id: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the VBI regression seen in saa7134 when it was converted
to vb2. Tested with my saa7134 board.

It also updates the poll documentation and fixes a saa7134 bug where
the WSS signal was never captured.

The first patch should go to 3.17. It won't apply to older kernels,
so I guess once this is merged we should post a patch to stable for
those older kernels, certainly 3.16.

I would expect this to be an issue for em28xx as well, but I will
need to test that. If that driver is affected as well, then this
fix needs to go into 3.9 and up.

Regards,

	Hans

