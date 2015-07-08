Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58518 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759305AbbGHQH3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jul 2015 12:07:29 -0400
Received: from recife.lan (unknown [179.182.175.40])
	by lists.s-osg.org (Postfix) with ESMTPSA id D2A83462EB
	for <linux-media@vger.kernel.org>; Wed,  8 Jul 2015 09:07:27 -0700 (PDT)
Date: Wed, 8 Jul 2015 13:07:24 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>
Subject: [ANNOUNCE] Some updates at linuxtv.org
Message-ID: <20150708130724.1331eecb@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

There were several contents at the linuxtv website that were outdated, on
the non-wiki pages.

I did an effort today of updating those pages, in order to reflect the
current status of the projects hosted there.

Among the changes:

- The "events 2011" page was removed. It was meant originally to announce
  and track the events, but this is better done via news, and all latter
  events used the news for events announce and reports. So, I moved the
  contents of the original page into an announce:
	http://linuxtv.org/news.php?entry=2011-10-26.mchehab

- I added links to each part of the Linux media documentation. That
  helps to make clearer what's actually documented there. A pointer to
  ALSA was also added.

- The legacy contents on the pages are now marked with an horizontal line
  (<hr> tag). Those contents are kept for historic reasons only.

- The projects page had DTV channel scan tables and tvtime added. Legacy
  projects was moved after the horizontal bar;

- The mailing lists now have a link to the media-workshop ML and has
  the status of each ML seen at mailman interface;

- The repositories page is now in sync with the projects page. The
  instructions to checkout a git repository was updated and should now
  work (it got bitrotten). I removed the instructions to get a mercurial
  tarball, as this is something that people should not be doing anymore
  nowadays;

- The lateral menu was updated and better organized.

Please report any issues.

Enjoy!
Mauro
