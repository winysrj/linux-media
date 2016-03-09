Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:11221 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153AbcCIQDb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 11:03:31 -0500
From: Antonio Ospite <ao2@ao2.it>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Antonio Ospite <ao2@ao2.it>
Subject: [PATCH 0/7] gspca: pass all v4l2-compliance tests + minor fixes
Date: Wed,  9 Mar 2016 17:03:14 +0100
Message-Id: <1457539401-11515-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

after applying this patchset gspca passes all v4l2-compliance tests, at
least it does with a PS3 Eye.

 - Patch 1 removes some magic numbers in subdrivers.
 - Patch 2 is a correctness fix, but it does not bring any functional
   changes.
 - Patch 3 is a readability improvement by itself, but it's also
   a preliminary change for patch 4.
 - Patches from 4 to 7 are the actual compliance fixes.

More details are in the commit messages.

Thanks,
   Antonio

Antonio Ospite (7):
  [media] gspca: ov534/topro: use a define for the default framerate
  [media] gspca: fix setting frame interval type in
    vidioc_enum_frameintervals()
  [media] gspca: rename wxh_to_mode() to wxh_to_nearest_mode()
  [media] gspca: fix a v4l2-compliance failure about
    VIDIOC_ENUM_FRAMEINTERVALS
  [media] gspca: fix a v4l2-compliance failure about buffer timestamp
  [media] gspca: fix a v4l2-compliance failure during VIDIOC_REQBUFS
  [media] gspca: fix a v4l2-compliance failure during read()

 drivers/media/usb/gspca/gspca.c | 36 +++++++++++++++++++++++-------------
 drivers/media/usb/gspca/ov534.c |  7 +++----
 drivers/media/usb/gspca/topro.c |  6 ++++--
 3 files changed, 30 insertions(+), 19 deletions(-)

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
