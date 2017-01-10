Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:44074 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760633AbdAJL5J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 06:57:09 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL v2 FOR v4.10] CEC fix and update cec documentation
Message-ID: <2027f14e-1bd1-6fde-086d-ffacfe22b71a@xs4all.nl>
Date: Tue, 10 Jan 2017 12:57:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two cec documentation updates and one CEC framework fix.

Regards,

	Hans

The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

   [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v4.10f

for you to fetch changes up to 65d3b33b9adcc96f48246f6bb1d9ab14ccca70bf:

   cec: fix wrong last_la determination (2017-01-10 12:54:15 +0100)

----------------------------------------------------------------
Hans Verkuil (3):
       cec rst: remove "This API is not yet finalized" notice
       cec-intro.rst: mention the v4l-utils package and CEC utilities
       cec: fix wrong last_la determination

  Documentation/media/uapi/cec/cec-func-close.rst           |  5 -----
  Documentation/media/uapi/cec/cec-func-ioctl.rst           |  5 -----
  Documentation/media/uapi/cec/cec-func-open.rst            |  5 -----
  Documentation/media/uapi/cec/cec-func-poll.rst            |  5 -----
  Documentation/media/uapi/cec/cec-intro.rst                | 17 ++++++++++++-----
  Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst      |  5 -----
  Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst |  5 -----
  Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst |  5 -----
  Documentation/media/uapi/cec/cec-ioc-dqevent.rst          |  5 -----
  Documentation/media/uapi/cec/cec-ioc-g-mode.rst           |  5 -----
  Documentation/media/uapi/cec/cec-ioc-receive.rst          |  5 -----
  drivers/media/cec/cec-adap.c                              |  2 +-
  12 files changed, 13 insertions(+), 56 deletions(-)
