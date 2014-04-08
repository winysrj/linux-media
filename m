Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3883 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385AbaDHIJF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 04:09:05 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id s38891eN018562
	for <linux-media@vger.kernel.org>; Tue, 8 Apr 2014 10:09:03 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from cobaltpc1.cisco.com (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 14A962A03F8
	for <linux-media@vger.kernel.org>; Tue,  8 Apr 2014 10:08:45 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] v4l2-dv-timings: add 4K timings
Date: Tue,  8 Apr 2014 10:07:34 +0200
Message-Id: <1396944456-20008-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the new CEA-861-F 4K timings to the list of predefined timings.
This prepares V4L2 for use with HDMI 2.0.

Regards,

	Hans

