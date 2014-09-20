Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3182 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaITMmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:01 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8KCfvYc023127
	for <linux-media@vger.kernel.org>; Sat, 20 Sep 2014 14:41:59 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 426C32A002F
	for <linux-media@vger.kernel.org>; Sat, 20 Sep 2014 14:41:53 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/16] cx88: convert to vb2
Date: Sat, 20 Sep 2014 14:41:35 +0200
Message-Id: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series converts the cx88 driver to vb2. Tested with NTSC and
PAL, video, vbi, audio, mpeg and dvb-t on a Hauppauge WinTV-HVR3000 and
a Hauppauge WinTV-HVR1300.

I see this as something for 3.19 so that there is enough time for testing
since this is a popular card.

Regards,

	Hans

