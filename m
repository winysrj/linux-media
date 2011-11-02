Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab1KBKNG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Nov 2011 06:13:06 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Various ctrl and event frame work patches (version 3)
Date: Wed,  2 Nov 2011 11:13:20 +0100
Message-Id: <1320228805-9097-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This patch set obsoletes my previous "add v4l2_subscribed_event_ops" set,
while working on adding support for ctrl-events to the uvc driver I found
a few bugs in the event code, which this patchset fixes.

Changes since version 1:
------------------------

4/5 v4l2-event: Add v4l2_subscribed_event_ops:
-Added a documentation update (update v4l2-framework.txt) to:

Changes since version 2:
------------------------

2/5 v4l2-event: Remove pending events from fh event queue:
-Simplify loop

3/5 v4l2-event: Don't set sev->fh to NULL on unsubscribe
-Remove sev->fh != NULL check from send_event
-Extend commit message with info how the old set to NULL + check code was
 actually race and why simply removing this is safe

4/5 v4l2-event: Add v4l2_subscribed_event_ops:
-Ignore queuing events for subscribed_event-s which add op has not completed
 yet


Regards,

Hans


