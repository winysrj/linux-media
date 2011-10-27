Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab1J0LRs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Oct 2011 07:17:48 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Various ctrl and event frame work patches
Date: Thu, 27 Oct 2011 13:17:57 +0200
Message-Id: <1319714283-3991-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This patch set obsoletes my previous "add v4l2_subscribed_event_ops" set,
while working on adding support for ctrl-events to the uvc driver I found
a few bugs in the event code, which this patchset fixes.

Regards,

Hans



