Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:61253 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaATTj6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 14:39:58 -0500
Received: by mail-la0-f48.google.com with SMTP id er20so5812902lab.21
        for <linux-media@vger.kernel.org>; Mon, 20 Jan 2014 11:39:56 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFC PATCH 0/4] rc: Adding support for sysfs wakeup scancodes
Date: Mon, 20 Jan 2014 21:39:43 +0200
Message-Id: <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
In-Reply-To: <20140115173559.7e53239a@samsung.com>
References: <20140115173559.7e53239a@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series introduces a simple sysfs file interface for reading
and writing wakeup scancodes to rc drivers.

This is an improved version of my previous patch for nuvoton-cir which
did the same thing via module parameters. This is a more generic
approach allowing other drivers to utilize the interface as well.

I did not port winbond-cir to this method of wakeup scancode setting yet
because I don't have the hardware to test it and I wanted first to get
some comments about how the patch series looks. I did however write a
simple support to read and write scancodes to rc-loopback module.

Antti Seppälä (4):
  rc-core: Add defintions needed for sysfs callback
  rc-core: Add support for reading/writing wakeup scancodes via sysfs
  rc-loopback: Add support for reading/writing wakeup scancodes via
    sysfs
  nuvoton-cir: Add support for reading/writing wakeup scancodes via
    sysfs

 drivers/media/rc/nuvoton-cir.c |  81 ++++++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h |   2 +
 drivers/media/rc/rc-loopback.c |  31 ++++++++++
 drivers/media/rc/rc-main.c     | 129 +++++++++++++++++++++++++++++++++++++++++
 include/media/rc-core.h        |  13 +++++
 5 files changed, 256 insertions(+)

-- 
1.8.3.2

