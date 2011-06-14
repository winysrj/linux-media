Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2175 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab1FNPWv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 11:22:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
Subject: [RFCv1 PATCH 0/8] Allocate events per-event-type, v4l2-ctrls cleanup
Date: Tue, 14 Jun 2011 17:22:25 +0200
Message-Id: <1308064953-11156-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series consists of two parts: the first four patches change the
way events are allocated and what to do when the event queue is full.

These first four patches are the most important ones to review. The big
change is that event allocation now happens when subscribing an event.
So you not only specify which event you want to subscribe to for a particular
filehandle, but also how many events should be reserved for that event type.
Currently the driver specifies the number of events to allocate, but later
this can be something that the application might want to set manually.

This ensures that for each event type you will never entirely miss all events
of a particular type. Currently this is a real possibility.

The other change is that instead of dropping the new event if there is no more
space available, the oldest event is dropped. This ensures that you get at
least the latest state. And optionally a merge function can be provided that
merges information of two events into one. This allows the control event to
require just one event: if a new event is raised, then the new and old one
can be merged and all state is preserved. Only the intermediate steps are
no longer available. This makes for very good behavior of events and is IMHO
a requirement for using the control event in a real production environment.

The second four patches reorganize the way extended controls are processed
in the control framework. This is the first step towards allowing control
changes from within interrupt handlers. The main purpose is to move as much
code as possible out of the critical sections. This reduces the size of
those sections, making it easier to eventually switch to spinlocks for
certain kinds of controls.

It's lots of internal churn, so it's probably not easy to review. There are
no real functional changes, however.

Regards,

	Hans

