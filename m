Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4682 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab1FGPF2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 11:05:28 -0400
Received: from tschai.lan (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id p57F5QqK037616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 17:05:27 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 00/18] Add Control Event and autofoo/foo support
Date: Tue,  7 Jun 2011 17:05:05 +0200
Message-Id: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is the third (and hopefully last) patch series for control events
and autofoo/foo support. If there are no more major comments, then I will
post a pull request by the end of the week.

Main changes since the previous series:

- The original plan was to toggle the READ_ONLY flag for the manual controls
  in an autocluster if e.g. autogain was set to true. But that caused weird
  behavior, so it was changed to toggling the INACTIVE flag. See also this:
  http://www.spinics.net/lists/linux-media/msg33297.html for more background
  information regarding this decision.

  This decision also simplified some of the patches, so the v4l2_ctrl_flags
  and v4l2_ctrl_flags_lock functions in RFCv2 are no longer present in this v3.

- Added compat32 support for VIDIOC_DQEVENT. This turned out to be missing.

- Add control event support in ivtv.

- The vivi patches were cleaned up substantially. They contained some old
  stuff from earlier experiments. All that has been removed.

- Rebased everything on top of for_v3.1.

Once this is merged, then I want to look into allowing drivers to change
control values from interrupt context (this will only work for certain
types of controls) and to redo the event internals.

Regards,

	Hans

