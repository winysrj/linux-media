Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54899 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1BSQg0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Feb 2011 11:36:26 -0500
Received: by eye27 with SMTP id 27so2314919eye.19
        for <linux-media@vger.kernel.org>; Sat, 19 Feb 2011 08:36:25 -0800 (PST)
From: David Cohen <dacohen@gmail.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, hverkuil@xs4all.nl
Subject: [RFC/PATCH 0/1] Get rid of V4L2 internal device interface usage
Date: Sat, 19 Feb 2011 18:35:46 +0200
Message-Id: <1298133347-26796-1-git-send-email-dacohen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

This is the first patch (set) version to remove V4L2 internal device interface.
I have converted tcm825x VGA sensor to V4L2 sub device interface. I removed
also some workarounds in the driver which doesn't fit anymore in its new
interface.

TODO:
 - Remove V4L2 int device interface from omap24xxcam driver.
 - Define a new interface to handle xclk. OMAP3 ISP could be used as base.
 - Use some base platform (probably N8X0) to add board code and test them.
 - Remove V4L2 int device. :)

Br,

David
---

David Cohen (1):
  tcm825x: convert driver to V4L2 sub device interface

 drivers/media/video/tcm825x.c |  369 ++++++++++++-----------------------------
 drivers/media/video/tcm825x.h |    6 +-
 2 files changed, 109 insertions(+), 266 deletions(-)

