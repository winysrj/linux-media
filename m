Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:55728 "EHLO
        resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935057AbcJFX6F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Oct 2016 19:58:05 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: corbet@lwn.net, broonie@kernel.org, tglx@linutronix.de,
        mmarek@suse.com, mchehab@kernel.org, davem@davemloft.net,
        ecree@solarflare.com, arnd@arndb.de, j.anaszewski@samsung.com,
        akpm@linux-foundation.org, keescook@chromium.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, dan.j.williams@intel.com,
        aryabinin@virtuozzo.com, tj@kernel.org, jpoimboe@redhat.com,
        nikolay@cumulusnetworks.com, dvyukov@google.com, olof@lixom.net,
        nab@linux-iscsi.org, rostedt@goodmis.org, hans.verkuil@cisco.com,
        valentinrothberg@gmail.com, paul.gortmaker@windriver.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 0/2] Moving runnable code from Documentation (last 2 patches)
Date: Thu,  6 Oct 2016 17:48:50 -0600
Message-Id: <cover.1475792538.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contains the last 2 patches to complete moving runnable
code from Documentation to selftests, samples, and tools.

The first patch moves blackfin gptimers-example to samples, removes
BUILD_DOCSRC and updates BUILD_DOCSRC dependencies.

The second one updates 00-INDEX files under Documentation to reflect the
move of runnable code from Documentation.

Patch 0001 Changes since v1:
- Fixed make htmldocs and make distclean failures. Documentation/Makefile
  is not deleted to avoid these failures. Makefile.sphinx could be renamed
  to be the Documentation Makefile in a future patch.
- Fixed samples/Kconfig error in v1 that preserved the 'CONFIG_'
  prefix (i.e., depends on CONFIG_BLACKFIN && CONFIG_BFIN_GPTIMERS...),
  rendering SAMPLE_BLACKFIN_GPTIMERS to be dead.
- Updated rivers/media/v4l2-core/Kconfig (VIDEO_PCI_SKELETON) dependency
  on BUILD_DOCSRC.
- Added Acks from Jon Corbet, Michal Marek, and reviewed by from Kees Cook
- Added Reported-by from Valentin Rothberg, and Paul Gortmaker.

Patch 0002 Changes since v1:
- Updated Documentation/timers/00-INDEX to remove hpet_example.c. I missed
  this change in v1.
- Added Acks from Jon Corbet, Michal Marek, and reviewed by from Kees Cook

Shuah Khan (2):
  samples: move blackfin gptimers-example from Documentation
  Doc: update 00-INDEX files to reflect the runnable code move

 Documentation/00-INDEX                    |  3 +-
 Documentation/Makefile                    |  2 +-
 Documentation/arm/00-INDEX                |  2 -
 Documentation/blackfin/00-INDEX           |  4 --
 Documentation/blackfin/Makefile           |  5 --
 Documentation/blackfin/gptimers-example.c | 91 -------------------------------
 Documentation/filesystems/00-INDEX        |  2 -
 Documentation/networking/00-INDEX         |  2 -
 Documentation/spi/00-INDEX                |  2 -
 Documentation/timers/00-INDEX             |  4 --
 Makefile                                  |  3 -
 drivers/media/v4l2-core/Kconfig           |  2 +-
 lib/Kconfig.debug                         |  9 ---
 samples/Kconfig                           |  6 ++
 samples/Makefile                          |  2 +-
 samples/blackfin/Makefile                 |  1 +
 samples/blackfin/gptimers-example.c       | 91 +++++++++++++++++++++++++++++++
 17 files changed, 103 insertions(+), 128 deletions(-)
 delete mode 100644 Documentation/blackfin/Makefile
 delete mode 100644 Documentation/blackfin/gptimers-example.c
 create mode 100644 samples/blackfin/Makefile
 create mode 100644 samples/blackfin/gptimers-example.c

-- 
2.7.4

