Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp09.wxs.nl ([195.121.247.23]:33664 "EHLO psmtp09.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351AbZKDNaf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Nov 2009 08:30:35 -0500
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp09.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KSL00BO96V08P@psmtp09.wxs.nl> for linux-media@vger.kernel.org;
 Wed, 04 Nov 2009 14:30:38 +0100 (MET)
Date: Wed, 04 Nov 2009 14:30:35 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: Trying to compile for kernel version 2.6.28
In-reply-to: <20091104052129.2e2dad47@pedra.chehab.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Message-id: <4AF181FB.7010003@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4AF0500B.3070401@hoogenraad.net>
 <20091104052129.2e2dad47@pedra.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks a lot.
Only syncing my sources every 2 months, I forgot about the
	make allmodconfig

I keep
  http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2.
in sync until Antti's sources have been tested, and IR support is put 
in, so that these sticks can be supported from the normal kernel.

Mauro Carvalho Chehab wrote:
> Hi Jan,
> 
> Em Tue, 03 Nov 2009 16:45:15 +0100
> Jan Hoogenraad <jan-conceptronic@hoogenraad.net> escreveu:
> 
>> At this moment, I cannot figure out how to compile v4l with kernel 
>> version 2.6.28.
>> I see, however, that the daily build reports:
>> linux-2.6.28-i686: OK
> 
> Yes, and that's correct. It does compile from scratch with 2.6.28.
> 
> If you look at v4l/versions.txt, this is already marked to compile only with
> kernels 2.6.31 or newer. It should be noticed, however, that the building system
> won't touch at your .config if you just do an hg update (or hg pull -u).
> 
> You'll need to ask it explicitly to process versions.txt again, by calling one of
> the alternatives bellow that re-generates a v4l/.config.
> 
> If you are using a customized config, you'll need to call either one of those:
> 	make menuconfig
> 	make config
> 	make xconfig
> 	  or
> 	make gconfig
> 
> (in this specific case, just entering there and saving the config is enough - there's
> no need to touch on any items)
> 
> Or, at the simple case were you're just building everything, you'll need to do:
> 	make allmodconfig
> 
> A side effect of touching at v4l/.config is that all (selected) drivers will
> recompile again.
> 
> Cheers,
> Mauro
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
