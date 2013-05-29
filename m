Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2352 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965572Ab3E2OTW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:22 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id r4TEJBmx014129
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 29 May 2013 16:19:13 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id D957835E0024
	for <linux-media@vger.kernel.org>; Wed, 29 May 2013 16:19:09 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 00/14] QUERYSTD fixes
Date: Wed, 29 May 2013 16:18:53 +0200
Message-Id: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series cleans up various drivers with respect to their
VIDIOC_QUERYSTD behavior. The main reason for doing this is to ensure
that the correct std value is returned when there is no signal detected.
It should return V4L2_STD_UNKNOWN. Due to a poorly worded specification
several drivers returned STD_ALL.

As mentioned in an old RFC the current behavior is inconsistent:

- saa7115, ks0127, saa7191 return 0 with std set to V4L2_STD_ALL
- adv7180, vpx3220 return 0 with std set to V4L2_STD_UNKNOWN
- saa7110 returns 0 with std set to the current std
- bt819 and bttv do not handle this case at all, and just pick 50 Hz or 60 Hz
- tvp514x returns -EINVAL.

Besides fixing this I also update the documentation and fix the misuse
of s_std(V4L2_STD_ALL) in several drivers. V4L2_STD_ALL is sometimes used
to enable autodetect mode, which is non-standard and in general should not
be done: if a receiver switches from a 60 Hz to a 50 Hz format automatically,
then this can in theory lead to buffer overruns in a DMA engine since a 50 Hz
frame is larger than the 60 Hz frame.

This behavior is removed in those drivers where it is clearly bogus.

After this patch series the following drivers still have problems:

- adv7180: supports the non-standard autodetect mode
- sta2x11: ditto (uses adv7180)

The adv7180 driver should implement querystd in the same manner as the adv7183
driver, and then the sta2x11 can be fixed as well.

- timblogiw: this calls querystd whenever a video node is opened. That's
  obviously a bad idea, but it's a fair amount of work to fix this and nobody
  I know can test this driver.

Regards,

	Hans

