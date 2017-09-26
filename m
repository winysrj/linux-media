Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55735
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S969482AbdIZR71 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 13:59:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 00/10] kernel-doc: add supported to document nested structs/unions
Date: Tue, 26 Sep 2017 14:59:10 -0300
Message-Id: <cover.1506448061.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, it is not possible to document nested struct and nested unions.
kernel-doc simply ignore them.

Add support to document them.

This series starts with a patch getting rid of the now unused output formats
for kernel-doc: since we got rid of all DocBook stuff, we should not need
them anymore. The reason for dropping it (despite cleaning up), is that
it doesn't make sense to invest time on adding new features for formats
that aren't used anymore.

The next 8 patches on this series improve kernel-doc documentation and
finally get rid of its old documentation (kernel-doc-nano-HOWTO.txt).

Patch 9/10 is the most interesting one in this series: it adds support for
nested structures and unions.

Patch 10/10 is just an example from a random header with kernel-doc
markups. There's no special reason for selecting this file, and the
comments there are likely wrong. So, please use it only as a way to test
the new parser logic from patch 9/10.

Mauro Carvalho Chehab (10):
  scripts: kernel-doc: get rid of unused output formats
  docs: kernel-doc.rst: better describe kernel-doc arguments
  docs: kernel-doc.rst: improve private members description
  docs: kernel-doc.rst: improve function documentation section
  docs: kernel-doc.rst: improve structs chapter
  docs: kernel-doc: improve typedef documentation
  docs: kernel-doc.rst: add documentation about man pages
  docs: get rid of kernel-doc-nano-HOWTO.txt
  scripts: kernel-doc: parse next structs/unions
  [RFC] w1_netlink.h: add support for nested structs

---

Before this series, I send a few PoC patches. They were all
replaced by patch 9/10.

 Documentation/00-INDEX                  |    2 -
 Documentation/doc-guide/kernel-doc.rst  |  387 ++++++---
 Documentation/kernel-doc-nano-HOWTO.txt |  322 --------
 drivers/w1/w1_netlink.h                 |    4 +
 scripts/kernel-doc                      | 1304 ++-----------------------------
 5 files changed, 346 insertions(+), 1673 deletions(-)
 delete mode 100644 Documentation/kernel-doc-nano-HOWTO.txt

-- 
2.13.5
