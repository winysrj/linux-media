Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:57444 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965957Ab3DQLqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 07:46:37 -0400
Received: by mail-vb0-f54.google.com with SMTP id w16so1179251vbf.41
        for <linux-media@vger.kernel.org>; Wed, 17 Apr 2013 04:46:37 -0700 (PDT)
Date: Wed, 17 Apr 2013 07:46:52 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: mchehab@redhat.com, linux-media <linux-media@vger.kernel.org>
Subject: [GIT-PULL] lg2160: dubious one-bit signed bitfield
Message-ID: <20130417074652.7b25509e@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
33a31edd4a4b7d26b962b32decfd8ea2377eaa0d:

  Revert "[media] mfd: Add header files and Kbuild plumbing for SI476x
  MFD core" (2013-04-17 06:08:00 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb demods

for you to fetch changes up to 79c9a899d199fba3505b1d76325c97a7a00b3686:

  lg2160: dubious one-bit signed bitfield (2013-04-17 07:18:40 -0400)

----------------------------------------------------------------
Dan Carpenter (1):
      lg2160: dubious one-bit signed bitfield

 drivers/media/dvb-frontends/lg2160.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
