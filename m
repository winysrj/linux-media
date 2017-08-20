Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38686 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752794AbdHTLxY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 07:53:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] cec fixes, vivid-cec improvements
Date: Sun, 20 Aug 2017 13:53:15 +0200
Message-Id: <20170820115319.26244-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The first two patches add support for CEC pin emulation in the
vivid driver. The third fixes a kernel logging bug in vivid.

The last patch is a bug fix: the CEC adapter was not explicitly
disabled when cec_delete_adapter was called. Normally this does not
cause any problems, but for the upcoming omap4 cec driver it does.

Regards,

	Hans

Hans Verkuil (4):
  cec: replace pin->cur_value by adap->cec_pin_is_high
  vivid: add CEC pin monitoring emulation
  vivid: fix incorrect HDMI input/output CEC logging
  cec: ensure that adap_enable(false) is called from
    cec_delete_adapter()

 drivers/media/cec/cec-adap.c              |  4 +-
 drivers/media/cec/cec-api.c               |  6 +--
 drivers/media/cec/cec-core.c              |  1 +
 drivers/media/cec/cec-pin.c               |  5 +--
 drivers/media/platform/vivid/vivid-cec.c  | 65 ++++++++++++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-core.c |  8 ++--
 include/media/cec-pin.h                   |  1 -
 include/media/cec.h                       |  1 +
 8 files changed, 77 insertions(+), 14 deletions(-)

-- 
2.14.1
