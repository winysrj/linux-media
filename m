Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:57688 "EHLO
        homiemail-a119.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbeIGBpT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Sep 2018 21:45:19 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mkrufky@linuxtv.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/2] au0828 Oops fix and message correction
Date: Thu,  6 Sep 2018 16:07:47 -0500
Message-Id: <1536268069-25435-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An end user reported oopsing on connection of multiple
Hauppauge 950Q devices. The oops is related to analog
setup failing during usb probe for a device. If analog
setup fails then dev is kfree'd and then drivers usb
disconnect function is called, which requires valid
dev. Hence, immediate oops.

Patch 2 is just error message correction around the
failure spot. An invalid function name is corrected.


Brad Love (2):
  au0828: cannot kfree dev before usb disconnect
  au0828: Fix incorrect error messages

 drivers/media/usb/au0828/au0828-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
2.7.4
