Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33031 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbeBYMbo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 07:31:44 -0500
Received: by mail-wm0-f47.google.com with SMTP id s206so13202414wme.0
        for <linux-media@vger.kernel.org>; Sun, 25 Feb 2018 04:31:43 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 00/12] ngene-updates: Hardware support, TS buffer shift fix
Date: Sun, 25 Feb 2018 13:31:28 +0100
Message-Id: <20180225123140.19486-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Sorry for this quick V2 of this series and thus sorry for the traffic,
spam and noise. V1 missed a 188-byte clamping in tsin_find_offset() and
a recheck for the remaining size of the TS buffer to copy after offset
correction.

Some love for the ngene driver, which runs the older Micronas nGene
based cards from Digital Devices like the cineS2 v5.5.

This series changes:

- Two more PCI IDs for more supported PCIe bridge hardware
- Conversion of all printk() to more proper dev_*() based logging (the
  module_init rather uses pr_*() logging since there's no *dev available
  yet).
- Support for all available DuoFlex addon modules from that vendor. All
  addon modules are electrically compatible and use the same interface,
  and the addons work very well on the aging ngene hardware.
- Check for CXD2099AR addon modules before blindly trying to attach them,
  removing unnecessary and maybe irritating error logging if such module
  isn't present.
- Workaround a hardware quirk in conjunction with the CXD2099AR module,
  CA modules and CAM control communication, causing the TS input buffer
  to shift albeit different communication paths are ought to be in use.

This series is based on the CXD2099 regmap conversion series, see [1].
Especially [2] is required for the STV0367 enablement patch (and the
following ones) since the use of the TDA18212 I2C tuner client relies
on the i2c_client variable to be present, which is added in the
forementioned CXD2099 series.

Please pick this up and merge.

[1] https://www.spinics.net/lists/linux-media/msg129183.html
[2] https://www.spinics.net/lists/linux-media/msg129187.html

Changes since v1:
- TS buffer offset correction missed a check for the remaining buffer
  length before copying the next full 188-byte block, which might could
  have caused out-of-bound-reads from void *buf. Also, tsin_find_offset
  returns it's offset clamped to 188 byte boundaries to not accidentally
  skip over valid TS data. Few typos in the commit message were fixed
  and a note for the modparam was added, too.

Daniel Scheller (12):
  [media] ngene: add two additional PCI IDs
  [media] ngene: convert kernellog printing from printk() to dev_*()
    macros
  [media] ngene: use defines to identify the demod_type
  [media] ngene: support STV0367 DVB-C/T DuoFlex addons
  [media] ngene: add XO2 module support
  [media] ngene: add support for Sony CXD28xx-based DuoFlex modules
  [media] ngene: add support for DuoFlex S2 V4 addon modules
  [media] ngene: deduplicate I2C adapter evaluation
  [media] ngene: check for CXD2099AR presence before attaching
  [media] ngene: don't treat non-existing demods as error
  [media] ngene: move the tsin_exchange() stripcopy block into a
    function
  [media] ngene: compensate for TS buffer offset shifts

 drivers/media/pci/ngene/Kconfig       |   6 +
 drivers/media/pci/ngene/ngene-cards.c | 590 ++++++++++++++++++++++++++++++----
 drivers/media/pci/ngene/ngene-core.c  | 101 +++---
 drivers/media/pci/ngene/ngene-dvb.c   | 133 ++++++--
 drivers/media/pci/ngene/ngene.h       |  23 ++
 5 files changed, 732 insertions(+), 121 deletions(-)

-- 
2.16.1
