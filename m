Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46731 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752534Ab0FMHns (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 03:43:48 -0400
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: linux-media@vger.kernel.org
Subject: Re: [REGRESSION] saa7134 + ir
Date: Sun, 13 Jun 2010 09:43:41 +0200
Cc: d.belimov@gmail.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006130943.41688.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is not only a problem with saa7134, but also with other drivers like budget-ci.
The bug was also present in 2.6.35-rc1

There have been several reports here in the list since a few weeks:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/20198
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/19904

There is already a similar patch like yours (see link in first of my links), but it still hasn't gone into the v4l-dvb hg. 
(Although there have been frequently other -less important-  patches been merged ...)

Greets,
Martin

