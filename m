Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45477 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718AbbELPyc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 11:54:32 -0400
Message-ID: <55522234.10807@iki.fi>
Date: Tue, 12 May 2015 18:54:28 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Benjamin Larsson <benjamin@southpole.se>,
	Christian Engelmayer <cengelma@gmx.at>
Subject: [GIT PULL 4.2] Fix possible leak in mn88472_init()
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is staging driver and error which ~never happens, so it is not even 
worth to 4.1 at that phase, but upcoming 4.2.

regards
Antti


The following changes since commit b2624ff4bf46869df66148b2e1e675981565742e:

   [media] mantis: fix error handling (2015-05-12 08:12:18 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git mn88472_pull

for you to fetch changes up to a31e6951d4d66e9b3b41e071802ccf5feb5c7a46:

   mn88472: Fix possible leak in mn88472_init() (2015-05-12 18:47:36 +0300)

----------------------------------------------------------------
Christian Engelmayer (1):
       mn88472: Fix possible leak in mn88472_init()

  drivers/staging/media/mn88472/mn88472.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)


-- 
http://palosaari.fi/
