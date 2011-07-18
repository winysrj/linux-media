Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab1GRTyd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 15:54:33 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6IJsXPf025505
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 15:54:33 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH v2 0/9] mceusb updates per MS docs
Date: Mon, 18 Jul 2011 15:54:20 -0400
Message-Id: <1311018869-22794-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1310681394-3530-1-git-send-email-jarod@redhat.com>
References: <1310681394-3530-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a stack of updates made based on the Windows Media Center remote
and receiver/transmitter specification and requirements document that
Rafi Rubin recently pointed me at. Its titled
Windows-Media-Center-RC-IR-Collection-Green-Button-Specification-03-08-2011-V2.pdf
which as of this writing, is publicly available from
download.microsoft.com.

Tested with 7 different mceusb devices, with no ill effects. Unfortunately,
for the most part, these chagnes don't actually improve any shortcomings in
the driver, but they do give us a better view of the hardware features and
whatnot, and a few things are better explained now, with most of the command
and response bits lining up with what MS has documented.

v2: use msleep instead of mdelay, and fix a tx regression in v1

Jarod Wilson (9):
  [media] mceusb: command/response updates from MS docs
  [media] mceusb: give hardware time to reply to cmds
  [media] mceusb: set wakeup bits for IR-based resume
  [media] mceusb: issue device resume cmd when needed
  [media] mceusb: query device for firmware emulator version
  [media] mceusb: get misc port data from hardware
  [media] mceusb: flash LED (emu v2+ only) to signal end of init
  [media] mceusb: report actual tx frequencies
  [media] mceusb: update version, copyright, author

 drivers/media/rc/mceusb.c |  410 +++++++++++++++++++++++++++++++--------------
 1 files changed, 280 insertions(+), 130 deletions(-)

