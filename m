Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51166 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1CENAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 08:00:30 -0500
Received: by fxm17 with SMTP id 17so2926645fxm.19
        for <linux-media@vger.kernel.org>; Sat, 05 Mar 2011 05:00:29 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PATCHES FOR 2.6.39] cx23885, altera-ci, stv0367: uncorrected blocks counter and other fixes
Date: Sat, 5 Mar 2011 15:00:38 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103051500.38525.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit 88a763df226facb74fdb254563e30e9efb64275c:

  [media] dw2102: prof 1100 corrected (2011-03-02 16:56:54 -0300)

are available in the git repository at:
  git://linuxtv.org/liplianin/media_tree.git dual_dvb_t_c_ci_rf-1

Abylay Ospan (5):
      cx23885: Altera FPGA CI interface reworked.
      stv0367: change default value for AGC register.
      stv0367: implement uncorrected blocks counter.
      Fix CI code for NetUP Dual DVB-T/C CI RF card
      Force xc5000 firmware loading for NetUP Dual DVB-T/C CI RF card

 drivers/media/dvb/frontends/stv0367.c     |   24 +++++++++++++++++++++---
 drivers/media/video/cx23885/altera-ci.c   |   14 ++++++++++----
 drivers/media/video/cx23885/cx23885-dvb.c |   23 +++++++++++++----------
 3 files changed, 44 insertions(+), 17 deletions(-)
