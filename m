Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63113 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1IXXlj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 19:41:39 -0400
Received: by fxe4 with SMTP id 4so4918117fxe.19
        for <linux-media@vger.kernel.org>; Sat, 24 Sep 2011 16:41:38 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Chehab <mchehab@infradead.org>
Subject: [GIT PATCHES FOR 3.2] NetUP Dual DVB-T/C CI RF: fix card hardware revision detection and PID filter for second demux
Date: Sun, 25 Sep 2011 02:41:43 +0300
Cc: linux-media@vger.kernel.org, Abylai Ospan <aospan@netup.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109250241.43967.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 4e2c53fde651be6225d9f940c02b2eabc2f9591c:

  [media] dvb: Add support for pctv452e (2011-09-24 00:07:42 -0300)

are available in the git repository at:
  http://linuxtv.org/git/liplianin/media_tree.git netup_patches

Abylay Ospan (2):
      NetUP Dual DVB-T/C CI RF: fix card hardware revision detect
      NetUP Dual DVB-T/C CI RF: connect hardware PID filtering for second demux/dvr

 drivers/media/video/cx23885/altera-ci.c     |   48 ++++++++++++++++++---------
 drivers/media/video/cx23885/altera-ci.h     |    2 +-
 drivers/media/video/cx23885/cx23885-cards.c |    2 +-
 drivers/media/video/cx23885/cx23885-dvb.c   |    3 +-
 4 files changed, 36 insertions(+), 19 deletions(-)
