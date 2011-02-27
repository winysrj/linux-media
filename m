Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62480 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1B0WDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 17:03:12 -0500
Received: by bwz15 with SMTP id 15so3250574bwz.19
        for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 14:03:11 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PATCHES FOR 2.6.39] ds3000: wrong hardware tune function implemented
Date: Mon, 28 Feb 2011 00:03:18 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102280003.18154.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit 9e650fdb12171a5a5839152863eaab9426984317:

  [media] drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver (2011-02-27 
07:50:42 -0300)

are available in the git repository at:
  git://linuxtv.org/liplianin/media_tree.git ds3000-new

Igor M. Liplianin (1):
      ds3000: wrong hardware tune function implemented

 drivers/media/dvb/frontends/ds3000.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)
