Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1848 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab2A0TiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 14:38:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 0/2] Add event helper functions.
Date: Fri, 27 Jan 2012 20:37:45 +0100
Message-Id: <1327693067-31914-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many drivers just support control events, and most radio drivers just need
to poll for control events. Add some functions to simplify those jobs.

These two patches sit on top of these two:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/44032

