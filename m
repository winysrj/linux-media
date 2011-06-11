Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1546 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586Ab1FKPFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 11:05:40 -0400
Received: from tschai.lan (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id p5BF5c2L016385
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 11 Jun 2011 17:05:39 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
Date: Sat, 11 Jun 2011 17:05:26 +0200
Message-Id: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Second version of this patch series.

It's the same as RFCv1, except that I dropped the g_frequency and
g_tuner/s_tuner patches (patch 3, 6 and 7 in the original patch series)
because I need to think more on those, and I added a new fix for tuner_resume
which was broken as well.

Regards,

	Hans

