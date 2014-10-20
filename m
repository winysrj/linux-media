Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42757 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaJTC0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Oct 2014 22:26:21 -0400
Message-ID: <544472C7.90006@infradead.org>
Date: Sun, 19 Oct 2014 19:26:15 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Vincent Palatin <vpalatin@chromium.org>
CC: linux-media <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: DocBook error in v4l compat.xml (3.18-rc1)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In Linux 3.18-rc1, building DocBooks gives this error:

lnx-318-rc1/DOC1/Documentation/DocBook/compat.xml:2576: parser error : Opening and ending tag mismatch: orderedlist line 2560 and section

It looks like the section on V4L2 in Linux 3.18 added unmatched <orderedlist> without and
ending </orderedlist> ... or that section was inserted at an incorrect location.

-- 
~Randy
