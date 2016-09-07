Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:41618 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753696AbcIGHNo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 03:13:44 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 0/3] doc-rst:c-domain: fix some issues in the c-domain
Date: Wed,  7 Sep 2016 09:12:55 +0200
Message-Id: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Hi Jon,

according to your remarks I fixed the first and second patch. The third patch is
resend unchanged;

> Am 06.09.2016 um 14:28 schrieb Jonathan Corbet <corbet@lwn.net>:
>
> As others have pointed out, we generally want to hide the difference
> between functions and macros, so this is probably one change we don't
> want.

I read "probably", so there might be a chance to persuade you ;)

I'm not a friend of *information hiding* and since the index is sorted
alphabetical it does no matter if the entry is 'FOO (C function)' or 'FOO (C
macro)'. The last one has the right information e.g. for someone how is looking
for a macro. FOO is a function-like macro and not a function, if the author
describes the macro he might use the word "macro FOO" but in the index it is
tagged as C function.

Macros and functions are totally different even if their notation looks
similarly. So where is the benefit of entries like 'FOO (C function)', which is
IMHO ambiguous.

I tagged the 'function-like macros index entry' patch with 'RFC' and resend it
within this series. If you and/or others have a different opinion, feel free to
drop it.

Thanks for review.

-- Markus --


Markus Heiser (3):
  doc-rst:c-domain: fix sphinx version incompatibility
  doc-rst:c-domain: function-like macros arguments
  doc-rst:c-domain: function-like macros index entry

 Documentation/sphinx/cdomain.py | 79 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 3 deletions(-)

-- 
2.7.4

