Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33476 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750722AbZLaP1f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 10:27:35 -0500
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] IR: Fix sysfs attributes declaration
Date: Thu, 31 Dec 2009 16:27:28 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912311627.28160.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can confirm this problem.

Without this patch (thanks, Francesco!)  I get a kernel stack trace when 
loading the media drivers:
http://home.arcor-online.de/martin.dauskardt/trace1.jpg
http://home.arcor-online.de/martin.dauskardt/trace2.jpg

(An older v4l-dvb hg snapshot from December 5th wotks fine without patch.)

I am also using 2.6.32 and have two DVB and two v4l2 cards in my machine.

Greets,
Martin Dauskardt


 
