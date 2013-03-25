Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2117 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab3CYO4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 10:56:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] au0828 driver overhaul and tuner-core fixes
Date: Mon, 25 Mar 2013 15:56:14 +0100
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251556.14820.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request is unchanged from http://patchwork.linuxtv.org/patch/17577/,
except for being rebased.

I've also added my tuner-core patch and your three tuner-core patches as
requested.

Regards,

	Hans

The following changes since commit 7bce33daeaca26a3ea3f6099fdfe4e11ea46cac6:

  [media] solo6x10: prefix sources with 'solo6x10-' (2013-03-25 08:54:05 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git au0828d

for you to fetch changes up to e9ee202be209c28559eb13d30e630a242e2beb22:

  tuner-core: handle errors when getting signal strength/afc (2013-03-25 15:53:19 +0100)

----------------------------------------------------------------
Hans Verkuil (16):
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
      tuner-core: don't set has_signal/get_afc if not supported

Mauro Carvalho Chehab (3):
      tuner-core: return afc instead of zero
      tuner-core: Remove the now uneeded checks at fe_has_signal/get_afc
      tuner-core: handle errors when getting signal strength/afc

 drivers/media/dvb-frontends/au8522_decoder.c |  123 +++++++++++------------------------
 drivers/media/dvb-frontends/au8522_priv.h    |    6 +-
 drivers/media/usb/au0828/au0828-core.c       |   61 ++++++++++++------
 drivers/media/usb/au0828/au0828-video.c      |  287 ++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------
 drivers/media/usb/au0828/au0828.h            |    7 ++
 drivers/media/v4l2-core/tuner-core.c         |   23 ++++---
 6 files changed, 274 insertions(+), 233 deletions(-)
