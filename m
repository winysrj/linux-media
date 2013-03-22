Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1308 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933862Ab3CVQWb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 12:22:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] au0828 driver overhaul
Date: Fri, 22 Mar 2013 17:22:24 +0100
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221722.24739.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This pull request converts the au0828/au8522 drivers to the latest frameworks,
except for vb2 as usual.

Tested with a WinTV aero generously donated by Hauppauge some time ago.

I also did a lot of fixes in the disconnect handling and setting up the
right routing/std information at the right time.

It works fine with qv4l2, but there is still a bug causing tvtime to fail.
That's caused by commit e58071f024aa337b7ce41682578b33895b024f8b, applied
August last year, that broke g_tuner: after that 'signal' would always be 0
and tvtime expects signal to be non-zero for a valid frequency. The signal
field is set by the au8522, but g_tuner is only called for the tuner (well,
also for au8522 but since the i2c gate is set for the tuner that won't do
anything).

I have a patch for that but I want to convert that to using an i2c mux instead.

For the time being I'd like to get this merged since at least it is in a
lot better shape.

Note: this pull request sits on top of this 'const' pull request:

http://patchwork.linuxtv.org/patch/17568/

Regards,

        Hans

The following changes since commit 8bf1a5a826d06a9b6f65b3e8dffb9be59d8937c3:

  v4l2-ioctl: add precision when printing names. (2013-03-22 11:59:21 +0100)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git au0828b

for you to fetch changes up to 9b216a590115ea8aac389b9bb9248b7adce25f7f:

  au0828: improve firmware loading & locking. (2013-03-22 17:13:57 +0100)

----------------------------------------------------------------
Hans Verkuil (15):
      au8522_decoder: convert to the control framework.
      au0828: fix querycap.
      au0828: frequency handling fixes.
      au0828: fix intendation coding style issue.
      au0828: fix audio input handling.
      au0828: convert to the control framework.
      au0828: add prio, control event and log_status support
      au0828: add try_fmt_vbi support, zero vbi.reserved, pix.priv.
      au0828: replace deprecated current_norm by g_std.
      au8522_decoder: remove obsolete control ops.
      au0828: fix disconnect sequence.
      au0828: simplify i2c_gate_ctrl.
      au0828: don't change global state information on open().
      au0828: fix initial video routing.
      au0828: improve firmware loading & locking.

 drivers/media/dvb-frontends/au8522_decoder.c |  123 ++++++++------------------
 drivers/media/dvb-frontends/au8522_priv.h    |    6 +-
 drivers/media/usb/au0828/au0828-core.c       |   61 +++++++++----
 drivers/media/usb/au0828/au0828-video.c      |  286 ++++++++++++++++++++++++++++++++++++------------------------
 drivers/media/usb/au0828/au0828.h            |    7 ++
 5 files changed, 260 insertions(+), 223 deletions(-)
