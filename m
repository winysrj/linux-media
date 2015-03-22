Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34984 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751809AbbCVSg0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 14:36:26 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: mchehab@osg.samsung.com, corbet@lwn.net
Cc: hans.verkuil@cisco.com, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 0/1] DocBook media: fix broken EIA hyperlink
Date: Sun, 22 Mar 2015 11:35:55 -0700
Message-Id: <1427049356-30395-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is a fix for the only broken link in kernel documentation,
at least according to the "linkchecker" tool that we are running
on the Free Electrons website once a day.

As kernel documentation is part of our website
(on http://free-electrons.com/kerneldoc/), I get reminded
of this broken link once a day!

Michael.

Michael Opdenacker (1):
  [media] DocBook media: fix broken EIA hyperlink

 Documentation/DocBook/media/v4l/biblio.xml                  | 11 +++++------
 Documentation/DocBook/media/v4l/dev-sliced-vbi.xml          |  2 +-
 Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml |  2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

-- 
2.1.0

