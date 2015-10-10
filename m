Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39196 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbbJJNgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 00/26] Some improvements for the media API
Date: Sat, 10 Oct 2015 10:35:43 -0300
Message-Id: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve documentation for the media core subsystems. The initial patches
of this series improve the documentation for V4L2 core and RC core,
adding documentation for tuner, tveeprom and lirc.

The remaining patches are focused on the DVB API, adding documentation
for the remaining stuff at dvb_ca and moving the kABI functions from the
API docbook into the device-drivers (kdapi.xml), making sure that what's 
documented is what's there at the Kernel. The kdapi.xml was broken for a long
time, since before 2005, when I started maintaining the DVB. After this patch
series, it is now in a better shape.

Mauro Carvalho Chehab (26):
  [media] DocBook: Document include/media/tuner.h
  [media] tuner.h: Make checkpatch.pl happier
  [media] DocBook: convert struct tuner_parms to doc-nano format
  [media] DocBook: add documentation for tuner-types.h
  [media] tveeprom: Remove two unused fields from struct
  [media] DocBook: Document tveeprom.h
  [media] DocBook: Convert struct lirc_driver to doc-nano format
  [media] lirc_dev.h: Make checkpatch happy
  [media] DocBook: document struct dvb_ca_en50221
  [media] dvb_ca_en50221.h: Make checkpatch.pl happy
  [media] DocBook: Move struct dmx_demux kABI doc to demux.h
  [media] DocBook: update documented fields at struct dmx_demux
  [media] dvb: don't keep support for undocumented features
  [media] DocBook: finish documenting struct dmx_demux
  [media] dvb: get rid of enum dmx_success
  [media] dvb: Remove unused frontend sources at demux.h and sync doc
  [media] DocBook: document the other structs/enums of demux.h
  [media] demux.h: make checkpatch.ph happy
  kernel-doc: Add a parser for function typedefs
  kernel-doc: better format typedef function output
  [media] DocBook: document typedef dmx_ts_cb at demux.h
  [media] DocBook: document typedef dmx_section_cb at demux.h
  [media] demux.h: Convert TS filter type into enum
  [media] demux.h: Convert MPEG-TS demux caps to an enum
  [media] DocBook: Add documentation about the demux API
  [media] DocBook: Remove kdapi.xml

 Documentation/DocBook/device-drivers.tmpl  |   80 +-
 Documentation/DocBook/media/dvb/dvbapi.xml |    3 -
 Documentation/DocBook/media/dvb/kdapi.xml  | 2309 ----------------------------
 drivers/media/dvb-core/demux.h             |  613 ++++++--
 drivers/media/dvb-core/dmxdev.c            |   10 +-
 drivers/media/dvb-core/dvb_ca_en50221.h    |   99 +-
 drivers/media/dvb-core/dvb_demux.c         |   11 +-
 drivers/media/dvb-core/dvb_net.c           |    5 +-
 drivers/media/pci/ttpci/av7110.c           |    9 +-
 drivers/media/pci/ttpci/av7110_av.c        |    6 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c    |   12 +-
 include/media/lirc_dev.h                   |  120 +-
 include/media/tuner-types.h                |  182 ++-
 include/media/tuner.h                      |  152 +-
 include/media/tveeprom.h                   |   83 +-
 scripts/kernel-doc                         |   25 +
 16 files changed, 1005 insertions(+), 2714 deletions(-)
 delete mode 100644 Documentation/DocBook/media/dvb/kdapi.xml

-- 
2.4.3


