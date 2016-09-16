Return-path: <linux-media-owner@vger.kernel.org>
Received: from atlantic540.startdedicated.de ([188.138.9.77]:55340 "EHLO
        atlantic540.startdedicated.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933477AbcIPL03 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 07:26:29 -0400
From: Daniel Wagner <wagi@monom.org>
To: linux-media@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [PATCH 0/2] media: Use complete() instead complete_all()
Date: Fri, 16 Sep 2016 13:18:20 +0200
Message-Id: <1474024702-19436-1-git-send-email-wagi@monom.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Hi,

Using complete_all() is not wrong per se but it suggest that there
might be more than one waiter. For -rt I am reviewing all
complete_all() users and would like to leave only the real ones in the
tree. The main problem for -rt about complete_all() is that it can be
uses inside IRQ context and that can lead to unbounded amount work
inside the interrupt handler. That is a no no for -rt.

cheers,
daniel

Daniel Wagner (2):
  [media] imon: use complete() instead of complete_all()
  [media] lirc_imon: use complete() instead complete_all()

 drivers/media/rc/imon.c                | 6 ++++--
 drivers/staging/media/lirc/lirc_imon.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.7.4
