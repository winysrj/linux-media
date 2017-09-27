Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:32960
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751436AbdI0VKc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:10:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 00/13] kernel-doc: add supported to document nested structs/$
Date: Wed, 27 Sep 2017 18:10:11 -0300
Message-Id: <cover.1506546492.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, it is not possible to document nested struct and nested unions.
kernel-doc simply ignore them.

Add support to document them.

Patch 1 gets rid of the now unused output formats for kernel-doc: since 
we got rid of all DocBook stuff, we should not need them anymore. The
reason for dropping it (despite cleaning up), is that it doesn't make 
sense to invest time on adding new features for formats that aren't
used anymore.

Patches 2 to 7 improve kernel-doc documentation to reflect what
kernel-doc currently supports and import some stuff from the
old kernel-doc-nano-HOWTO.txt.

Patch 8 gets rid of the old documentation (kernel-doc-nano-HOWTO.txt).

Patch 9 is the most interesting one in this series: it adds support for
nested structures and unions.

Patch 10 does a cleanup, removing $nexted parameter at the
routines that handle structs.

Patch 11 Improves warning output by printing the identifier where
the warning occurred.

Patch 12 complements patch 9, by adding support for function
definitions inside nested structures. It is needed by some media
docs with use such kind of things.

Patch 13 is just an example from a random header with kernel-doc
markups. There's no special reason for selecting this file, and the
comments there are likely wrong. So, please use it only as a way to test
the new parser logic from patch 9. The real usage (for me, will
be at the media patches, but this is on a 30+ patch series, together
with a bunch of other stuff.

--

v2:
  - solved some issues that Randy pointed;
  - added patch 10 as suggested by Markus;
  - Fixed some bugs on patch 9, after parsing nested structs
   on media subsystem;
  - added patch 11 with a warning improvement fixup;
  - added patch 12 in order to handle function parameters
   on nested structures, due to DVB demux kAPI.

Mauro Carvalho Chehab (13):
  scripts: kernel-doc: get rid of unused output formats
  docs: kernel-doc.rst: better describe kernel-doc arguments
  docs: kernel-doc.rst: improve private members description
  docs: kernel-doc.rst: improve function documentation section
  docs: kernel-doc.rst: improve structs chapter
  docs: kernel-doc.rst: improve typedef documentation
  docs: kernel-doc.rst: add documentation about man pages
  docs: get rid of kernel-doc-nano-HOWTO.txt
  scripts: kernel-doc: parse next structs/unions
  scripts: kernel-doc: get rid of $nested parameter
  scripts: kernel-doc: print the declaration name on warnings
  scripts: kernel-doc: handle nested struct function arguments
  [RFC] w1_netlink.h: add support for nested structs

 Documentation/00-INDEX                  |    2 -
 Documentation/doc-guide/kernel-doc.rst  |  360 +++++---
 Documentation/kernel-doc-nano-HOWTO.txt |  322 --------
 drivers/w1/w1_netlink.h                 |    4 +
 scripts/kernel-doc                      | 1376 +++----------------------------
 5 files changed, 369 insertions(+), 1695 deletions(-)
 delete mode 100644 Documentation/kernel-doc-nano-HOWTO.txt

-- 
2.13.5
