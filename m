Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47322 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab1B1UHE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 15:07:04 -0500
Received: by bwz15 with SMTP id 15so4002916bwz.19
        for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 12:07:03 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.39] cx23885, altera-ci: remove operator return <value> in void procedure
Date: Mon, 28 Feb 2011 22:07:11 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201102272336.14099.liplianin@me.by>
In-Reply-To: <201102272336.14099.liplianin@me.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102282207.11320.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit 9e650fdb12171a5a5839152863eaab9426984317:

  [media] drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver (2011-02-27 
07:50:42 -0300)

are available in the git repository at:
  git://linuxtv.org/liplianin/media_tree.git dual_dvb_t_c_ci_rf

Igor M. Liplianin (2):
      cx23885, altera-ci: remove operator return <value> in void procedure
      stv0900: speed up DVB-S searching

 drivers/media/dvb/frontends/stv0900_core.c |    5 ++++-
 drivers/media/video/cx23885/altera-ci.h    |    2 --
 2 files changed, 4 insertions(+), 3 deletions(-)
