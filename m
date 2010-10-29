Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759838Ab0J2DLc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 23:11:32 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9T3BWdh030607
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:11:32 -0400
Date: Thu, 28 Oct 2010 23:11:31 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101029031131.GE17238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I've got one of those tiny little 6-button Apple remotes here, now it can
be decoded in-kernel (tested w/an mceusb transceiver).

Jarod Wilson (2):
      ir-nec-decoder: decode Apple's NEC remote variant
      IR: add Apple remote keymap

 drivers/media/IR/ir-nec-decoder.c       |   10 +++++-
 drivers/media/IR/keymaps/Makefile       |    1 +
 drivers/media/IR/keymaps/rc-nec-apple.c |   51 +++++++++++++++++++++++++++++++
 include/media/rc-map.h                  |    1 +
 4 files changed, 62 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/IR/keymaps/rc-nec-apple.c

-- 
Jarod Wilson
jarod@redhat.com

