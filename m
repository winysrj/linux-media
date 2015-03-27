Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:36071 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbC0M0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 08:26:43 -0400
Received: by qcto4 with SMTP id o4so14567927qct.3
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2015 05:26:43 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 27 Mar 2015 08:26:43 -0400
Message-ID: <CALzAhNXBw-cCvdfb=DjvKaMfk3JEyoAEGA_nPec4+=Hetj_yRA@mail.gmail.com>
Subject: [GIT PULL] Adding HVR2205/HVR2255 support / misc cleanup
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Thank you for taking care of the git.linuxtv.org ssh issues earlier this week.

Long awaited patches for the Hauppauge HVR2205 and HVR2255 in this patchset.
Along with a fix for the querycap warning being thrown on newer kernels.

Thanks,

- Steve

The following changes since commit 4708e452aa3109fc23e0c6b5a658ccc1b720dfa6:
  [media] saa7164: I2C improvements for upcoming HVR2255/2205 boards
(2015-03-23 14:37:32 -0400)


are available in the git repository at:
  git://git.linuxtv.org/stoth/media_tree.git saa7164-dev

for you to fetch changes up to f40a40d48a9cacefd900314984cce887ddc23142:
  [media] saa7164: Copyright update (2015-03-23 15:08:15 -0400)


----------------------------------------------------------------

Steven Toth (5):

      [media] saa7164: Adding additional I2C debug.
      [media] saa7164: Improvements for I2C handling
      [media] saa7164: Add Digital TV support for the HVR2255 and HVR2205
      [media] saa7164: Fixup recent querycap warnings
      [media] saa7164: Copyright update

 drivers/media/pci/saa7164/saa7164-api.c     |  21 +++--
 drivers/media/pci/saa7164/saa7164-buffer.c  |   2 +-
 drivers/media/pci/saa7164/saa7164-bus.c     |   2 +-
 drivers/media/pci/saa7164/saa7164-cards.c   | 188
+++++++++++++++++++++++++++++++++++++++++++-

 drivers/media/pci/saa7164/saa7164-cmd.c     |   2 +-
 drivers/media/pci/saa7164/saa7164-core.c    |   2 +-
 drivers/media/pci/saa7164/saa7164-dvb.c     | 232
+++++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/media/pci/saa7164/saa7164-encoder.c |   5 +-
 drivers/media/pci/saa7164/saa7164-fw.c      |   2 +-
 drivers/media/pci/saa7164/saa7164-i2c.c     |   2 +-
 drivers/media/pci/saa7164/saa7164-reg.h     |   2 +-
 drivers/media/pci/saa7164/saa7164-types.h   |   2 +-
 drivers/media/pci/saa7164/saa7164-vbi.c     |   5 +-
 drivers/media/pci/saa7164/saa7164.h         |   7 +-
 14 files changed, 440 insertions(+), 34 deletions(-)

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
