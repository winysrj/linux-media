Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4400 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbaAaNcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 08:32:22 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id s0VDWJvB002263
	for <linux-media@vger.kernel.org>; Fri, 31 Jan 2014 14:32:21 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.cisco.com (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 6C7F22A00A4
	for <linux-media@vger.kernel.org>; Fri, 31 Jan 2014 14:32:07 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 0/2] Update timings to latest VESA standard
Date: Fri, 31 Jan 2014 14:32:14 +0100
Message-Id: <1391175136-27875-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two patches: the first adds the new 4K DMT timings, the second adds a
note to the v4l2_detect_cvt function that support for the new 'reduced
blanking version 2' CVT formula is not yet implemented.

It should eventually be implemented, but even if we did I am not sure it
is possible to test it since it is very new indeed.

Regards,

	Hans

