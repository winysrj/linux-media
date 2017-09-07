Return-path: <linux-media-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59026 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755580AbdIGWD2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 18:03:28 -0400
Date: Thu, 7 Sep 2017 23:03:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-fsdevel@vger.kernel.org,
        Riley Andrews <riandrews@android.com>
Subject: Re: [PATCH v3 14/15] fs/files: export close_fd() symbol
Message-ID: <20170907220325.GY5426@ZenIV.linux.org.uk>
References: <20170907184226.27482-1-gustavo@padovan.org>
 <20170907184226.27482-15-gustavo@padovan.org>
 <20170907203610.GX5426@ZenIV.linux.org.uk>
 <20170907212245.GA19307@jade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907212245.GA19307@jade>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 07, 2017 at 06:22:45PM -0300, Gustavo Padovan wrote:

> Sorry for my lack of knowledge here and thank you for the explanation,
> things are a lot clear to me. For some reasons I were trying to delay
> the sharing of the fd to a event later. I can delay the install of it
> but that my require __fd_install() to be available and exportedi as it
> may happen in a thread, but I believe you wouldn't be okay with that either,
> is that so?

Only if it has been given a reference to descriptor table to start with.
Which reference should've been acquired by the target process itself.

Why bother, anyway?  You need to handle the case when the stream has
ended just after you'd copied the value to userland; at that point you
obviously can't go hunting for all references to struct file in question,
so you have to guaratee that methods will start giving an error from
that point on.  What's the problem with just leaving it installed?

Both userland and kernel must cope with that sort of thing anyway, so
what does removing it from descriptor table and not reporting it buy
you?  AFAICS, it's an extra layer of complexity for no good reason -
you are not getting it offset by simplifications anywhere else...
