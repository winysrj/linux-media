Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39872 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3EHN16 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:27:58 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] media-ctl error messages
Date: Wed,  8 May 2013 15:27:52 +0200
Message-Id: <1368019674-25761-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

As a first time media-ctl user it was quite frustrating to see that whatever I
did media-ctl only responded with "Unable to parse link". The following is an
attempt to add some more detailed error messages. With this applied media-ctl
can answer with something like:

No pad '1' on entity "mt9p031 0-0048". Maximum pad number is 0
media_parse_setup_link: Unable to parse link

 "mt9p031 0-0048":1->"/soc/cammultiplex@plx0":1[0]
                  ^

Please consider applying.

Sascha

----------------------------------------------------------------
Sascha Hauer (2):
      Print more detailed parse error messages
      Print parser position on error

 src/mediactl.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 71 insertions(+), 12 deletions(-)

