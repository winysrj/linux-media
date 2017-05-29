Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:47923 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750837AbdE2FTJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 01:19:09 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] cec kernel config fixes
Message-ID: <86d47e74-1977-5d2f-e58d-8107873902e0@xs4all.nl>
Date: Mon, 29 May 2017 07:19:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 From the cover letter of the patch series:

While working on drm CEC drivers I realized that the correct config
setup is a pain. The problem is that the CEC subsystem is really independent
of the media subsystem: both media and drm drivers can use it.

So this patch series moves the core CEC kernel config options outside the
"Multimedia support" menu and drivers that want to use CEC should select
CEC_CORE. This also ensures that the cec framework will be correctly build
as either a module or a built-in.

The only missing piece is that drm drivers that use cec-notifier.h need to
add a 'select CEC_CORE if CEC_NOTIFIER' to their Kconfig. That would allow
the removal of the ugly 'IS_REACHABLE' construct in cec-notifier.h.

But that can be done for 4.13.

Enabling the RC integration is still part of the MEDIA_CEC_SUPPORT menu,
since it obviously relies on the media rc core.

The second patch renames MEDIA_CEC_NOTIFIER to CEC_NOTIFIER since
this too is not part of the media subsystem and is instead selected by
drivers that want to use it.

The last patch drops the MEDIA_CEC_DEBUG kernel config option: instead
just rely on DEBUG_FS. There really is no need for this additional option,
and in fact it would require enabled the media subsystem just to enable
the CEC debugfs support when used by a drm driver.

I want to get this in for 4.12 while there are no drm drivers yet that
integrate CEC support.

Regards,

         Hans

The following changes since commit 36bcba973ad478042d1ffc6e89afd92e8bd17030:

   [media] mtk_vcodec_dec: return error at mtk_vdec_pic_info_update() (2017-05-19 07:12:05 -0300)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git cec-config

for you to fetch changes up to c3e855ff8f8b5a4a210c5f3b6b2b3de93e9a491a:

   cec: drop MEDIA_CEC_DEBUG (2017-05-28 11:36:04 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
       cec: select CEC_CORE instead of depend on it
       cec: rename MEDIA_CEC_NOTIFIER to CEC_NOTIFIER
       cec: drop MEDIA_CEC_DEBUG

  drivers/media/Kconfig                    |  6 ++++++
  drivers/media/Makefile                   |  4 ++--
  drivers/media/cec/Kconfig                | 14 --------------
  drivers/media/cec/Makefile               |  2 +-
  drivers/media/cec/cec-adap.c             |  2 +-
  drivers/media/cec/cec-core.c             |  8 ++++----
  drivers/media/i2c/Kconfig                |  9 ++++++---
  drivers/media/platform/Kconfig           | 10 ++++++----
  drivers/media/platform/vivid/Kconfig     |  3 ++-
  drivers/media/usb/pulse8-cec/Kconfig     |  3 ++-
  drivers/media/usb/rainshadow-cec/Kconfig |  3 ++-
  include/media/cec-notifier.h             |  2 +-
  include/media/cec.h                      |  4 ++--
  13 files changed, 35 insertions(+), 35 deletions(-)
