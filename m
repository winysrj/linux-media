Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37616 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZG1BH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2009 21:07:58 -0400
Date: Mon, 27 Jul 2009 22:07:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>,
	Andy Walls <awalls@radix.net>
Subject: Re: lsmod path hardcoded in v4l/Makefile
Message-ID: <20090727220753.092616bd@pedra.chehab.org>
In-Reply-To: <200907210914.37819.zzam@gentoo.org>
References: <200906221636.25006.zzam@gentoo.org>
	<200906230950.26287.zzam@gentoo.org>
	<Pine.LNX.4.58.0906231214360.6411@shell2.speakeasy.net>
	<200907210914.37819.zzam@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 21 Jul 2009 09:14:36 +0200
Matthias Schwarzott <zzam@gentoo.org> escreveu:

 
> Hi Mauro!
> 
> is there any reason to not pull this besides time?

Time is one reason, however, there's another:

It is not a good idea to run as root. Most people compile everything
with a normal user and then use "sudo" command to install/remove/insert
modules. Unfortunately, depending on the distribution, sudo inherits PATH from
the normal user, instead of root. Due to that, if you replace it for just
lsmod, it will fail for people that don't use gentoo.

Maybe good solution is to test if lsmod (and other similar tools) are at /sbin
or /usr/sbin. 

Alternatively, we can try to replace lsmod by something like (untested):

v4l_modules := $(shell PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin lsmod|cut -d' ' -f1 ) $(patsubst %.ko,%,$(inst-m))

> 
> Regards
> Matthias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
