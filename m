Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab1FHUZ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:29 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KPTVH011493
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:29 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Uq024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:28 -0400
Date: Wed, 8 Jun 2011 17:23:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 00/13] Reduce the gap between DVBv5 API and the specs
Message-ID: <20110608172311.0d350ab7@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There's a huge gap between the DVB specs and the current implementation.
This were caused by years of changes that happened at the code but
no updates to the specs were done.

This patch series tries to reduce this gap.

Basically, the headers at include/linux/dvb were included at the API.
The Makefile scripting auto-generate references for structs, typedefs
and ioctls. With this, it is now easy to identify when something is
missing.

After adding such logic, I've manually synchronized the specs with the
header file and updated the data structures.

The work is not complete yet: there are still several ioctl's not
documented at the specs:

Error: no ID for constraint linkend: AUDIO_BILINGUAL_CHANNEL_SELECT.
Error: no ID for constraint linkend: CA_RESET.
Error: no ID for constraint linkend: CA_GET_CAP.
Error: no ID for constraint linkend: CA_GET_SLOT_INFO.
Error: no ID for constraint linkend: CA_GET_DESCR_INFO.
Error: no ID for constraint linkend: CA_GET_MSG.
Error: no ID for constraint linkend: CA_SEND_MSG.
Error: no ID for constraint linkend: CA_SET_DESCR.
Error: no ID for constraint linkend: CA_SET_PID.
Error: no ID for constraint linkend: DMX_GET_PES_PIDS.
Error: no ID for constraint linkend: DMX_GET_CAPS.
Error: no ID for constraint linkend: DMX_SET_SOURCE.
Error: no ID for constraint linkend: DMX_ADD_PID.
Error: no ID for constraint linkend: DMX_REMOVE_PID.
Error: no ID for constraint linkend: NET_ADD_IF.
Error: no ID for constraint linkend: NET_REMOVE_IF.
Error: no ID for constraint linkend: NET_GET_IF.
Error: no ID for constraint linkend: VIDEO_GET_SIZE.
Error: no ID for constraint linkend: VIDEO_GET_FRAME_RATE.
Error: no ID for constraint linkend: VIDEO_GET_PTS.
Error: no ID for constraint linkend: VIDEO_GET_FRAME_COUNT.
Error: no ID for constraint linkend: VIDEO_COMMAND.
Error: no ID for constraint linkend: VIDEO_TRY_COMMAND.

I also opted to not add the osd.h header into the DocBook, as it seemed
odd on my eyes, and it is used only by one legacy hardware.

While here, I noticed that one audio ioctl is not used anyware
(AUDIO_GET_PTS). There is just the ioctl definition and that's it. 
I just removed this definition, as removing it won't cause any 
regression, as no in-kernel driver or dvb-core uses it.

Btw, there are several ioctl's and correponding data structures that
are used on just one or two old drivers. I think we should consider
to deprecate those old stuff.

Mauro Carvalho Chehab (13):
  [media] DocBook: Add the other DVB API header files
  [media] DocBook/audio.xml: match section ID's with the reference links
  [media] DocBook/audio.xml: synchronize attribute changes
  [media] DocBook: Document AUDIO_CONTINUE ioctl
  [media] dvb/audio.h: Remove definition for AUDIO_GET_PTS
  [media] Docbook/ca.xml: match section ID's with the reference links
  [media] DocBook/ca.xml: Describe structure ca_pid
  [media] DocBook/demux.xml: Fix section references with dmx.h.xml
  [media] DocBook/demux.xml: Add the remaining data structures to the API spec
  [media] DocBook/net.xml: Synchronize Network data structure
  [media] DocBook/Makefile: Remove osd.h header
  [media] DocBook/video.xml: Fix section references with video.h.xml
  [media] DocBook/video.xml: Document the remaining data structures

 Documentation/DocBook/media/Makefile       |   81 ++++++++++-
 Documentation/DocBook/media/dvb/audio.xml  |  176 +++++++++++++++--------
 Documentation/DocBook/media/dvb/ca.xml     |  106 ++++++++------
 Documentation/DocBook/media/dvb/demux.xml  |  206 +++++++++++++++-----------
 Documentation/DocBook/media/dvb/dvbapi.xml |   20 +++
 Documentation/DocBook/media/dvb/intro.xml  |   19 +++-
 Documentation/DocBook/media/dvb/net.xml    |   17 ++
 Documentation/DocBook/media/dvb/video.xml  |  220 +++++++++++++++++-----------
 include/linux/dvb/audio.h                  |   14 +--
 9 files changed, 564 insertions(+), 295 deletions(-)

