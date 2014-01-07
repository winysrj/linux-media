Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1538 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaAGNHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 08:07:08 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id s07D74RG095235
	for <linux-media@vger.kernel.org>; Tue, 7 Jan 2014 14:07:06 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.192.168.1.1 (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3242C2A009A
	for <linux-media@vger.kernel.org>; Tue,  7 Jan 2014 14:06:59 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/6] DocBook media: fixes
Date: Tue,  7 Jan 2014 14:06:51 +0100
Message-Id: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series corrects a number of things that have annoyed me for
a long time, particularly at the start of the common.xml file where a
lot of the V4L2 basic behavior is described that is by now very much
out of date.

In addition the old incorrect packed RGB table is finally replaced by
the fixed version in the last patch: the original table is really,
really wrong and any driver that still follows that (none that I am
aware of) should be fixed.

Regards,

	Hans

