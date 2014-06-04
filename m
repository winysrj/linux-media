Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:29322 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaFDUbF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jun 2014 16:31:05 -0400
From: Antonio Ospite <ao2@ao2.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ao2@ao2.it>, Hans de Goede <hdegoede@redhat.com>,
	Alexander Sosna <alexander@xxor.de>
Subject: [RFC 0/2] gspca_kinect: add support for the depth stream
Date: Wed,  4 Jun 2014 22:24:57 +0200
Message-Id: <1401913499-6475-1-git-send-email-ao2@ao2.it>
In-Reply-To: <53450D76.2010405@redhat.com>
References: <53450D76.2010405@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Alexander needed to get the depth stream out of a Kinect without using
libusb because he experienced problem with that on the RaspberryPi, and
using v4l2 proved to be useful to him (BTW Alexander any actual
benchmark?).

So with the following patches I want to explore how to support the depth
stream in the mainline driver.

The first patch is about supporting data streams on endpoints other than
the first one in gspca.

The second patch adds support for the depth data to the kinect subdriver.

Some more specific comments are annotated per-patch.

Ciao ciao,
   Antonio

Antonio Ospite (2):
  gspca: provide a mechanism to select a specific transfer endpoint
  gspca_kinect: add support for the depth stream

 drivers/media/usb/gspca/gspca.c  | 20 ++++++---
 drivers/media/usb/gspca/gspca.h  |  1 +
 drivers/media/usb/gspca/kinect.c | 97 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 101 insertions(+), 17 deletions(-)

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
