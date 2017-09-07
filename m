Return-path: <linux-media-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57440 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751884AbdIGUgO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 16:36:14 -0400
Date: Thu, 7 Sep 2017 21:36:11 +0100
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
Message-ID: <20170907203610.GX5426@ZenIV.linux.org.uk>
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

NAK.  As soon as the reference is in descriptor table, you *can't* do anything
to it.  This "sharing" part is complete BS - being _told_ that descriptor is
there does not matter at all.  That descriptor might be hit with dup2() as
soon as fd_install() has happened.  Or be closed, or any number of other things.

You can not take it back.  Once fd_install() is done, it's fucking done, period.
If V4L2 requires removing it from descriptor table, it's a shitty API and needs
to be fixed.

Again, NAK.
