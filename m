Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:35424 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdIGVWw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 17:22:52 -0400
Date: Thu, 7 Sep 2017 18:22:45 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-fsdevel@vger.kernel.org,
        Riley Andrews <riandrews@android.com>
Subject: Re: [PATCH v3 14/15] fs/files: export close_fd() symbol
Message-ID: <20170907212245.GA19307@jade>
References: <20170907184226.27482-1-gustavo@padovan.org>
 <20170907184226.27482-15-gustavo@padovan.org>
 <20170907203610.GX5426@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907203610.GX5426@ZenIV.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-09-07 Al Viro <viro@ZenIV.linux.org.uk>:

> On Thu, Sep 07, 2017 at 03:42:25PM -0300, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Rename __close_fd() to close_fd() and export it to be able close files
> > in modules using file descriptors.
> > 
> > The usecase that motivates this change happens in V4L2 where we send
> > events to userspace with a fd that has file installed in it. But if for
> > some reason we have to cancel the video stream we need to close the files
> > that haven't been shared with userspace yet. Thus the export of
> > close_fd() becomes necessary.
> > 
> > fd_install() happens when we call an ioctl to queue a buffer, but we only
> > share the fd with userspace later, and that may happen in a kernel thread
> > instead.
> 
> NAK.  As soon as the reference is in descriptor table, you *can't* do anything
> to it.  This "sharing" part is complete BS - being _told_ that descriptor is
> there does not matter at all.  That descriptor might be hit with dup2() as
> soon as fd_install() has happened.  Or be closed, or any number of other things.
> 
> You can not take it back.  Once fd_install() is done, it's fucking done, period.
> If V4L2 requires removing it from descriptor table, it's a shitty API and needs
> to be fixed.

Sorry for my lack of knowledge here and thank you for the explanation,
things are a lot clear to me. For some reasons I were trying to delay
the sharing of the fd to a event later. I can delay the install of it
but that my require __fd_install() to be available and exportedi as it
may happen in a thread, but I believe you wouldn't be okay with that either,
is that so?

Gustavo
