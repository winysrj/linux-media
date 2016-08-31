Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:37456 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933887AbcHaP3y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 11:29:54 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: [RFC PATCH 0/3] doc-rst:c-domain: fix some issues in the c-domain
Date: Wed, 31 Aug 2016 17:29:29 +0200
Message-Id: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Hi Jon,

this is a small series, fixing a issues about sphinx version incompatibility and
adds improved handling of function-like macros [1]. The last patch is optional,
I don't know if it is better to create 'FOO (C macro)' index entries instead of
'FOO (C function)' entries (what sphinx does) [2].

[1] https://www.mail-archive.com/linux-doc@vger.kernel.org/msg05673.html
[2] https://www.mail-archive.com/linux-doc@vger.kernel.org/msg05678.html

Markus Heiser (3):
  doc-rst:c-domain: fix sphinx version incompatibility
  doc-rst:c-domain: function-like macros arguments
  doc-rst:c-domain: function-like macros index entry

 Documentation/sphinx/cdomain.py | 79 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 3 deletions(-)

-- 
2.7.4

