Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35762 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1B0VgJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 16:36:09 -0500
Received: by bwz15 with SMTP id 15so3240488bwz.19
        for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 13:36:08 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PATCHES FOR 2.6.39] cx23885, altera-ci: remove operator return <value> in void procedure
Date: Sun, 27 Feb 2011 23:36:13 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102272336.14099.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit 9e650fdb12171a5a5839152863eaab9426984317:

  [media] drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver (2011-02-27 
07:50:42 -0300)

are available in the git repository at:
  git://linuxtv.org/liplianin/media_tree.git dual_dvb_t_c_ci_rf

Igor M. Liplianin (1):
      cx23885, altera-ci: remove operator return <value> in void procedure

 drivers/media/video/cx23885/altera-ci.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
