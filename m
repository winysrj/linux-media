Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:43675 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751119AbdBWL5E (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 06:57:04 -0500
Date: Thu, 23 Feb 2017 11:57:02 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.11] RC fixes
Message-ID: <20170223115702.GA22913@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Two fixes for setting up the keymap when a RC device is plugged in; this
has been broken since v4.5. When ir-keytable is run from udev, the problem
wasn't visible since the protocols file was written again with the right
protocol.

Thanks,
Sean

The following changes since commit e6b377dbbb944d5e3ceef4e5d429fc5c841e3692:

  Merge tag 'v4.10' into patchwork (2017-02-22 07:44:15 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.11e

for you to fetch changes up to 92f2e5711f440075e8e6264d37006b6f1c5b1724:

  [media] rc: protocol is not set on register for raw IR devices (2017-02-23 11:04:46 +0000)

----------------------------------------------------------------
Sean Young (2):
      [media] rc: raw decoder for keymap protocol is not loaded on register
      [media] rc: protocol is not set on register for raw IR devices

 drivers/media/rc/rc-main.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)
