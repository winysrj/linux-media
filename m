Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1133 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab2HILUy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 07:20:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] DocBook fixes/improvements
Date: Thu, 9 Aug 2012 13:20:38 +0200
Cc: Mike Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208091320.38342.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series builds on top of this pull request for v3.6:

http://patchwork.linuxtv.org/patch/13696/

It fixes a bunch of incorrect links originally requested from Mike here:

http://www.spinics.net/lists/linux-media/msg49871.html

The other patches document the missing DVB audio and video ioctls and
add stubs for the missing net, demux and ca DVB ioctls.

After these patches the spec builds cleanly without any errors.

That allows me to report a spec build error as an error in the daily
build. Currently I have to ignore such errors.

Regards,

	Hans

The following changes since commit 1bb7364ed7f469186f5c1cc96dda399062097946:

  DocBook: various version/copyright year updates. (2012-08-09 13:00:58 +0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git docfixes2

for you to fetch changes up to fc2d9c8ee028b4fc7a31651e3a642253fdb8eaf8:

  DocBook: add stubs for missing DVB CA ioctls. (2012-08-09 13:03:36 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
      DocBook: fix incorrect or missing links.
      DocBook: add missing AUDIO_* ioctls.
      DocBook: add missing DVB video ioctls.
      DocBook: add stubs for the undocumented DVB net ioctls.
      DocBook: add stubs for missing DVB DMX ioctls.
      DocBook: add stubs for missing DVB CA ioctls.

 Documentation/DocBook/media/dvb/audio.xml       |  113 ++++++++++++++++++-
 Documentation/DocBook/media/dvb/ca.xml          |  353 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/DocBook/media/dvb/demux.xml       |  230 +++++++++++++++++++++++++++++++++++++-
 Documentation/DocBook/media/dvb/dvbproperty.xml |   24 ++--
 Documentation/DocBook/media/dvb/frontend.xml    |    2 +-
 Documentation/DocBook/media/dvb/net.xml         |  127 +++++++++++++++++++++
 Documentation/DocBook/media/dvb/video.xml       |  333 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 7 files changed, 1161 insertions(+), 21 deletions(-)
