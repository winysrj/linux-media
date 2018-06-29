Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39792 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753626AbeF2Rtm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 13:49:42 -0400
Message-ID: <525de8a0124b2c8630cb8badf21a4746dfd33883.camel@collabora.com>
Subject: Re: [PATCH 1/2] v4l-helpers: Don't close the fd in {}_s_fd
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Date: Fri, 29 Jun 2018 14:49:35 -0300
In-Reply-To: <6b727801-5055-928d-4005-39caaf09200f@xs4all.nl>
References: <20180628192557.22966-1-ezequiel@collabora.com>
         <6b727801-5055-928d-4005-39caaf09200f@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-06-29 at 09:03 +0200, Hans Verkuil wrote:
> On 06/28/2018 09:25 PM, Ezequiel Garcia wrote:
> > When creating a second node via copy or assignment:
> > 
> >     node2 = node
> > 
> > The node being assigned to, i.e. node2, obtains the fd.
> > This causes a later call to node2.media_open to close()
> > the fd, thus unintendenly closing the original node fd,
> > via the call path (e.g. for media devices):
> > 
> >   node2.media_open
> >      v4l_media_open
> >         v4l_media_s_fd
> > 
> > Similar call paths apply for other device types.
> > Fix this by removing the close in xxx_s_fd.
> 
> I fixed this in a different way by overloading the assignment
> operator
> and calling dup(fd). That solves this as well.
> 

Yes, but I am now seeing another EBADF error in the compliance run.

close(3)                                = 0
openat(AT_FDCWD, "/dev/video2", O_RDWR) = 3
close(3)                                = 0
ioctl(3, VIDIOC_QUERYCAP, 0x7ffe54788794) = -1 EBADF
close(3)                                = -1 EBADF

Let me see if I can dig it.
