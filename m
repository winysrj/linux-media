Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:14977 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaDCNCU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 09:02:20 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3G00CBWHJVYW50@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Apr 2014 09:02:19 -0400 (EDT)
Date: Thu, 03 Apr 2014 10:02:13 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Enrico <ebutera@users.berlios.de>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] git web interface was changed to cgit
Message-id: <20140403100213.0da45ff1@samsung.com>
In-reply-to: <CA+2YH7u0YgEcH_0WYFwEhX7dj09aayMe+YpubHUY5eXrQH=D4g@mail.gmail.com>
References: <20140402192651.7c9e3a74@samsung.com>
 <CA+2YH7u0YgEcH_0WYFwEhX7dj09aayMe+YpubHUY5eXrQH=D4g@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Apr 2014 14:16:51 +0200
Enrico <ebutera@users.berlios.de> escreveu:

> On Thu, Apr 3, 2014 at 12:26 AM, Mauro Carvalho Chehab
> <m.chehab@samsung.com> wrote:
> > Hi all,
> >
> > I changed today our git web interface from gitweb to cgit, due to seveal
> > reasons:
> > ...
> > Please ping me if you fin any problems on it.
> 
> http://git.linuxtv.org/cgit.cgi/media_build.git/tree/README
> 
> the first time i opened that link i got an internal server error, then
> it shows an "empty" file (many lines, all empty).
> 
> It seems to happen for every file, even in other repos:
> 
> http://git.linuxtv.org/cgit.cgi/linux.git/tree/README

Fixed. A highlight filter was missing.

Regards,
Mauro
