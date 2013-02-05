Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874Ab3BEUoB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Feb 2013 15:44:01 -0500
Date: Tue, 5 Feb 2013 18:43:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.8] Exynos/s5p driver fixes
Message-ID: <20130205184356.7e513290@redhat.com>
In-Reply-To: <50FAA6C4.9020606@gmail.com>
References: <50FAA6C4.9020606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 19 Jan 2013 14:59:32 +0100
Sylwester Nawrocki <sylvester.nawrocki@gmail.com> escreveu:

> Hi Mauro,
> 
> The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:
> 
>    Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)
> 
> are available in the git repository at:
>    git://linuxtv.org/snawrocki/samsung.git v3.8-rc5-fixes
> 
> Kamil Debski (1):
>        s5p-mfc: end-of-stream handling in encoder bug fix
> 
> Sylwester Nawrocki (2):
>        s5p-fimc: Fix fimc-lite entities deregistration
>        s5p-csis: Fix clock handling on error path in probe()
> 
>   drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
>   drivers/media/platform/s5p-fimc/mipi-csis.c    |    2 +-
>   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c   |    2 ++
>   3 files changed, 4 insertions(+), 2 deletions(-)
> 
> 
> pwclient update -s accepted 16223
> pwclient update -s accepted 16206
> pwclient update -s accepted 16314

Error:

Importing patches from git://linuxtv.org/snawrocki/samsung.git v3.8-rc5-fixes
fatal: Couldn't find remote ref v3.8-rc5-fixes

Regards,
Mauro
