Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56312 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750964Ab0FOGqJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jun 2010 02:46:09 -0400
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: Dmitri Belimov <d.belimov@gmail.com>
Subject: Re: [REGRESSION] saa7134 + ir
Date: Tue, 15 Jun 2010 08:46:00 +0200
Cc: linux-media@vger.kernel.org
References: <201006130943.41688.martin.dauskardt@gmx.de> <20100615113924.2ad97ec6@glory.loctelecom.ru>
In-Reply-To: <20100615113924.2ad97ec6@glory.loctelecom.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006150846.01230.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, 15. Juni 2010, um 03:39:24 schrieb Dmitri Belimov:
> Hi Martin
> 
> > This is not only a problem with saa7134, but also with other drivers
> > like budget-ci. The bug was also present in 2.6.35-rc1
> 
> I see this bug with 2.6.33 and fresh hg.
> 
> > There have been several reports here in the list since a few weeks:
> > http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/20198
> > http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/19904
> > 
> > There is already a similar patch like yours (see link in first of my
> > links), but it still hasn't gone into the v4l-dvb hg. (Although there
> > have been frequently other -less important-  patches been merged ...)
> > 
> > Greets,
> > Martin
> > 
> 
> With my best regards, Dmitry.
> 
it should be fixed now. Douglas merged this patch today:
http://linuxtv.org/hg/v4l-dvb/rev/3d7eaf0239ab

Greets,
Martin
