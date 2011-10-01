Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55153 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1JAAd7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 20:33:59 -0400
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] [media] tvp5150: Migrate to media-controller framework and add video format detection
Date: Sat,  1 Oct 2011 02:33:48 +0200
Message-Id: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The tvp5150 video decoder is usually used on a video pipeline with several
video processing integrated circuits. So the driver has to be migrated to
the new media device API to reflect this at the software level.

Also the tvp5150 is able to detect what is the video standard at which
the device is currently operating, so it makes sense to add video format
detection in the driver as well as.

This patch-set migrates the tvp5150 driver to the MCF and adds video format detection.

It is composed of the following patches:

