Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:59723 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030593AbaDBW06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 18:26:58 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3F000N2D0XVOA0@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Apr 2014 18:26:57 -0400 (EDT)
Received: from localhost.localdomain ([105.144.34.6])
 by ussync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0N3F00J8AD0T3N80@ussync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Apr 2014 18:26:56 -0400 (EDT)
Date: Wed, 02 Apr 2014 19:26:51 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: LMML <linux-media@vger.kernel.org>
Subject: [ANNOUNCE] git web interface was changed to cgit
Message-id: <20140402192651.7c9e3a74@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I changed today our git web interface from gitweb to cgit, due to seveal
reasons:
	- cgit is faster;
	- cgit has a page cache. That helps to reduce the CPU usage while
	  handling the pages;
	- cgit is more powerful and have more options;
	- gitweb is not used anymore on most projects;
	- gitweb is not as well maintained as cgit.

I changed from the default .css file to a customized one, as our site uses
black as the background for most things. That's said, I'm not a web designer.

I'm pretty sure that this could be improved a lot, but we lack time and
manpower to do it. So, if someone with web design experience could take
a look at the current cgit.css file and send us a new version or 
suggestions to improve it, be welcomed!

Please ping me if you fin any problems on it.

-- 

Regards,
Mauro
