Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64155 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab1K3Oow (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 09:44:52 -0500
Received: by yenl6 with SMTP id l6so558248yen.19
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 06:44:52 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 30 Nov 2011 09:44:51 -0500
Message-ID: <CAOcJUbzCQ0RBaXfbg-r6NsnVCyR=NBLezap5aqQCh+U3=0O+mA@mail.gmail.com>
Subject: [PULL] git://linuxtv.org/mkrufky/hauppauge.git voyager
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please pull from the 'voyager' branch of my 'hauppauge' git tree for
some simple USB ID additions for some additional HVR950Q variants.  If
it's possible to send these to Linus for 3.2, that would be really
cool... but it's nothing urgent.

The following changes since commit 36d36b884c745c507d9b3f60eb42925749f7d758:
  Mauro Carvalho Chehab (1):
        [media] tm6000: Warning cleanup

are available in the git repository at:

  git://linuxtv.org/mkrufky/hauppauge.git voyager

Michael Krufky (3):
      au0828: add missing USB ID 2040:7260
      au0828: add missing USB ID 2040:7213
      au0828: add missing models 72101, 72201 & 72261 to the model matrix

 drivers/media/video/au0828/au0828-cards.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
