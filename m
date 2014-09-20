Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3948 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaITNTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 09:19:42 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8KDJdHs060649
	for <linux-media@vger.kernel.org>; Sat, 20 Sep 2014 15:19:41 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D1CED2A002F
	for <linux-media@vger.kernel.org>; Sat, 20 Sep 2014 15:19:34 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv3 0/2] cx23885: two more fixes
Date: Sat, 20 Sep 2014 15:19:31 +0200
Message-Id: <1411219173-32869-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two patches were part of the cx23885 v2 patch series that converted
the driver to vb2, but were left out when that series was merged. Mauro
had some questions about the size helper functions and I wanted to double
check the VBI changes with closed captioning in NTSC.

I figured out what was going on with norm_maxw and I have now tested the
VBI support for cx23885. While the original VBI change in cx23885_risc_vbibuffer()
was OK, there were a few other things that were wrong, so those are fixed
as well.

Regards,

	Hans

