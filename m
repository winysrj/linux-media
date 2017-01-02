Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45252 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751353AbdABMPv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 07:15:51 -0500
Received: from tschai.fritz.box (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id BFC341822BE
        for <linux-media@vger.kernel.org>; Mon,  2 Jan 2017 13:15:45 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH for v4.10 0/2] CEC documentation updates
Date: Mon,  2 Jan 2017 13:15:43 +0100
Message-Id: <1483359345-24652-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Two documentation updates that should go to 4.10.

Regards,

	Hans

Hans Verkuil (2):
  cec rst: remove "This API is not yet finalized" notice
  cec-intro.rst: mention the v4l-utils package and CEC utilities

 Documentation/media/uapi/cec/cec-func-close.rst         |  5 -----
 Documentation/media/uapi/cec/cec-func-ioctl.rst         |  5 -----
 Documentation/media/uapi/cec/cec-func-open.rst          |  5 -----
 Documentation/media/uapi/cec/cec-func-poll.rst          |  5 -----
 Documentation/media/uapi/cec/cec-intro.rst              | 17 ++++++++++++-----
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst    |  5 -----
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst         |  5 -----
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst         |  5 -----
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst        |  5 -----
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst         |  5 -----
 Documentation/media/uapi/cec/cec-ioc-receive.rst        |  5 -----
 11 files changed, 12 insertions(+), 55 deletions(-)

-- 
2.8.1

