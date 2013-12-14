Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4038 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3LNL2x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 06:28:53 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id rBEBSo68029199
	for <linux-media@vger.kernel.org>; Sat, 14 Dec 2013 12:28:52 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.192.168.1.1 (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 52F072A2224
	for <linux-media@vger.kernel.org>; Sat, 14 Dec 2013 12:28:39 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 00/15] saa7134: cleanup
Date: Sat, 14 Dec 2013 12:28:22 +0100
Message-Id: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the update version of an earlier cleanup patch series:

http://www.spinics.net/lists/linux-media/msg64974.html

I clearly completely forgot about this patch series, as the RFCv2 is from
June.

This version is rebased to the latest master, but otherwise unchanged.

I want to start converting saa7134 to vb2, and this patch series is a good
base for that.

If there are no comments, then I plan on making a pull request on Friday.

Regards,

	Hans

