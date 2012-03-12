Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34517 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab2CLUrF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 16:47:05 -0400
Received: by vcqp1 with SMTP id p1so4603452vcq.19
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2012 13:47:04 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 12 Mar 2012 16:47:04 -0400
Message-ID: <CAOcJUbyF2J4C2cZP2jgs3efQ8bZSpBYLKhHT2CGF5r5XcNYcXw@mail.gmail.com>
Subject: [GIT PULL / BUG FIX] au8522: enable modulation AFTER tune (instead of
 before tuning)
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please merge

The following changes since commit 632fba4d012458fd5fedc678fb9b0f8bc59ceda2:
  Sander Eikelenboom (1):
        [media] cx25821: Add a card definition for "No brand" cards
that have: subvendor = 0x0000 subdevice = 0x0000

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners.git au8522

Michael Krufky (1):
      au8522: bug-fix: enable modulation AFTER tune (instead of before tuning)

 drivers/media/dvb/frontends/au8522_dig.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

Cheers,

Mike Krufky
