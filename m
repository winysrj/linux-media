Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:33661 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbbEaM7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 08:59:23 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id DFDA22A0003
	for <linux-media@vger.kernel.org>; Sun, 31 May 2015 14:59:13 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] DocBook media: xmllint/typo fixes
Date: Sun, 31 May 2015 14:59:09 +0200
Message-Id: <1433077152-18200-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi Mauro,

Here are three patches that fix typos and xmllint errors.

The first patch fixes typos, the second a large number of xmllint
errors and the last fixes a final xmllint error, but it does that by
copying most of the v4l2 open/close text and you should check whether
I didn't remove anything that is relevant for DVB.

Note that I use the following 'gitdocs.sh' script to build the documentation:

--------------------------------
#!/bin/sh

make DOCBOOKS=media_api.xml htmldocs 2>&1 | grep -v "element.*: validity error : ID .* already defined"
xmllint --noent --postvalid "$PWD/Documentation/DocBook/media_api.xml" >/tmp/x.xml 2>/dev/null
xmllint --noent --postvalid --noout /tmp/x.xml
xmlto html-nochunks -m ./Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/media Documentation/DocBook/media_api.xml >/dev/null 2>&1

echo file://$PWD/Documentation/DocBook/media/media_api.html
--------------------------------

This does a pretty thorough xmllint check. It also creates a /tmp/x.xml file that can be used
to relate xmllint line numbers to that file.

Finally it creates a single big html file which has the whole spec. I prefer that
over all the little html pages you otherwise get. Also, by building one large file
it is easier to find clashing IDs etc. since the whole spec is analyzed.

Regards,

	Hans

Hans Verkuil (3):
  DocBook media: fix typos
  DocBook media: xmllint fixes
  DocBook media: rewrite frontend open/close

 Documentation/DocBook/media/dvb/dvbproperty.xml    |  28 +-
 .../media/dvb/fe-diseqc-recv-slave-reply.xml       |   2 +-
 .../DocBook/media/dvb/fe-diseqc-send-burst.xml     |   8 +-
 .../media/dvb/fe-diseqc-send-master-cmd.xml        |   2 +-
 .../media/dvb/fe-enable-high-lnb-voltage.xml       |   6 +-
 Documentation/DocBook/media/dvb/fe-get-info.xml    |   8 +-
 .../DocBook/media/dvb/fe-get-property.xml          |  26 +-
 Documentation/DocBook/media/dvb/fe-read-status.xml |   4 +-
 .../media/dvb/fe-set-frontend-tune-mode.xml        |   6 +-
 Documentation/DocBook/media/dvb/fe-set-tone.xml    |  10 +-
 Documentation/DocBook/media/dvb/fe-set-voltage.xml |   8 +-
 Documentation/DocBook/media/dvb/frontend.xml       | 299 ++++++++++++---------
 .../DocBook/media/dvb/frontend_legacy_api.xml      |   3 +-
 13 files changed, 222 insertions(+), 188 deletions(-)

-- 
2.1.4

