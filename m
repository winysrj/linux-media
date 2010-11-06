Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:54018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0KFW2x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Nov 2010 18:28:53 -0400
Message-ID: <4CD5D67F.9040307@redhat.com>
Date: Sat, 06 Nov 2010 18:28:15 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org,
	Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 0/5] Re: REGRESSION: Re: [GIT] kconfig rc fixes
References: <4CD300AC.3010708@redhat.com> <1289079027-3037-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289079027-3037-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 06-11-2010 17:30, Arnaud Lacombe escreveu:
> Hi,
> 
> This should do the job.
> 

Thank you, Arnaud! Good job!

I'm currently at the airport preparing to take an international flight
to return back home from LPC. I'll test your patch series tomorrow or more likely
during the beginning of the next week. There are probably few more drivers/media
Kconfig files that need to use "visible if" option to remove all warnings, 
but it will be a trivial fix.

Thanks!
Mauro

> A.
> 
> Arnaud Lacombe (5):
>   kconfig: add an option to determine a menu's visibility
>   kconfig: regen parser
>   Revert "i2c: Fix Kconfig dependencies"
>   media/video: convert Kconfig to use the menu's `visible' keyword
>   i2c/algos: convert Kconfig to use the menu's `visible' keyword
> 
>  drivers/i2c/Kconfig                  |    3 +-
>  drivers/i2c/algos/Kconfig            |   14 +-
>  drivers/media/video/Kconfig          |    2 +-
>  scripts/kconfig/expr.h               |    1 +
>  scripts/kconfig/lkc.h                |    1 +
>  scripts/kconfig/menu.c               |   11 +
>  scripts/kconfig/zconf.gperf          |    1 +
>  scripts/kconfig/zconf.hash.c_shipped |  122 ++++----
>  scripts/kconfig/zconf.tab.c_shipped  |  570 +++++++++++++++++----------------
>  scripts/kconfig/zconf.y              |   21 +-
>  10 files changed, 393 insertions(+), 353 deletions(-)
> 

