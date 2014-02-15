Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46701 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753833AbaBOUvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 15:51:40 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, k.debski@samsung.com,
	hverkuil@xs4all.nl
Subject: [PATCH v5 0/7] Fix buffer timestamp documentation, add new timestamp flags
Date: Sat, 15 Feb 2014 22:52:58 +0200
Message-Id: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the fifth version of the set after a long break. v4 (including
v4.[12]) can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg67445.html>

since v4.2:

- In a few places in documentation it was stated that setting timestamp for
  output devices will affect the time the frame is displayed. The patch now
  removes that statement. Patch 1/7.

- SOF timestamp was changed into SOE timestamp to signify start of exposure.
  This corresponds to what the UVC devices do according to the spec. SOE is
  only valid for CAPTURE queues. 

- Timestamp is always copied from source to destination, not the other way
  around. Drivers affected were exynos-gsc, m2m-deinterlace and mx2_emmaprp.
  Patch 5/7. Kamil: could you check especially this one, please?

- Timestamp source flags are copied but not the timestamp type (which, well,
  is always "COPY". Change all m2m drivers to do so.

-- 
Kind regards,
Sakari

