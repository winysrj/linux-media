Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4787 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbaFPJY4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 05:24:56 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id s5G9OqjQ004220
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 11:24:54 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0980E2A1FCC
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 11:24:40 +0200 (CEST)
Message-ID: <539EB7D7.3000003@xs4all.nl>
Date: Mon, 16 Jun 2014 11:24:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC ATTN] Remove vbi-test.c, v4lgrab.c and qv4l2-qt3 from v4l-utils
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there any objection if the vbi-test.c and v4lgrab.c utilities are removed from
the v4l-utils.git? The v4lgrab.c is a v4l1 capture utility that no longer works
since CONFIG_VIDEO_V4L1_COMPAT no longer exists.

vbi-test.c just prints the vbi parameters, which 'v4l2-ctl --get-fmt-vbi' also
does. If we want to keep this, then I'll just remove the CONFIG_VIDEO_V4L1_COMPAT
parts of the code, keeping just the v4l2 API code.

I would also like to remove the Qt3 version of qv4l2 (contrib qv4l2-qt3). It
doesn't build anyway, and nobody is using qt3 anymore.

Regards,

	Hans
