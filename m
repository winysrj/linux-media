Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40016 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752339AbcJWUGC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 16:06:02 -0400
Date: Sun, 23 Oct 2016 21:05:58 +0100
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [media] mb86a20s: always initialize a return value
Message-ID: <20161023200558.GA14624@dell-m4800.home>
References: <20160910164901.2901-1-nicolas.iooss_linux@m4x.org>
 <93d6d621-88eb-a573-40a8-94571f95b327@m4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93d6d621-88eb-a573-40a8-94571f95b327@m4x.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 23, 2016 at 07:09:10PM +0200, Nicolas Iooss wrote:
> Hello,
> 
> I sent the following patch (available on
> https://patchwork.kernel.org/patch/9325035/) a few weeks ago and got no
> feedback even though the bug it fixes seems to still exist in
> linux-next. Did I do something wrong? Should I consider this patch to be
> rejected?

No, it's extremely unlikely that bug fixing patches get silently
rejected by being ignored. Most probably the time of your submission is
unfortunate, being at the time when submissions are not merged.
I am in same situation with a couple of patches. I asked Mauro yesterday
on IRC and he replied:

I don't handle submissions during 3 weeks, during the merge window
one week before, and the two weeks after that
except when it is a bug that would affect the merge window
(end  of quote)

So unless you make it clear about which "release branches" are affected,
your submission is to be delayed - possibly up to 6 weeks or so.

I was suggested to add tags Fixes: buggy-commit-id and
Cc: stable@vger.kernel.org
