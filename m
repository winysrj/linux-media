Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4210 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab3FTNor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 09:44:47 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5KDiZFI031935
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 15:44:37 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 24C5735E00D8
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 15:44:33 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 00/15] saa7134: cleanup
Date: Thu, 20 Jun 2013 15:44:16 +0200
Message-Id: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second version of an earlier cleanup patch series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg62863.html

Several patches of that earlier series have already been merged, but the move
of the queue data away from saa7134_fh caused some concern.

After testing with xdtv and xawtv I can say that recording while displaying
at the same time works OK. Neither of these apps is combining streaming and
reading as Mauro suspected. Mauro, I wonder if you were confused with overlay
plus streaming?

Note that xdtv calls STREAMON before calling QBUF, something saa7134 doesn't
like at all (not related to any of my changes). I had to modify xdtv to queue
before calling STREAMON before it would even work with saa7134.

Anyway, I've kept my changes from the earlier patch series and added a few
other issues I found (particularly with saa6588).

I also tried to replace .ioctl by .unlocked_ioctl, but I got into a messy
videobuf situation, so I've postponed that.

Regards,

	Hans

