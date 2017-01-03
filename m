Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:55696 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934621AbdACI07 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jan 2017 03:26:59 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10] Update cec documentation
Message-ID: <8ec443a4-160e-6a8a-1f1f-829c9d396c23@xs4all.nl>
Date: Tue, 3 Jan 2017 09:26:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two cec doc updates for 4.10.

Regards,

	Hans

The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

  [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.10f

for you to fetch changes up to f9bc1dfdf63abb2653e10294619c3fae877a08b4:

  cec-intro.rst: mention the v4l-utils package and CEC utilities (2017-01-02 12:54:24 +0100)

----------------------------------------------------------------
Hans Verkuil (2):
      cec rst: remove "This API is not yet finalized" notice
      cec-intro.rst: mention the v4l-utils package and CEC utilities

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
 11 files changed, 12 insertions(+), 55 deletions(-)
