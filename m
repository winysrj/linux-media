Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34939 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755745AbeDYP60 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 11:58:26 -0400
MIME-Version: 1.0
In-Reply-To: <20180425152636.GC27076@infradead.org>
References: <20180424204158.2764095-1-arnd@arndb.de> <20180425061537.GA23383@infradead.org>
 <CAK8P3a06ragAPWpHGm-bGoZ8t6QyAttWJfD0jU_wcGy7FqLb5w@mail.gmail.com>
 <20180425072138.GA16375@infradead.org> <CAK8P3a1cs_SPesadAQhV3QU97WjNE8bLPSQCfaMQRU7zr_oh3w@mail.gmail.com>
 <20180425152636.GC27076@infradead.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 25 Apr 2018 17:58:25 +0200
Message-ID: <CAK8P3a0CHSC7yP3x8xDJgcg5xMzD1-sC-rmBJECtYvGFmyG4vQ@mail.gmail.com>
Subject: Re: [PATCH] media: zoran: move to dma-mapping interface
To: Christoph Hellwig <hch@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        mjpeg-users@lists.sourceforge.net,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Trent Piepho <tpiepho@impinj.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 5:26 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Apr 25, 2018 at 01:15:18PM +0200, Arnd Bergmann wrote:
>> That thought had occurred to me as well. I removed the oldest ISDN
>> drivers already some years ago, and the OSS sound drivers
>> got removed as well, and comedi got converted to the dma-mapping
>> interfaces, so there isn't much left at all now. This is what we
>> have as of v4.17-rc1:
>
> Yes, I've been looking at various grotty old bits to purge.  Usually
> I've been looking for some non-tree wide patches and CCed the last
> active people to see if they care.  In a few cases people do, but
> most often no one does.

Let's start with this one (zoran) then, as Mauro is keen on having
all media drivers compile-testable on x86-64 and arm.

Trent Piepho and Hans Verkuil both worked on this driver in the
2008/2009 timeframe and those were the last commits from anyone
who appears to have tested their patches on actual hardware.

Trent, Hans: do you have reason to believe that there might still
be users out there?

       Arnd
