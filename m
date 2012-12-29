Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:43035 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab2L2Wh1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 17:37:27 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 0/2] v4l-utils: some fixes for contrib/m920x/m920x_parse.pl
Date: Sat, 29 Dec 2012 23:37:06 +0100
Message-Id: <1356820628-24992-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here are a couple of fixes for the contrib/m920x/m920x_parse.pl script.

Patch 01 makes extracting firmwares more robust, my previous tests were on
a trimmed down USB dump so I missed the need for stricter checks, now I tested
the script with a pristine dump pre-processed with parse-sniffusb2.pl and the
firmware can be extracted with no problems.

Patch 02 works around a warning.

Antonio Ospite (2):
  contrib/m920x/m920x_parse.pl: stricter check when extracting firmware
  contrib/m920x/m920x_parse.pl: silence a warning

 contrib/m920x/m920x_parse.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
