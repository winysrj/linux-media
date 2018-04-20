Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36915 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754757AbeDTMcV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 08:32:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>
Subject: [PATCH 0/4] More COMPILE_TEST patches to build all media drivers on x86_64
Date: Fri, 20 Apr 2018 08:32:12 -0400
Message-Id: <cover.1524227382.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While now all media drivers build with COMPILE_TEST on i386, there are still
a few of them that don't build on x86_64.

Making them compiling there is just a matter of touching Kconfig files.

While here, fix smatch warnings when building the siano driver on big endian
architectures.

Mauro Carvalho Chehab (4):
  media: radio: allow building ISA drivers with COMPILE_TEST
  media: sta2x11_vip: allow build with COMPILE_TEST
  sound, media: allow building ISA drivers it with COMPILE_TEST
  media: siano: get rid of __le32/__le16 cast warnings

 drivers/media/common/siano/smsendian.c | 14 ++++++------
 drivers/media/pci/sta2x11/Kconfig      |  2 +-
 drivers/media/radio/Kconfig            | 41 +++++++++++++++++++++-------------
 sound/isa/Kconfig                      |  9 ++++----
 4 files changed, 39 insertions(+), 27 deletions(-)

-- 
2.14.3
