Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3184 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab2ENTMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 15:12:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFC PATCH 0/2] Proposal to deprecate four drivers
Date: Mon, 14 May 2012 21:11:57 +0200
Message-Id: <1337022719-13868-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

These two patches deprecate the ISA video capture pms driver and the three
parallel port webcam drivers bw-qcam, c-qcam and w9966.

Nobody has hardware for the three parallel port webcams anymore (and we really
tried to get hold of some), and my ISA pms board also no longer works (I suspect
the Pentium motherboard I use for testing ISA cards is too fast :-) ).

I've given up on these drivers. I've posted a pull request to get these drivers
up to speed with regards to the latest frameworks (the pms update has already
been merged), and I think that should be the last change before removing them
altogether. If someone ever gets working hardware for these drivers, then they
are easy to resurrect from the git history should there be a desire to do so.

ISA and parallel port are both unsuitable for streaming video, so this hardware
is really obsolete.

Regards,

	Hans

