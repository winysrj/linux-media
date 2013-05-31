Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3920 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3EaKC6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:02:58 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id r4VA2k2n024011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 31 May 2013 12:02:48 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id D5F1935E0073
	for <linux-media@vger.kernel.org>; Fri, 31 May 2013 12:02:43 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/21] Control framework conversions
Date: Fri, 31 May 2013 12:02:20 +0200
Message-Id: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This continues my ongoing work to convert drivers to the control framework.

These conversions touch upon rarely used drivers. The only one I could
actually test was the saa6752hs conversion. All others are untested because
I do not have the hardware.

Ondrej, I know you have a radio-sf16fmi board. I'd appreciate it if you could
test these patches for me. If you could run v4l2-compliance, then that would
be great.

I don't believe anyone has a working timberdale environment or a tea5764 setup.
If you do, and you are willing to test, then let me know. Otherwise those
changes will go in untested.

Regards,

	Hans

