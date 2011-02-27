Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52762 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1B0Vjo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 16:39:44 -0500
Received: by bwz15 with SMTP id 15so3241898bwz.19
        for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 13:39:43 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.39] dw2102 updates
Date: Sun, 27 Feb 2011 23:39:49 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102272339.49473.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit 9e650fdb12171a5a5839152863eaab9426984317:

  [media] drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver (2011-02-27 
07:50:42 -0300)

are available in the git repository at:
  git://linuxtv.org/liplianin/media_tree.git dw2102

Igor M. Liplianin (5):
      dw2102: X3M TV SPC1400HD added.
      dw2102: remove unnecessary delays for i2c transfer for some cards.
      dw2102: i2c transfer corrected for some cards.
      dw2102: i2c transfer corrected for yet another cards.
      dw2102: prof 1100 corrected.

 drivers/media/dvb/dvb-usb/dw2102.c |   47 +++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 19 deletions(-)
