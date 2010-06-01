Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42373 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754107Ab0FAGrk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 02:47:40 -0400
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: linux-media@vger.kernel.org
Subject: Re: 2.6.35-rc1 fails to boot: OOPS in ir_register_class
Date: Tue, 1 Jun 2010 08:47:34 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006010847.34422.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's sad that this bug has gone into 2.6.35-rc1.

I already reported it on 24.05.2010: 
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/19564/
Unfortunately it didn't get any attention, which makes me a little bit depressive...

What is the right way to report bugs if code is still in linux-next, but not in a release candidate? 
Should I make an entry in https://bugzilla.kernel.org/? 
Or ist this list the right place to report it?

Greets,
Martin
