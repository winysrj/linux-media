Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49486 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2GDT21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2012 15:28:27 -0400
Received: by bkwj10 with SMTP id j10so2873328bkw.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2012 12:28:26 -0700 (PDT)
Message-ID: <4FF49957.3070604@gmail.com>
Date: Wed, 04 Jul 2012 21:28:23 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.6] mostly remove V4L2_FL_LOCK_ALL_FOPS
References: <201207041942.04606.hverkuil@xs4all.nl>
In-Reply-To: <201207041942.04606.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 07/04/2012 07:42 PM, Hans Verkuil wrote:
> Hi Mauro,
> 
> This pull request builds on (and includes) this core patch series:
> 
> http://patchwork.linuxtv.org/patch/13180/
> 
> It is identical to the RFC patch series I posted before:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg48184.html
> 
> ...except that I dropped the patches touching s5p-fimc and fimc-lite and the
> final patch removing the flag altogether.
> 
> Sylwester posted patches for those two drivers, but they won't apply. Sylwester,
> can you rebase those patches? Once I have those, then I can make another pull
> request that fixes those two drivers and removes the flag completely.

First of all, sorry about the trouble. These patches are available at:

git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-next

The first one was already included in a pull request with fixes for 3.5-rc:
http://patchwork.linuxtv.org/patch/13149. It is not really needed for
your V4L2_FL_LOCK_ALL_FOPS removal changeset. You only need the top one from 
the above branch.

The reason why those 2 patches won't apply to the current media tree is 
a pending fixups pull request from over a month ago - 
http://patchwork.linuxtv.org/patch/11503. These are mostly important fixes 
for new code that went into 3.5, and I'm really not happy they're still not 
upstream :(

So I would propose you to merge v4l-fimc-fixes branch from
git://git.infradead.org/users/kmpark/linux-samsung, then there won't be
any merge conflicts.

Please feel free to add the top patch: 
"s5p-fimc: Remove V4L2_FL_LOCK_ALL_FOPS flag"
to your pull request including the patch removing V4L2_FL_LOCK_ALL_FOPS.

Here is a gitweb link:
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/v4l-fimc-next


--
Regards,
Sylwester
