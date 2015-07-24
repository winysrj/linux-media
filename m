Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:43183 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbbGXNKo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 09:10:44 -0400
Date: Fri, 24 Jul 2015 15:10:38 +0200
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Masanari Iida <standby24x7@gmail.com>, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] DocBook: Fix typo in intro.xml
Message-ID: <20150724151038.1b9e9981@lwn.net>
In-Reply-To: <55B1F86F.8010304@xs4all.nl>
References: <1436830610-19316-1-git-send-email-standby24x7@gmail.com>
	<20150714123806.4a97894c@lwn.net>
	<55B1F86F.8010304@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Jul 2015 10:33:51 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Jon, would you mind if I take this patch and let it go through the media
> tree? I'd like to apply a patch on top of this one that removes the mention of
> devfs.

Fine, I'll drop it.

> It makes more sense in general to take patches to Documentation/DocBook/media
> via the media route.

OK.  I'll stick the following into MAINTAINERS so I'm not tempted to grab
them from you :)

jon

MAINTAINERS: Direct Documentation/DocBook/media properly

The media maintainers want DocBook changes to go through their tree;
document that wish accordingly.
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b9b91566380e..11e2516c2712 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3440,6 +3440,7 @@ X:	Documentation/devicetree/
 X:	Documentation/acpi
 X:	Documentation/power
 X:	Documentation/spi
+X:	Documentation/DocBook/media
 T:	git git://git.lwn.net/linux-2.6.git docs-next
 
 DOUBLETALK DRIVER
-- 
2.4.3

