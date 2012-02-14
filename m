Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60080 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab2BNUNH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 15:13:07 -0500
Received: by vcge1 with SMTP id e1so288789vcg.19
        for <linux-media@vger.kernel.org>; Tue, 14 Feb 2012 12:13:05 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 14 Feb 2012 15:13:04 -0500
Message-ID: <CAHAyoxwLe8xcJTxaF5F4DgVxEBGV3yWdteVfyU1jA9mC-NSD-g@mail.gmail.com>
Subject: [GIT PULL] git://linuxtv.org/mkrufky/tuners.git tveeprom
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please also pull in this change to tveeprom.c:

The following changes since commit a3db60bcf7671cc011ab4f848cbc40ff7ab52c1e:
  Michael Krufky (1):
        [media] xc5000: declare firmware configuration structures as
static const

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners.git tveeprom

Michael Krufky (1):
      tveeprom: update hauppauge tuner list thru 181

 drivers/media/video/tveeprom.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

Cheers,

Mike
