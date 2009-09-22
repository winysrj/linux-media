Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:60372 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbZIVTm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 15:42:58 -0400
Date: Tue, 22 Sep 2009 12:42:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: docbooks fatal build error (v4l & dvb)
Message-Id: <20090922124248.59e57b55.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2.6.31-git11:  this prevents other docbooks from being built.

mkdir -p /linux-2.6.31-git11/Documentation/DocBook/media/
cp /linux-2.6.31-git11/Documentation/DocBook/dvb/*.png /linux-2.6.31-git11/Documentation/DocBook/v4l/*.gif /linux-2.6.31-git11/Documentation/DocBook/media/
cp: cannot stat `/linux-2.6.31-git11/Documentation/DocBook/dvb/*.png': No such file or directory
cp: cannot stat `/linux-2.6.31-git11/Documentation/DocBook/v4l/*.gif': No such file or directory
make[1]: *** [media] Error 1


---
~Randy
