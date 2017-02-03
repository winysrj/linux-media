Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:45229 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752315AbdBCNNe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Feb 2017 08:13:34 -0500
Date: Fri, 3 Feb 2017 13:13:32 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [GIT PULL FOR v4.11] More RC updates
Message-ID: <20170203131332.GA19378@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some last minute changes which would be nice to have in v4.11, nothing
controversial here.

Thanks,

Sean

The following changes since commit e7b3a2b22176d01db0c3b31d6389ccf542ba1967:

  [media] st-hva: hva_dbg_summary() should be static (2017-01-31 12:02:33 -0200)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.11c

for you to fetch changes up to a47c577a6d061187f009d4d84e3c0c5432e809b5:

  [media] mce_kbd: add missing keys from UK layout (2017-02-02 23:17:18 +0000)

----------------------------------------------------------------
Martin Blumenstingl (2):
      [media] Documentation: devicetree: meson-ir: "linux,rc-map-name" is supported
      [media] Documentation: devicetree: add the RC map name of the geekbox remote

Sean Young (2):
      [media] lirc: cannot read from tx-only device
      [media] mce_kbd: add missing keys from UK layout

 Documentation/devicetree/bindings/media/meson-ir.txt | 3 +++
 Documentation/devicetree/bindings/media/rc.txt       | 1 +
 drivers/media/rc/ir-mce_kbd-decoder.c                | 2 +-
 drivers/media/rc/keymaps/rc-rc6-mce.c                | 1 +
 drivers/media/rc/lirc_dev.c                          | 3 +++
 5 files changed, 9 insertions(+), 1 deletion(-)
