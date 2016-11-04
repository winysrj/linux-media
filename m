Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:59158 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934754AbcKDO0Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 10:26:24 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10 v2] cec: fix remaining issues and move it from
 staging to drivers/media
Message-ID: <0d064fdf-2a53-4a01-bf7c-9518961c26a9@xs4all.nl>
Date: Fri, 4 Nov 2016 15:26:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This resolves the remaining issues and get it out of staging.

See the cover letter for more info:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg104311.html

Three additional patches are added in this v2:

       cec: sanitize msg.flags
       cec.h/cec-funcs.h: don't use bool in public headers
       cec: an inner loop clobbered the outer loop variable

That last one is rather embarrassing, I'm afraid :-(

Regards,

     Hans


The following changes since commit bd676c0c04ec94bd830b9192e2c33f2c4532278d:

   [media] v4l2-flash-led-class: remove a now unused var (2016-10-24 
18:51:29 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git cec

for you to fetch changes up to 87c6e12062ecf590f497c577fa5f2a34409694b1:

   MAINTAINERS: update paths (2016-11-04 15:21:35 +0100)

----------------------------------------------------------------
Hans Verkuil (14):
       pulse8-cec: set all_device_types when restoring config
       cec rst: convert tables and drop the 'row' comments
       cec: add flag to cec_log_addrs to enable RC passthrough
       cec: add CEC_MSG_FL_REPLY_TO_FOLLOWERS
       cec: filter invalid messages
       cec: accept two replies for CEC_MSG_INITIATE_ARC.
       cec: add proper support for CDC-Only CEC devices
       cec: move the CEC framework out of staging and to media
       cec: sanitize msg.flags
       cec.h/cec-funcs.h: don't use bool in public headers
       cec: an inner loop clobbered the outer loop variable
       pulse8-cec: move out of staging
       s5p-cec/st-cec: update TODOs
       MAINTAINERS: update paths

  Documentation/media/Makefile                                 |   2 +-
  Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst         | 156 
+++++---------
  Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    | 487 
++++++++++++++++--------------------------
  Documentation/media/uapi/cec/cec-ioc-dqevent.rst             | 182 
++++++----------
  Documentation/media/uapi/cec/cec-ioc-g-mode.rst              | 317 
++++++++++++---------------
  Documentation/media/uapi/cec/cec-ioc-receive.rst             | 418 
+++++++++++++++---------------------
  MAINTAINERS                                                  |  10 +-
  drivers/media/Kconfig                                        |  16 ++
  drivers/media/Makefile                                       |   4 +
  drivers/{staging => }/media/cec/Makefile                     |   2 +-
  drivers/{staging => }/media/cec/cec-adap.c                   | 225 
+++++++++++++++++--
  drivers/{staging => }/media/cec/cec-api.c                    |  11 +-
  drivers/{staging => }/media/cec/cec-core.c                   |   0
  drivers/{staging => }/media/cec/cec-priv.h                   |   0
  drivers/media/i2c/Kconfig                                    |   6 +-
  drivers/media/platform/vivid/Kconfig                         |   2 +-
  drivers/media/usb/Kconfig                                    |   5 +
  drivers/media/usb/Makefile                                   |   1 +
  drivers/{staging/media => media/usb}/pulse8-cec/Kconfig      |   2 +-
  drivers/{staging/media => media/usb}/pulse8-cec/Makefile     |   0
  drivers/{staging/media => media/usb}/pulse8-cec/pulse8-cec.c |   8 +
  drivers/staging/media/Kconfig                                |   4 -
  drivers/staging/media/Makefile                               |   2 -
  drivers/staging/media/cec/Kconfig                            |  12 --
  drivers/staging/media/cec/TODO                               |  32 ---
  drivers/staging/media/pulse8-cec/TODO                        |  52 -----
  drivers/staging/media/s5p-cec/Kconfig                        |   2 +-
  drivers/staging/media/s5p-cec/TODO                           |  12 +-
  drivers/staging/media/st-cec/Kconfig                         |   2 +-
  drivers/staging/media/st-cec/TODO                            |   7 +
  include/media/cec.h                                          |   2 +-
  include/uapi/linux/Kbuild                                    |   2 +
  include/{ => uapi}/linux/cec-funcs.h                         |  76 +++----
  include/{ => uapi}/linux/cec.h                               |  94 
++++++--
  34 files changed, 1011 insertions(+), 1142 deletions(-)
  rename drivers/{staging => }/media/cec/Makefile (70%)
  rename drivers/{staging => }/media/cec/cec-adap.c (85%)
  rename drivers/{staging => }/media/cec/cec-api.c (97%)
  rename drivers/{staging => }/media/cec/cec-core.c (100%)
  rename drivers/{staging => }/media/cec/cec-priv.h (100%)
  rename drivers/{staging/media => media/usb}/pulse8-cec/Kconfig (86%)
  rename drivers/{staging/media => media/usb}/pulse8-cec/Makefile (100%)
  rename drivers/{staging/media => media/usb}/pulse8-cec/pulse8-cec.c (97%)
  delete mode 100644 drivers/staging/media/cec/Kconfig
  delete mode 100644 drivers/staging/media/cec/TODO
  delete mode 100644 drivers/staging/media/pulse8-cec/TODO
  create mode 100644 drivers/staging/media/st-cec/TODO
  rename include/{ => uapi}/linux/cec-funcs.h (98%)
  rename include/{ => uapi}/linux/cec.h (93%)
