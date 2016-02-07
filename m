Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35431 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbcBGUOU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2016 15:14:20 -0500
Received: by mail-wm0-f66.google.com with SMTP id g62so12489788wme.2
        for <linux-media@vger.kernel.org>; Sun, 07 Feb 2016 12:14:20 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 0/3] media: rc: core: expose raw packet data via sysfs
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56B7A573.10804@gmail.com>
Date: Sun, 7 Feb 2016 21:13:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds functionality for exposing raw data via sysfs
to the core. Up to 128 bytes received since the last break of >= 1s
can be read via a binary sysfs attribute.

There are two major use cases:
- getting raw data to be used for defining a wakeup sequence on chips
  supporting wakeup via RC (e.g. nuvoton-cir)
- debugging and raw data analysis purposes

First user of this new feature is the nuvoton-cir driver.

Motivation for this extension is to allow for an easy way to set
wakeup sequences. There have been some attempts in the past for the
nuvoton driver but AFAICS it was never finished.

This patch series is going to be complemented with a patch for the
nuvoton-cir driver adding functionality to set a wakeup sequence
via sysfs.

Eventually setting a wakeup sequence would be as easy as:
- press key to be used for wakeup
- read raw key data from sysfs
- cut raw data after sequence length to be used
- write raw wakeup sequence to sysfs

Works fine here on a Zotac CI321 with nuvoton-cir.

Heiner Kallweit (3):
  media: rc: add core functionality to store the most recent raw data
  media: rc: expose most recent raw packet via sysfs
  media: rc: nuvoton: expose most recent raw packet via sysfs

 drivers/media/rc/nuvoton-cir.c  |  2 ++
 drivers/media/rc/rc-core-priv.h |  6 +++++
 drivers/media/rc/rc-ir-raw.c    | 34 ++++++++++++++++++++++++++
 drivers/media/rc/rc-main.c      | 53 +++++++++++++++++++++++++++++++++++++++++
 include/media/rc-core.h         |  5 +++-
 5 files changed, 99 insertions(+), 1 deletion(-)

-- 
2.7.0

