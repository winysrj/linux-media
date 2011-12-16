Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35135 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1LPVGd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 16:06:33 -0500
Received: by iaeh11 with SMTP id h11so4875000iae.19
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 13:06:32 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 16 Dec 2011 16:06:32 -0500
Message-ID: <CAOcJUbzbt0juz6t8OVf=ACYxduYkVwHqcdA18TmpmtD=b=q3Gg@mail.gmail.com>
Subject: [PULL] git://linuxtv.org/mkrufky/tuners lgdt330x
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please pull from the lgdt330x branch of my tuners tree for two warning
fixes (discovered by Hans' daily cron job)

The following changes since commit 8c8ee11345fa26e46cbc9ec88581736e38915b16:
  Michael Krufky (1):
        [media] tda18271: add tda18271_get_if_frequency

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners lgdt330x

Michael Krufky (2):
      lgdt330x: fix behavior of read errors in lgdt330x_read_ucblocks
      lgdt330x: warn on errors blasting modulation config to the lgdt3303

 drivers/media/dvb/frontends/lgdt330x.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

Cheers,

Mike
