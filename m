Return-path: <mchehab@pedra>
Received: from keetweej.vanheusden.com ([83.163.219.98]:56440 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab0HJNbH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 09:31:07 -0400
Date: Tue, 10 Aug 2010 15:31:05 +0200
From: folkert <folkert@vanheusden.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle Systems, Inc. PCTV 330e & 2.6.34 &
	/dev/dvb
Message-ID: <20100810133104.GU6126@belle.intranet.vanheusden.com>
References: <20100809133252.GW6126@belle.intranet.vanheusden.com> <AANLkTimtHwW_PQ1vNQVaMKXXYdyVroZzwAfomu+Yw02C@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimtHwW_PQ1vNQVaMKXXYdyVroZzwAfomu+Yw02C@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

> > I have a:
> > Bus 001 Device 006: ID 2304:0226 Pinnacle Systems, Inc. PCTV 330e
> > inserted in a system with kernel 2.6.34.
> 
> The PCTV 330e support for digital hasn't been merged upstream yet.
> See here:
> http://www.kernellabs.com/blog/?cat=35

To get it compile I had to add
	#include <linux/slab.h>
to a couple of files.

Had to remove makefile references to firedtv* as it wants to include all
kinds of headerfiles that exist nowhere in the kernel 2.6.34 sources.


Folkert van Heusden

-- 
MultiTail er et flexible tool for å kontrolere Logfiles og commandoer.
Med filtrer, farger, sammenføringer, forskeliger ansikter etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
