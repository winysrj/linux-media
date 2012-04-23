Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:43672 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab2DWNVa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 09:21:30 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Johann Deneux <johann.deneux@gmail.comx>,
	Anssi Hannula <anssi.hannula@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 0/3] gspca - ov534: saturation and hue (using fixp-arith.h)
Date: Mon, 23 Apr 2012 15:21:04 +0200
Message-Id: <1335187267-27940-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

here are a couple more of controls for the gspca ov534 subdriver.

In order to control the HUE value the sensor expects sin(HUE) and
cos(HUE) to be set so I decided to reuse the fixed point implementation
of sine and cosine from drivers/input/fixp-arith.h, see patches 2 and 3.

Dmitry, can the movement of fixp-arith.h in patch 2 go via the media
tree?  That should ease up the integration of patch 3 in this series
I think.

Jonathan, maybe fixp_sin() and fixp_cos() can be used in
drivers/media/video/ov7670.c too where currently ov7670_sine() and
ov7670_cosine() are defined, but I didn't want to send a patch I could
not test.

BTW What is the usual way to communicate these cross-subsystem stuff?
I CC-ed everybody only on the cover letter and on patches 2 and 3 which
are the ones concerning somehow both "input" and "media".

Thanks,
   Antonio


Antonio Ospite (3):
  [media] gspca - ov534: Add Saturation control
  Input: move drivers/input/fixp-arith.h to include/linux
  [media] gspca - ov534: Add Hue control

 drivers/input/ff-memless.c        |    3 +-
 drivers/input/fixp-arith.h        |   87 ------------------------------------
 drivers/media/video/gspca/ov534.c |   89 ++++++++++++++++++++++++++++++++++++-
 include/linux/fixp-arith.h        |   87 ++++++++++++++++++++++++++++++++++++
 4 files changed, 176 insertions(+), 90 deletions(-)
 delete mode 100644 drivers/input/fixp-arith.h
 create mode 100644 include/linux/fixp-arith.h

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
