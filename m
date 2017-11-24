Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:43419 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753402AbdKXLoD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 06:44:03 -0500
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/3] Improve CEC autorepeat handling
Date: Fri, 24 Nov 2017 11:43:58 +0000
Message-Id: <cover.1511523174.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the slowness of the CEC bus, autorepeat handling rather special
on CEC. If the repeated user control pressed message is received, a 
keydown repeat should be sent immediately.

By handling this in the input layer, we can remove some ugly code from
cec, which also sends a keyup event after the first keydown, to prevent
autorepeat.

Sean Young (3):
  input: remove redundant check for EV_REP
  input: handle case whether first repeated key triggers repeat
  media: cec: move cec autorepeat handling to rc-core

 Documentation/input/input.rst |  4 +++-
 drivers/input/input.c         | 21 ++++++++++++----
 drivers/media/cec/cec-adap.c  | 56 ++++---------------------------------------
 drivers/media/cec/cec-core.c  | 12 ----------
 drivers/media/rc/rc-main.c    | 10 +++++++-
 include/media/cec.h           |  5 ----
 6 files changed, 33 insertions(+), 75 deletions(-)

-- 
2.14.3
