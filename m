Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2805 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3BYLG4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Feb 2013 06:06:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] ISA radio fixes
Date: Mon, 25 Feb 2013 12:06:50 +0100
Cc: Steven Toth <stoth@kernellabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302251206.50181.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These are two small fixes for 3.10:

- capabilities were mixed up in radio-isa
- fixed a mute bug in radio-rtrack2: I got hold of a radio-rtrack2 card so
  I could finally test this driver with real hardware.

Thanks to Steve Toth for helping me obtain this card!

Regards,

	Hans

The following changes since commit ed72d37a33fdf43dc47787fe220532cdec9da528:

  [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff) (2013-02-13 18:05:29 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git radio-isa

for you to fetch changes up to 54a2b5393931a4b794b9505158a158585822e3cf:

  radio-rtrack2: fix mute bug. (2013-02-25 12:00:15 +0100)

----------------------------------------------------------------
Hans Verkuil (2):
      radio-isa: fix querycap capabilities code.
      radio-rtrack2: fix mute bug.

 drivers/media/radio/radio-isa.c     |    4 ++--
 drivers/media/radio/radio-rtrack2.c |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)
