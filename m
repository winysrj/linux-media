Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40003
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755290AbdDENX3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 09:23:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 00/21] Convert USB documentation to ReST format
Date: Wed,  5 Apr 2017 10:22:54 -0300
Message-Id: <cover.1491398120.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, there are several USB core documents that are at either
written in plain text or in DocBook format. Convert them to ReST
and add to the driver-api book.

Mauro Carvalho Chehab (21):
  tmplcvt: make the tool more robust
  driver-api/basics.rst: add device table header
  docs-rst: convert usb docbooks to ReST
  usb.rst: Enrich its ReST representation
  gadget.rst: Enrich its ReST representation and add kernel-doc tag
  writing_usb_driver.rst: Enrich its ReST representation
  writing_musb_glue_layer.rst: Enrich its ReST representation
  usb/anchors.txt: convert to ReST and add to driver-api book
  usb/bulk-streams.txt: convert to ReST and add to driver-api book
  usb/callbacks.txt: convert to ReST and add to driver-api book
  usb/power-management.txt: convert to ReST and add to driver-api book
  usb/dma.txt: convert to ReST and add to driver-api book
  error-codes.rst: convert to ReST and add to driver-api book
  usb/hotplug.txt: convert to ReST and add to driver-api book
  usb/persist.txt: convert to ReST and add to driver-api book
  usb/URB.txt: convert to ReST and update it
  usb.rst: get rid of some Sphinx errors
  usb: get rid of some ReST doc build errors
  usb: composite.h: fix two warnings when building docs
  usb: gadget.h: be consistent at kernel doc macros
  docs-rst: fix usb cross-references

 Documentation/ABI/stable/sysfs-bus-usb             |   2 +-
 Documentation/DocBook/Makefile                     |   7 +-
 Documentation/DocBook/gadget.tmpl                  | 793 -------------------
 Documentation/DocBook/writing_musb_glue_layer.tmpl | 873 ---------------------
 Documentation/DocBook/writing_usb_driver.tmpl      | 412 ----------
 Documentation/driver-api/basics.rst                |   6 +
 Documentation/driver-api/index.rst                 |   2 +-
 .../{usb/URB.txt => driver-api/usb/URB.rst}        | 223 +++---
 .../anchors.txt => driver-api/usb/anchors.rst}     |  36 +-
 .../usb/bulk-streams.rst}                          |  13 +-
 .../callbacks.txt => driver-api/usb/callbacks.rst} |  65 +-
 .../{usb/dma.txt => driver-api/usb/dma.rst}        |  51 +-
 Documentation/driver-api/usb/error-codes.rst       | 207 +++++
 Documentation/driver-api/usb/gadget.rst            | 510 ++++++++++++
 .../hotplug.txt => driver-api/usb/hotplug.rst}     |  66 +-
 Documentation/driver-api/usb/index.rst             |  26 +
 .../persist.txt => driver-api/usb/persist.rst}     |  22 +-
 .../usb/power-management.rst}                      | 404 +++++-----
 Documentation/driver-api/{ => usb}/usb.rst         | 222 +++---
 .../driver-api/usb/writing_musb_glue_layer.rst     | 723 +++++++++++++++++
 .../driver-api/usb/writing_usb_driver.rst          | 326 ++++++++
 Documentation/power/swsusp.txt                     |   2 +-
 Documentation/sphinx/tmplcvt                       |  13 +-
 Documentation/usb/error-codes.txt                  | 175 -----
 drivers/staging/most/hdm-usb/hdm_usb.c             |   2 +-
 drivers/usb/core/Kconfig                           |   2 +-
 drivers/usb/core/message.c                         |   1 +
 include/linux/usb/composite.h                      |   6 +-
 include/linux/usb/gadget.h                         |   2 +-
 29 files changed, 2417 insertions(+), 2775 deletions(-)
 delete mode 100644 Documentation/DocBook/gadget.tmpl
 delete mode 100644 Documentation/DocBook/writing_musb_glue_layer.tmpl
 delete mode 100644 Documentation/DocBook/writing_usb_driver.tmpl
 rename Documentation/{usb/URB.txt => driver-api/usb/URB.rst} (50%)
 rename Documentation/{usb/anchors.txt => driver-api/usb/anchors.rst} (75%)
 rename Documentation/{usb/bulk-streams.txt => driver-api/usb/bulk-streams.rst} (94%)
 rename Documentation/{usb/callbacks.txt => driver-api/usb/callbacks.rst} (76%)
 rename Documentation/{usb/dma.txt => driver-api/usb/dma.rst} (79%)
 create mode 100644 Documentation/driver-api/usb/error-codes.rst
 create mode 100644 Documentation/driver-api/usb/gadget.rst
 rename Documentation/{usb/hotplug.txt => driver-api/usb/hotplug.rst} (76%)
 create mode 100644 Documentation/driver-api/usb/index.rst
 rename Documentation/{usb/persist.txt => driver-api/usb/persist.rst} (94%)
 rename Documentation/{usb/power-management.txt => driver-api/usb/power-management.rst} (69%)
 rename Documentation/driver-api/{ => usb}/usb.rst (85%)
 create mode 100644 Documentation/driver-api/usb/writing_musb_glue_layer.rst
 create mode 100644 Documentation/driver-api/usb/writing_usb_driver.rst
 delete mode 100644 Documentation/usb/error-codes.txt

-- 
2.9.3
