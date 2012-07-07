Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35115 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2GGAWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 20:22:54 -0400
Received: by werb14 with SMTP id b14so6732369wer.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 17:22:53 -0700 (PDT)
Message-ID: <4FF7815A.2040709@gmail.com>
Date: Sat, 07 Jul 2012 02:22:50 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.5] S5P driver fixes
References: <4FEC864D.5040608@samsung.com> <4FEDEE7C.7080105@samsung.com> <4FF73821.9010108@redhat.com> <4FF74306.2030000@gmail.com> <4FF7689C.8040602@redhat.com>
In-Reply-To: <4FF7689C.8040602@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2012 12:37 AM, Mauro Carvalho Chehab wrote:
> I pushed the branch with the fixes into my experimental tree:
> 	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/v4l_for_linus
> 
> Could you please check what's missing there and rebase the pending patches for it?

It looks good, there are only 2 patches missing (from
git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes):

df5772f Revert "[media] V4L: JPEG class documentation corrections"
196073a s5p-fimc: Add missing FIMC-LITE file operations locking

They applied cleanly without a need to rebase.

I pushed everything for reference to:
 git@github.com:snawrocki/linux.git mchehab-experimental

https://github.com/snawrocki/linux/commits/mchehab-experimental

Sorry for the hassle. Next time I'll try not to send subsequent pull request
when any previous one is pending.

--

Regards,
Sylwester


