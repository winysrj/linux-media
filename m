Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59765 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751733AbeCVLzu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 07:55:50 -0400
Date: Thu, 22 Mar 2018 11:55:48 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.17] rc imon protocol docs warning
Message-ID: <20180322115548.hkwohsieeiomh6ra@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a fix for the warning about RC_PROTO_IMON.

Sorry about that!

Sean

The following changes since commit 238f694e1b7f8297f1256c57e41f69c39576c9b4:

  media: v4l2-common: fix a compilation breakage (2018-03-21 16:07:01 -0400)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.17e

for you to fetch changes up to dfa9beb9d546b0a538a4c4719064712bc447f079:

  media: rc docs: fix warning for RC_PROTO_IMON (2018-03-22 10:54:51 +0000)

----------------------------------------------------------------
Sean Young (1):
      media: rc docs: fix warning for RC_PROTO_IMON

 Documentation/media/lirc.h.rst.exceptions | 1 +
 1 file changed, 1 insertion(+)
