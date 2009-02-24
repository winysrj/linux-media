Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:41696 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbZBXPfT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 10:35:19 -0500
Message-Id: <20090224153514.090816655@gentoo.org>
Date: Tue, 24 Feb 2009 16:35:14 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 0/2] Add support for DVB part of Avermedia A700 DVB-S cards
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all!

These patches finally add support for the DVB part of the
Avermedia A700 DVB-S cards.

The first adds the tuner-driver for the Zarlink zl10036.
The second adds the glue code to saa7134-dvb to use it.

After having them lying around a long time I now did a
bit of cleanup and send them out now.

Regards
Matthias

