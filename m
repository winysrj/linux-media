Return-path: <linux-media-owner@vger.kernel.org>
Received: from cernmx30.cern.ch ([137.138.144.177]:27339 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab3JOPZC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 11:25:02 -0400
From: Dinesh Ram <dinesh.ram@cern.ch>
To: <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, <edubezval@gmail.com>,
	<dinesh.ram086@gmail.com>
Subject: [Review Patch 0/9] si4713 usb device driver
Date: Tue, 15 Oct 2013 17:24:36 +0200
Message-ID: <1381850685-26162-1-git-send-email-dinesh.ram@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Eduardo,

In this patch series, I have addressed the comments by you
concerning my last patch series.
In the resulting patches, I have corrected most of the
style issues and adding of comments. However, some warnings
given out by checkpatch.pl (mostly complaing about lines longer
than 80 characters) are still there because I saw that code readibility
suffers by breaking up those lines.

Also Hans has contributed patches 8 and 9 in this patch series
which address the issues of the handling of unknown regulators,
which have apparently changed since 3.10. Hans has tested it and the
driver loads again.

Let me know when you are able to test it again.

Kind regards,
Dinesh Ram
dinesh.ram@cern.ch
dinesh.ram086@gmail.com

