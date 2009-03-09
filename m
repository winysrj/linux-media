Return-path: <linux-media-owner@vger.kernel.org>
Received: from rotring.dds.nl ([85.17.178.138]:39596 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbZCIN53 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2009 09:57:29 -0400
Subject: Re: Problem with changeset 10837: causes "make all" not to build
 many modules
From: Alain Kalker <miki@dds.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090309013005.66a71767@caramujo.chehab.org>
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
	 <20090306074604.10926b03@pedra.chehab.org>
	 <1236439661.7569.132.camel@miki-desktop>
	 <alpine.LRH.2.00.0903081354030.17407@pedra.chehab.org>
	 <1236565064.7149.49.camel@miki-desktop>
	 <20090309013005.66a71767@caramujo.chehab.org>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 14:57:22 +0100
Message-Id: <1236607042.5982.7.camel@miki-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op maandag 09-03-2009 om 01:30 uur [tijdzone -0300], schreef Mauro
Carvalho Chehab:
> I'm not sure if Kernel has a default language convention for this. Probably, it
> has, but I can't find anything on Documentation/*. Otherwise, I would vote for
> using -ISE on both options.
> 
> Hmm... maybe we can just grep for both and see what happens most on Kernel:
> 
> $ git grep -i customise|wc
>     256    1451   19677
> 
> $ git grep -i customize|wc
>     115     733    9986
> 
> It seems that the Britain way is more popular.

I would vote to stick with -ise also, since it is used most in the
kernel, and also to hono(u)r the fact that Linus, who started it all, is
European. No offen{c,s}e to the many people from the Americas who
contribute great and valuable work to it! :-)

Kind regards,

Alain

