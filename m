Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:35773 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab2EFKPN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 May 2012 06:15:13 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH v2 0/3] gspca - ov534: saturation and hue (using fixp-arith.h)
Date: Sun,  6 May 2012 12:14:55 +0200
Message-Id: <1336299298-17517-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <20120505102614.31395c2979f0b7aac0c8a107@studenti.unina.it>
References: <20120505102614.31395c2979f0b7aac0c8a107@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am sending a second version of this patchset, changes since version 1 are
annotated per-patch.

Just FYI I intend to work on porting ov534 to v4l2 framework too once these
ones go in and the gspca core changes about that settle a bit.

Thanks,
   Antonio

Antonio Ospite (3):
  gspca - ov534: Add Saturation control
  Input: move drivers/input/fixp-arith.h to include/linux
  gspca - ov534: Add Hue control

 drivers/input/ff-memless.c        |    3 +-
 drivers/input/fixp-arith.h        |   87 ----------------------
 drivers/media/video/gspca/ov534.c |  146 +++++++++++++++++++++++++++----------
 include/linux/fixp-arith.h        |   87 ++++++++++++++++++++++
 4 files changed, 195 insertions(+), 128 deletions(-)
 delete mode 100644 drivers/input/fixp-arith.h
 create mode 100644 include/linux/fixp-arith.h

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
