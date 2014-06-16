Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbaFPR2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 13:28:07 -0400
Message-ID: <539F2926.4020004@infradead.org>
Date: Mon, 16 Jun 2014 10:28:06 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Michal Marek <mmarek@suse.cz>
CC: linux-media <linux-media@vger.kernel.org>
Subject: MANY errors while building media docbooks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

on Linux v3.16-rc1, building docbooks to a separate build directory
(mkdir DOC; make O=DOC htmldocs) gives me more than 12,000 lines like this:

grep: ./Documentation/DocBook//vidioc-subdev-g-fmt.xml: No such file or directory
grep: ./Documentation/DocBook//vidioc-subdev-g-frame-interval.xml: No such file or directory
grep: ./Documentation/DocBook//vidioc-subdev-g-selection.xml: No such file or directory
grep: ./Documentation/DocBook//vidioc-subscribe-event.xml: No such file or directory
grep: ./Documentation/DocBook//media-ioc-device-info.xml: No such file or directory
grep: ./Documentation/DocBook//media-ioc-enum-entities.xml: No such file or directory
grep: ./Documentation/DocBook//media-ioc-enum-links.xml: No such file or directory
grep: ./Documentation/DocBook//media-ioc-setup-link.xml: No such file or directory

-- 
~Randy
