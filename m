Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:39494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab0LPTAu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 14:00:50 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBGJ0nTs000846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 14:00:49 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 0/4] mceusb and related fixups
Date: Thu, 16 Dec 2010 14:00:33 -0500
Message-Id: <1292526037-21491-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Just a few mceusb-centric patches to fix some minor issues.

Jarod Wilson (4):
  mceusb: fix inverted mask inversion logic
  mceusb: set a default rx timeout
  rc: conversion is to microseconds, not nanoseconds
  mceusb: add another Fintek device ID

 drivers/media/rc/ene_ir.c |   16 ++++++++--------
 drivers/media/rc/ene_ir.h |    2 --
 drivers/media/rc/mceusb.c |   30 ++++++++++++++++--------------
 include/media/rc-core.h   |    1 +
 4 files changed, 25 insertions(+), 24 deletions(-)

