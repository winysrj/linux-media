Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:41464 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754243AbcHXPhI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 11:37:08 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] doc-rst: generic way to build PDF of sub-folder
Date: Wed, 24 Aug 2016 17:36:13 +0200
Message-Id: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Hi Mauro,

here is a small patch series which extends the method to build only sub-folders
to the targets "latexdocs" and "pdfdocs".

If you think, that the two first patches works for you, path them with your next
merge to Jon's doc-next.

The last patch in this series is just for you. It is a small example to
illustrate how we can build small books and link them with intersphinx.

-- Markus --

Markus Heiser (3):
  doc-rst: generic way to build PDF of sub-folders
  doc-rst: define PDF's of the media folder
  doc-rst:media: build separated PDF books (experimental)

 Documentation/Makefile.sphinx |  4 ++--
 Documentation/media/conf.py   | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

-- 
2.7.4

