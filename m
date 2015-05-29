Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34170 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbbE2B3C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 21:29:02 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/8] Second series of DocBook fixes for DVB frontend
Date: Thu, 28 May 2015 22:28:49 -0300
Message-Id: <cover.1432862317.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series do another round of format conversion and cleanups
at the DVB frontend docbook.

It basically moves all enums/typedefs that are used on both DVBv5
and DVBv3 calls to the DVBv5 xml. Links at the DVBv3 section are
provided, in order to point to those enums.

The enums touched on this series were converted from programlisting
into tables, with allowed to add better descriptions to each field.

There were one enum (fe_bandwidth) that is DVBv3 specific. This got
moved to the legacy part of the document.

After this change, the API documentation looks clearer, at least on
my eyes.

TODO:

- At the dvbproperty.xml, there are still several programlisting
  code with some enums. Those should be converted latter to tables.
  I'll eventually convert them and do a cleanup on this xml file, but
  I'll likely look into the net and demux part of the document first.
  So, patches are welcome.

- The frontend_legacy_api.xml (with contains the DVBv3 legacy stuff)
  still uses the original format. I don't intend to convert it, as
  there are still lots of other things that require improvements at
  the document. So, this has low priority. Of course, patches fixing
  it are welcome.

- The open() and close() syscalls are still using the original format.
  Patches are welcome.

Mauro Carvalho Chehab (8):
  DocBook/Makefile: improve typedef parser
  DocBook: cross-reference enum fe_modulation where needed
  DocBook: improve documentation for DVB spectral inversion
  DocBook: improve documentation for OFDM transmission mode
  DocBook: move fe_bandwidth to the frontend legacy section
  DocBook: improve documentation for FEC fields
  DocBook: improve documentation for guard interval
  DocBook: improve documentation for hierarchy

 Documentation/DocBook/media/Makefile               |   4 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml    | 358 +++++++++++++++------
 Documentation/DocBook/media/dvb/frontend.xml       | 109 -------
 .../DocBook/media/dvb/frontend_legacy_api.xml      |  66 +++-
 include/uapi/linux/dvb/frontend.h                  |  34 +-
 5 files changed, 331 insertions(+), 240 deletions(-)

-- 
2.4.1

