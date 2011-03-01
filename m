Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37902 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab1CAPxY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 10:53:24 -0500
Received: by fxm17 with SMTP id 17so4935935fxm.19
        for <linux-media@vger.kernel.org>; Tue, 01 Mar 2011 07:53:23 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.39] cx23885, altera-ci: remove operator return <value> in void procedure
Date: Tue, 1 Mar 2011 17:41:37 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201102272336.14099.liplianin@me.by> <201102282207.11320.liplianin@me.by>
In-Reply-To: <201102282207.11320.liplianin@me.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011741.38106.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit 9e650fdb12171a5a5839152863eaab9426984317:

  [media] drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver (2011-02-27 
07:50:42 -0300)

are available in the git repository at:
  git://linuxtv.org/liplianin/media_tree.git dual_dvb_t_c_ci_rf

Abylay Ospan (1):
      stv0900: Update status when LOCK is missed

Igor M. Liplianin (2):
      cx23885, altera-ci: remove operator return <value> in void procedure
      stv0900: speed up DVB-S searching

 drivers/media/dvb/frontends/stv0900_core.c |    6 +++++-
 drivers/media/video/cx23885/altera-ci.h    |    2 --
 2 files changed, 5 insertions(+), 3 deletions(-)
