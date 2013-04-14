Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1132 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3DNP1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>
Subject: [REVIEW PATCH 00/30] cx25821: driver overhaul
Date: Sun, 14 Apr 2013 17:26:56 +0200
Message-Id: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series cleans up and overhauls the cx25821 driver. The incentive
for doing this are the broken video output nodes that pose a security risk
(thanks to Al Viro for pointing this out).

This is fixed in the first patch. Mauro, this patch should go to 3.9 and
stable.

All other patches are for 3.10 or 3.11.

The end result of these patches is a driver that works fine for capture
and seems to work fine for video output. Although without a card with
a video output I cannot say for certain, mine only has video input. But
I can DMA the frames at 30 Hz for NTSC, so that looks promising :-)

The audio output is not functioning: I need a card with audio output in
order to be able to test that, and this should be implemented as an alsa
driver anyway.

The way the video output is implemented isn't the prettiest code, but compared
to the old code it's a huge improvement. As I mentioned in the commit logs,
this driver should really use vb2 in order to improve the implementation.

There is also a very ugly hack in video_poll that I disabled. poll() is
really the wrong place for that. Once we convert this driver to vb2 that
hack can be implemented in buf_finish, which is the correct place for such
fixups.

This patch series deletes around 2500 lines, so it's a nice code reduction
as well :-)

Regards,

	Hans

