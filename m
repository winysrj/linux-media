Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34154 "EHLO
        homiemail-a56.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751849AbeAEO51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Jan 2018 09:57:27 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/2] lgdt3306a: fix bugs in usb disconnect/reconnect
Date: Fri,  5 Jan 2018 08:57:11 -0600
Message-Id: <1515164233-2423-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a couple problems currently in this driver, when used as
an i2c_device. This patch set addresses the issues one at a time.

First during process of dvb frontend detach release is called, then
if CONFIG_MEDIA_ATTACH is enabled, the usage count is decremented.
Remove is then called, further decrementing the usage count, to negative
if a single device was attached. Patch one uses dvb_attach to keep the
usage count in sync on removal. I'm not sure if there is a less
'hacky' way to handle this. On a previous attempt I just NULL'd out
release in probe, which just hid the issue. Another way of sorting
out was doing a symbol_get on _attach, but the included patch seems
most consistent behaviour.

Next, there is a double kfree of state which can cause oops/GPF/etc
randomly on removal. In the process of dvb frontend detach release
is called before remove. The problem is _release kfree's state, then
right after _remove cleans up members of state, before kfree'ing
state itself. Patch 2 does not kfree state in _release if the
driver was probed and therefore _remove will be called.


Brad Love (2):
  lgdt3306a: Fix module count mismatch on usb unplug
  lgdt3306a: Fix a double kfree on i2c device remove

 drivers/media/dvb-frontends/lgdt3306a.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

-- 
2.7.4
