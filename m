Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2839 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab0JQKoW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 06:44:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.36] Fix msp3400 regression causing mute audio
Date: Sun, 17 Oct 2010 12:43:39 +0200
Cc: Andy Walls <awalls@md.metrocast.net>,
	Shane Shrybman <shrybman@teksavvy.com>,
	ivtv-devel@ivtvdriver.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010171243.39520.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

I hope you can fast-track this to Linus! It's a nasty regression. From the log:

"The switch to the new control framework caused a regression where the audio was
no longer unmuted after the carrier scan finished.

The original code attempted to set the volume control to its current value in
order to have the set-volume control code to be called that handles the volume
and muting. However, the framework will not call that code unless the new volume
value is different from the old.

Instead we now call msp_s_ctrl directly.

It is a bit of a hack: we really need a v4l2_ctrl_refresh_ctrl function for this
(or something along those lines).

Thanks to Andy Walls for bisecting this and to Shane Shrybman for reporting it!"

I've tested this with my PVR-350 and the audio is now working properly again.

The solution I've chosen is correct, but a bit too low-level. For 2.6.37 I hope
I can add some support for this to the control framework itself. It's too late
to do that for 2.6.36 though.

Regards,

	Hans

The following changes since commit d65728875a85ac7c8b7d6eb8d51425bacc188980:
  Marek Szyprowski (1):
        V4L/DVB: v4l: radio: si470x: fix unneeded free_irq() call

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git msp

Hans Verkuil (1):
      msp3400: fix mute audio regression

 drivers/media/video/msp3400-driver.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
