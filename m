Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:43546 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751943AbdJDL6e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 00/17] kernel-doc: add supported to document nested structs/
Date: Wed,  4 Oct 2017 08:48:38 -0300
Message-Id: <cover.1507116877.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Right now, it is not possible to document nested struct and nested unions.
kernel-doc simply ignore them.

Add support to document them.

Patches 1 to 6 improve kernel-doc documentation to reflect what
kernel-doc currently supports and import some stuff from the
old kernel-doc-nano-HOWTO.txt.

Patch 7 gets rid of the old documentation (kernel-doc-nano-HOWTO.txt).


Patch 8 gets rid of the now unused output formats for kernel-doc: since 
we got rid of all DocBook stuff, we should not need them anymore. The
reason for dropping it (despite cleaning up), is that it doesn't make 
sense to invest time on adding new features for formats that aren't
used anymore.

Patch 9 improves argument handling, printing script usage if an
invalid argument is passed and accepting both -cmd and --cmd
forms.

Patch 10 changes the default output format to ReST, as this is a way
more used than man output nowadays.

Patch 11 solves an issue after ReST conversion, where tabs were not
properly handled on kernel-doc tags.

Patch 12 adds support for parsing kernel-doc nested structures and 
unions.

Patch 13 does a cleanup, removing $nexted parameter at the
routines that handle structs.

Patch 14 Improves warning output by printing the identifier where
the warning occurred.

Patch 15 complements patch 12, by adding support for function
definitions inside nested structures. It is needed by some media
docs with use such kind of things.

Patch 16 improves nested struct handling even further, allowing it
to handle cases where a nested named struct/enum with multiple
identifiers added (e. g. struct { ... } foo, bar;).

Patch 17 adds documentation for nested union/struct inside w1_netlink.

The entire patch series are at my development tree, at:
    https://git.linuxtv.org/mchehab/experimental.git/log/?h=nested-fix-v4b

--

v3:
- rebased on the top of docs-next branch at docs git tree;
- patches reordered to a more logical sequence;
- Change script to produce ReST format by default;
- Improve argument handling;
- Accept structs with multiple identifiers.


v2:
  - solved some issues that Randy pointed;
  - added patch 10 as suggested by Markus;
  - Fixed some bugs on patch 9, after parsing nested structs
   on media subsystem;
  - added patch 11 with a warning improvement fixup;
  - added patch 12 in order to handle function parameters
   on nested structures, due to DVB demux kAPI.

v1:
  - original version.

Mauro Carvalho Chehab (17):
  docs: kernel-doc.rst: better describe kernel-doc arguments
  docs: kernel-doc.rst: improve private members description
  docs: kernel-doc.rst: improve function documentation section
  docs: kernel-doc.rst: improve structs chapter
  docs: kernel-doc.rst: improve typedef documentation
  docs: kernel-doc.rst: add documentation about man pages
  docs: get rid of kernel-doc-nano-HOWTO.txt
  scripts: kernel-doc: get rid of unused output formats
  scripts: kernel-doc: improve argument handling
  scripts: kernel-doc: change default to ReST format
  scripts: kernel-doc: replace tabs by spaces
  scripts: kernel-doc: parse next structs/unions
  scripts: kernel-doc: get rid of $nested parameter
  scripts: kernel-doc: print the declaration name on warnings
  scripts: kernel-doc: handle nested struct function arguments
  scripts: kernel-doc: improve nested logic to handle multiple
    identifiers
  w1_netlink.h: add support for nested structs

 Documentation/00-INDEX                  |    2 -
 Documentation/doc-guide/kernel-doc.rst  |  360 +++++---
 Documentation/kernel-doc-nano-HOWTO.txt |  322 -------
 drivers/w1/w1_netlink.h                 |    6 +-
 scripts/kernel-doc                      | 1441 ++++---------------------------
 5 files changed, 414 insertions(+), 1717 deletions(-)
 delete mode 100644 Documentation/kernel-doc-nano-HOWTO.txt

-- 
2.13.6
