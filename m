Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab1JaPQb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 11:16:31 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Various ctrl and event frame work patches (version 2)
Date: Mon, 31 Oct 2011 16:16:43 +0100
Message-Id: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This patch set obsoletes my previous "add v4l2_subscribed_event_ops" set,
while working on adding support for ctrl-events to the uvc driver I found
a few bugs in the event code, which this patchset fixes.

Changes since version 1:
-Added a documentation update (update v4l2-framework.txt) to:
 "v4l2-event: Add v4l2_subscribed_event_ops"

Regards,

Hans


