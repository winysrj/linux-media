Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:44495 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbcGLSHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 14:07:53 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 43713180239
	for <linux-media@vger.kernel.org>; Tue, 12 Jul 2016 20:07:45 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] doc-rst: CEC improvements
Date: Tue, 12 Jul 2016 20:07:43 +0200
Message-Id: <1468346865-36465-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Note: patch 1 assumes this pull request has been merged:

https://patchwork.linuxtv.org/patch/35377/

Regards,

	Hans

Hans Verkuil (2):
  doc-rst: update CEC_RECEIVE
  doc-rst: improve CEC documentation

 Documentation/media/uapi/cec/cec-func-ioctl.rst    |   2 +-
 Documentation/media/uapi/cec/cec-func-open.rst     |  10 +-
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |  18 ++--
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |  14 +--
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    |  14 +--
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |   2 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |  34 +++----
 Documentation/media/uapi/cec/cec-ioc-receive.rst   | 104 +++++++++++----------
 8 files changed, 99 insertions(+), 99 deletions(-)

-- 
2.8.1

