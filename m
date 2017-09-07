Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55129 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932287AbdIGWTI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 18:19:08 -0400
Message-ID: <1504822731.11339.2.camel@collabora.com>
Subject: Re: [PATCH v3 14/15] fs/files: export close_fd() symbol
From: Gustavo Padovan <gustavo.padovan@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Riley Andrews <riandrews@android.com>
Date: Thu, 07 Sep 2017 19:18:51 -0300
In-Reply-To: <73f8820e-216b-5d7e-87e7-7a8b90bfb0d2@xs4all.nl>
References: <20170907184226.27482-1-gustavo@padovan.org>
         <20170907184226.27482-15-gustavo@padovan.org>
         <73f8820e-216b-5d7e-87e7-7a8b90bfb0d2@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-09-08 at 00:09 +0200, Hans Verkuil wrote:
> On 09/07/2017 08:42 PM, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Rename __close_fd() to close_fd() and export it to be able close
> > files
> > in modules using file descriptors.
> > 
> > The usecase that motivates this change happens in V4L2 where we
> > send
> > events to userspace with a fd that has file installed in it. But if
> > for
> > some reason we have to cancel the video stream we need to close the
> > files
> > that haven't been shared with userspace yet. Thus the export of
> > close_fd() becomes necessary.
> > 
> > fd_install() happens when we call an ioctl to queue a buffer, but
> > we only
> > share the fd with userspace later, and that may happen in a kernel
> > thread
> > instead.
> 
> This isn't the way to do this.
> 
> You should only create the out fence file descriptor when userspace
> dequeues
> (i.e. calls VIDIOC_DQEVENT) the BUF_QUEUED event. That's when you
> give it to
> userspace and at that moment closing the fd is the responsibility of
> userspace.
> There is no point creating it earlier anyway since userspace can't
> get to it
> until it dequeues the event.
> 
> It does mean some more work in the V4L2 core since you need to hook
> into the
> DQEVENT code in order to do this.

Right, that makes a lot more sense. I'll change the implementation so
it can reflecting that. Thanks.

Gustavo
