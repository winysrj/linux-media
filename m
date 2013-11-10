Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35349 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab3KJRPe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 12:15:34 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 0/2] SDR API related hacks
Date: Sun, 10 Nov 2013 19:15:14 +0200
Message-Id: <1384103716-4690-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Following patched are kinda proof-of-concept stuff for resolving and
testing implementation issues, please do not reply just to say it is
wrong. Instead propose how it should be implemented correctly.

My next plan is to implement simple SDR IP streaming server using
Kernel SDR via libv4l2 in order to get SDRSharp working.

Antti Palosaari (2):
  v4l2: add two pixel format for SDR
  rtl2832_sdr: implement FMT IOCTLs

 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 125 ++++++++++++++---------
 include/uapi/linux/videodev2.h                   |   4 +
 2 files changed, 79 insertions(+), 50 deletions(-)

-- 
1.8.4.2

