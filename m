Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:18516 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaDCNRx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 09:17:53 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3G00GMJI9SP140@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Apr 2014 09:17:52 -0400 (EDT)
Date: Thu, 03 Apr 2014 10:17:45 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: webmaster@linuxtv.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Buildroot ML <buildroot@busybox.net>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: http:// and git:// repositories not in sync
Message-id: <20140403101745.759049b9@samsung.com>
In-reply-to: <20140329225237.GN3227@free.fr>
References: <20140329225237.GN3227@free.fr>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yann,

Em Sat, 29 Mar 2014 23:52:37 +0100
"Yann E. MORIN" <yann.morin.1998@free.fr> escreveu:

> Hello!
> 
> While looking at the dtv-scan-tables repository, we noticed that we did
> get a different set of commits with the http:// or the git:// schemes to
> access the repository:
> 
>     $ git clone git://linuxtv.org/dtv-scan-tables.git dtv.git
>     [...]
>     $ cd dtv.git
>     $ git log --oneline |head
>     cfc2975 Updated scan table for au-Sydney_North_Shore
>     29b0b57 UK Update for COM 7, BBC B, and Local Muxes
>     177b522 DTV scantables for FI
>     7809ca1 Update es-Alfabia
>     69a1ac5 Initial tuning data for ca-AB-Calgary
>     1850cf8 Initial scan table for au-Melbourne-Selby
>     52a7b0a update scan file for ro-DigiTV
>     75f3b39 Initial Tuning Data for Uganda
>     7d31336 Never include ~ files
>     1d6f9b5 Initial scan files for PT
> 
>     $ git clone http://linuxtv.org/git/dtv-scan-tables.git dtv.http
>     [...]
>     $ cd dtv.http
>     $ git log --oneline |head
>     7809ca1 Update es-Alfabia
>     69a1ac5 Initial tuning data for ca-AB-Calgary
>     1850cf8 Initial scan table for au-Melbourne-Selby
>     52a7b0a update scan file for ro-DigiTV
>     75f3b39 Initial Tuning Data for Uganda
>     7d31336 Never include ~ files
>     1d6f9b5 Initial scan files for PT
>     f61d5ec Merge pull request #6 from silid/master
>     6213a2f Table /usr/share/dvb/dvb-t/cz-All outdated
>     832df4f Removal of excess white space
> 
> As you can see, the http:// scheme gets us three fewer changesets than
> the git:// scheme.

We changed from gitweb to cgit. One of the advantages of cgit is that
it accepts cloning via html, and I think it doesn't require to call
git update-server-info for it to work.

So, I'm hoping that this change will fix this issue once for all.

The URL for http changed, due to that. The old URL will still be supported
for a while, in order to avoid breaking for the ones that were using the
legacy URL, but, as pointed, it depends on having a recent
git update-server-info for it to work properly.

Regards,
Mauro

-- 

Regards,
Mauro
