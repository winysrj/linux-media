Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36425 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752538AbdIGSvu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 14:51:50 -0400
Date: Thu, 7 Sep 2017 11:51:47 -0700
From: Eric Biggers <ebiggers3@gmail.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Riley Andrews <riandrews@android.com>
Subject: Re: [PATCH v3 14/15] fs/files: export close_fd() symbol
Message-ID: <20170907185147.GB92996@gmail.com>
References: <20170907184226.27482-1-gustavo@padovan.org>
 <20170907184226.27482-15-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907184226.27482-15-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 07, 2017 at 03:42:25PM -0300, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Rename __close_fd() to close_fd() and export it to be able close files
> in modules using file descriptors.
> 
> The usecase that motivates this change happens in V4L2 where we send
> events to userspace with a fd that has file installed in it. But if for
> some reason we have to cancel the video stream we need to close the files
> that haven't been shared with userspace yet. Thus the export of
> close_fd() becomes necessary.
> 
> fd_install() happens when we call an ioctl to queue a buffer, but we only
> share the fd with userspace later, and that may happen in a kernel thread
> instead.

What do you mean?  A file descriptor is shared with userspace as soon as it's
installed in the fdtable by fd_install().  As soon as it's there, another thread
can use it (or close it, duplicate it, etc.), even before the syscall that
installed it returns...

Eric
