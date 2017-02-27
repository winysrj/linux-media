Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36809 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751390AbdB0OYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 09:24:54 -0500
Received: from tschai.fritz.box (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id B37D81802DD
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2017 15:20:42 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/9] cec: code and doc fixes/improvements
Date: Mon, 27 Feb 2017 15:20:33 +0100
Message-Id: <20170227142042.37085-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Besides various documentation and logging improvements, the main
addition to CEC is support for a special corner case:

When the physical address is invalid, it is still allowed by the CEC
specification to send messages from 0xf ('Unregistered') to 0 ('TV').

This is a workaround for devices that pull their HPD pin low when they
go into standby or switch to another input, even though CEC messages are
still working.

Regards,

	Hans

Hans Verkuil (9):
  cec: documentation fixes
  cec: improve flushing queue
  cec: allow specific messages even when unconfigured
  cec: return -EPERM when no LAs are configured
  cec: document the error codes
  cec: document the special unconfigured case
  cec: use __func__ in log messages.
  cec: improve cec_transmit_msg_fh logging
  cec: log reason for returning -EINVAL

 Documentation/media/uapi/cec/cec-func-ioctl.rst    |   2 +-
 Documentation/media/uapi/cec/cec-func-open.rst     |   2 +-
 Documentation/media/uapi/cec/cec-func-poll.rst     |   4 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |  13 ++
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    |  13 ++
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  13 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |  12 ++
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |  55 ++++++++-
 drivers/media/cec/cec-adap.c                       | 134 +++++++++++++--------
 drivers/media/cec/cec-api.c                        |  21 +++-
 10 files changed, 208 insertions(+), 61 deletions(-)

-- 
2.11.0
