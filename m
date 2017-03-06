Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47941 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752834AbdCFOOO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:14:14 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] media/cec: fixes and improvements
Message-ID: <f35ce235-cf13-3ccd-f244-001b220c4f3e@xs4all.nl>
Date: Mon, 6 Mar 2017 15:12:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request improves the documentation, fixes a few bugs, and (most importantly)
adds support for sending CEC messages even if there is no physical address. This is
specifically allowed by the CEC specification to work around dubious hotplug detect
behavior in certain displays.

Regards,

	Hans

The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:

   Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git cec-unconfig

for you to fetch changes up to e0e869a750776073bf60403b4a4653ae2dee590a:

   cec: don't Feature Abort msgs from Unregistered (2017-03-06 13:09:05 +0100)

----------------------------------------------------------------
Hans Verkuil (10):
       cec: documentation fixes
       cec: improve flushing queue
       cec: allow specific messages even when unconfigured
       cec: return -EPERM when no LAs are configured
       cec: document the error codes
       cec: document the special unconfigured case
       cec: use __func__ in log messages.
       cec: improve cec_transmit_msg_fh logging
       cec: log reason for returning -EINVAL
       cec: don't Feature Abort msgs from Unregistered

  Documentation/media/uapi/cec/cec-func-ioctl.rst           |   2 +-
  Documentation/media/uapi/cec/cec-func-open.rst            |   2 +-
  Documentation/media/uapi/cec/cec-func-poll.rst            |   4 +-
  Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst |  13 +++++
  Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst |  13 +++++
  Documentation/media/uapi/cec/cec-ioc-dqevent.rst          |  13 ++++-
  Documentation/media/uapi/cec/cec-ioc-g-mode.rst           |  12 ++++
  Documentation/media/uapi/cec/cec-ioc-receive.rst          |  55 +++++++++++++++++-
  drivers/media/cec/cec-adap.c                              | 137 
++++++++++++++++++++++++++++-----------------
  drivers/media/cec/cec-api.c                               |  21 ++++++-
  10 files changed, 211 insertions(+), 61 deletions(-)
